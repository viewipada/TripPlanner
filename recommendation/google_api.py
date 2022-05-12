
# from datetime import datetime
# from datetime import timedelta
# import time

# import responses
import googlemaps

import requests
from haversine import haversine, Unit
# from googlemaps import convert
# from pprint import pprint

API_KEY = 'AIzaSyC3IbO2CjNOMP1g1F_Y7jamCp0aEu4asKE'

map_client = googlemaps.Client(API_KEY)

# l = [(14.5931616442162, 100.38006288184202), (14.593349574908624, 100.45974649718559)]

def _has_method(arg, method):
    return hasattr(arg, method) and callable(getattr(arg, method))

def _is_list(arg):
    """Checks if arg is list-like. This excludes strings and dicts."""
    if isinstance(arg, dict):
        return False
    if isinstance(arg, str): # Python 3-only, as str has __iter__
        return False
    return _has_method(arg, "__getitem__") if not _has_method(arg, "strip") else _has_method(arg, "__iter__")

def normalize_lat_lng(arg):
    """Take the various lat/lng representations and return a tuple.
    Accepts various representations:
    1) dict with two entries - "lat" and "lng"
    2) list or tuple - e.g. (-33, 151) or [-33, 151]
    :param arg: The lat/lng pair.
    :type arg: dict or list or tuple
    :rtype: tuple (lat, lng)
    """
    if isinstance(arg, dict):
        if "lat" in arg and "lng" in arg:
            return arg["lat"], arg["lng"]
        if "latitude" in arg and "longitude" in arg:
            return arg["latitude"], arg["longitude"]

    # List or tuple.
    if _is_list(arg):
        return arg[0], arg[1]

    raise TypeError(
        "Expected a lat/lng dict or tuple, "
        "but got %s" % type(arg).__name__)

def encode_polyline(points):
    last_lat = last_lng = 0
    result = ""

    for point in points:
        ll = normalize_lat_lng(point)
        lat = int(round(ll[0] * 1e5))
        lng = int(round(ll[1] * 1e5))
        d_lat = lat - last_lat
        d_lng = lng - last_lng

        for v in [d_lat, d_lng]:
            v = ~(v << 1) if v < 0 else v << 1
            while v >= 0x20:
                result += (chr((0x20 | (v & 0x1f)) + 63))
                v >>= 5
            result += (chr(v + 63))

        last_lat = lat
        last_lng = lng

    return result

def encode_coords(coords):
    '''Encodes a polyline using Google's polyline algorithm
    
    See http://code.google.com/apis/maps/documentation/polylinealgorithm.html 
    for more information.
    
    :param coords: Coordinates to transform (list of tuples in order: latitude, 
    longitude).
    :type coords: list
    :returns: Google-encoded polyline string.
    :rtype: string    
    '''
    
    result = []
    
    prev_lat = 0
    prev_lng = 0
    
    for x, y in coords:        
        lat, lng = int(y * 1e5), int(x * 1e5)
        
        d_lat = _encode_value(lat - prev_lat)
        d_lng = _encode_value(lng - prev_lng)        
        
        prev_lat, prev_lng = lat, lng
        
        result.append(d_lat)
        result.append(d_lng)
    print("result = ",result)
    
    return ''.join(c for r in result for c in r)
    
def _split_into_chunks(value):
    while value >= 32: #2^5, while there are at least 5 bits
        
        # first & with 2^5-1, zeros out all the bits other than the first five
        # then OR with 0x20 if another bit chunk follows
        yield (value & 31) | 0x20 
        value >>= 5
    yield value

def _encode_value(value):
    # Step 2 & 4
    value = ~(value << 1) if value < 0 else (value << 1)
    
    # Step 5 - 8
    chunks = _split_into_chunks(value)
    
    # Step 9-10
    return (chr(chunk + 63) for chunk in chunks)
 
def decode(point_str):
    '''Decodes a polyline that has been encoded using Google's algorithm
    http://code.google.com/apis/maps/documentation/polylinealgorithm.html
     
    This is a generic method that returns a list of (latitude, longitude) 
    tuples.
     
    :param point_str: Encoded polyline string.
    :type point_str: string
    :returns: List of 2-tuples where each tuple is (latitude, longitude)
    :rtype: list
     
    '''
             
    # sone coordinate offset is represented by 4 to 5 binary chunks
    coord_chunks = [[]]
    for char in point_str:
         
        # convert each character to decimal from ascii
        value = ord(char) - 63
         
        # values that have a chunk following have an extra 1 on the left
        split_after = not (value & 0x20)         
        value &= 0x1F
         
        coord_chunks[-1].append(value)
         
        if split_after:
                coord_chunks.append([])
         
    del coord_chunks[-1]
     
    coords = []
     
    for coord_chunk in coord_chunks:
        coord = 0
         
        for i, chunk in enumerate(coord_chunk):                    
            coord |= chunk << (i * 5) #there is a 1 on the right if the coord is negative if coord & 0x1: coord = ~coord #invert coord >>= 1
        coord /= 100000.0
                     
        coords.append(coord)
     
    # convert the 1 dimensional list to a 2 dimensional list and offsets to 
    # actual values
    points = []
    prev_x = 0
    prev_y = 0
    for i in range(0, len(coords) - 1, 2):
        if coords[i] == 0 and coords[i + 1] == 0:
            continue
         
        prev_x += coords[i + 1]
        prev_y += coords[i]
        # a round to 6 digits ensures that the floats are the same as when 
        # they were encoded
        points.append((round(prev_x, 6), round(prev_y, 6)))
     
    return points 

def encode_coords(coords):
    '''Encodes a polyline using Google's polyline algorithm
    
    See http://code.google.com/apis/maps/documentation/polylinealgorithm.html 
    for more information.
    
    :param coords: Coordinates to transform (list of tuples in order: latitude, 
    longitude).
    :type coords: list
    :returns: Google-encoded polyline string.
    :rtype: string    
    '''
    
    result = []
    
    prev_lat = 0
    prev_lng = 0
    
    for x, y in coords:        
        lat, lng = int(y * 1e5), int(x * 1e5)
        
        d_lat = _encode_value(lat - prev_lat)
        d_lng = _encode_value(lng - prev_lng)        
        
        prev_lat, prev_lng = lat, lng
        
        result.append(d_lat)
        result.append(d_lng)
    
    return ''.join(c for r in result for c in r)
    
def _split_into_chunks(value):
    while value >= 32: #2^5, while there are at least 5 bits
        
        # first & with 2^5-1, zeros out all the bits other than the first five
        # then OR with 0x20 if another bit chunk follows
        yield (value & 31) | 0x20 
        value >>= 5
    yield value

def _encode_value(value):
    # Step 2 & 4
    value = ~(value << 1) if value < 0 else (value << 1)
    
    # Step 5 - 8
    chunks = _split_into_chunks(value)
    
    # Step 9-10
    return (chr(chunk + 63) for chunk in chunks)

def decode(point_str):
    '''Decodes a polyline that has been encoded using Google's algorithm
    http://code.google.com/apis/maps/documentation/polylinealgorithm.html
    
    This is a generic method that returns a list of (latitude, longitude) 
    tuples.
    
    :param point_str: Encoded polyline string.
    :type point_str: string
    :returns: List of 2-tuples where each tuple is (latitude, longitude)
    :rtype: list
    
    '''
            
    # sone coordinate offset is represented by 4 to 5 binary chunks
    coord_chunks = [[]]
    for char in point_str:
        
        # convert each character to decimal from ascii
        value = ord(char) - 63
        
        # values that have a chunk following have an extra 1 on the left
        split_after = not (value & 0x20)         
        value &= 0x1F
        
        coord_chunks[-1].append(value)
        
        if split_after:
                coord_chunks.append([])
        
    del coord_chunks[-1]
    
    coords = []
    
    for coord_chunk in coord_chunks:
        coord = 0
        
        for i, chunk in enumerate(coord_chunk):                    
            coord |= chunk << (i * 5) 
        
        #there is a 1 on the right if the coord is negative
        if coord & 0x1:
            coord = ~coord #invert
        coord >>= 1
        coord /= 100000.0
                    
        coords.append(coord)
    
    # convert the 1 dimensional list to a 2 dimensional list and offsets to 
    # actual values
    points = []
    prev_x = 0
    prev_y = 0
    for i in range(0, len(coords) - 1, 2):
        if coords[i] == 0 and coords[i + 1] == 0:
            continue
        
        prev_x += coords[i + 1]
        prev_y += coords[i]
        # a round to 6 digits ensures that the floats are the same as when 
        # they were encoded
        points.append((round(prev_x, 6), round(prev_y, 6)))
    
    return points    

# ---------------------------------------------
l22 = '14.5931616442162,100.38006288184202'
l33 = '14.593349574908624,100.45974649718559'
# ---------------------------------------------

def distance_between_location(lat1,long1,lat2,long2):
        
    path = 'https://maps.googleapis.com/maps/api/directions/json?'
    origin = 'origin='+ str(lat1) + ',' + str(long1)
    destination = '&destination=' + str(lat2) + ',' + str(long2)
    key_client = '&key=AIzaSyC3IbO2CjNOMP1g1F_Y7jamCp0aEu4asKE'

    url = path+origin+destination+key_client

    payload={}
    headers = {}

    response = requests.request("GET", url, headers=headers, data=payload)
    data = response.text
    response_dict = response.json()

    dictList=[]
    for key, value in response_dict.items():
        dictList.append([key, value])

    polyline_str = dictList[1][1][0]["overview_polyline"]["points"]
    polyline_list = decode(polyline_str)
    # print("final = ",type(polyline_list),polyline_list)

    return polyline_list

# lat1 = 14.5931616442162
# long1 = 100.38006288184202
# lat2 = 14.593349574908624
# long2 = 100.45974649718559
# dis = distance_between_location(lat1,long1,lat2,long2)
# print("dis = ",type(dis),dis)

# cd recommendation
# .env\Scripts\activate
# uvicorn main:app --reload
# pip install aiohttp
