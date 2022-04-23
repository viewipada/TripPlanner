# from doctest import testsource
# import json
# from traceback import print_tb


# import numpy as np


# x = '{ "name":"John", "age":30, "city":"New York"}'
# z = '{ "name":"mook", "age":22, "city":"Thailand"}'

# # parse x:
# y = [1,2]
# y.append(x)
# for i in range(2):
#     print(i)
# y.append(json.loads(z))
# # the result is a Python dictionary:
# print(y)

# final1 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
# data = '{ "name":"John", "age":30, "city":"New York"}'
# data2 = '{ "name":"mook", "age":22, "city":"Thailand"}'

# b = np.where in (final1)

# final1.append(data)
# final1.append(data2)
# final = json.dumps(final1)
# print(final1)
# print(b)

# jsonStr = '{"a":1, "b":2}'
# # aList = json.loads(jsonStr)
# # print(aList)

# # a = np.arange(10)
# # print(a)
# # alist = [0, 1, 2, 3, 4]
# # # b = np.where(aList)
# # b1 = np.where(a)
# # print(np.where(a < 50))
# # # print(b)
# # print(b1)

# # test = [[1,2,3]]
# # # print("")
# # print(type(test))

# data = 	{
#   "id": 4,
#   "username": "Goggag",
#   "password": "123456aA",
#   "imgUrl": "https://thumbs.dreamstime.com/b/woman-laptop-icon-flat-style-illustration-vector-web-design-163519381.jpg",
#   "birthDate": "2000-10-09T00:00:00+00:00",
#   "gender": "male",
#   "role": "user"
# }
# print(type(data))
# # final = json.load(data)
# print(data["id"])
import datetime
import pandas as pd

# now = datetime.datetime.now()
# s = pd.to_datetime(['9/17/1966 01:37', '11/13/1937 19:20',
#                     '1/5/1964 20:05', '11/13/1937 0:00'])

# # data_time = data, format='%Y-%m-%d_%H:%M:%S.%f'
# # age = (now.date() - data.astype)('<m8[Y]')
# input = '2000-10-09T00:00:00+00:00'
# input2 = '2020-01-06T00:00:00.000Z'
# format = '%Y-%m-%d %H:%M:%S'
# format2 = '%Y-%m-%d'

# # now = datetime.datetime.now()
# # data = datetime.datetime.fromisoformat(input)
# # final = data.strftime(format2)
# # birthdate = datetime.datetime.strptime(final, format2)
# # one_or_zero = ((now.month, now.day) < (birthdate.month, birthdate.day))
# # year_difference = now.year - birthdate.year
# # age = year_difference - one_or_zero

# # birthdate = now.strptime(now, format2)

# # print("now",now.date())
# # print("data",data.date())
# # print("final",final)
# # print('birthdate',birthdate.date())
# # print(type(final))
# # # age = now.date() - data.astype
# # print("age",age)
# # g = "gg"
# # print("k"+g+"l")

# # data = datetime.datetime.fromisoformat('2020-01-06T00:00:00.000Z'[:-1] + '+00:00')
# # final = data.strftime('%Y-%m-%d %H:%M:%S')
# # # data = datetime.datetime(2020, 1, 6, 3, 0, tzinfo=datetime.timezone.utc)
# # print(data)
# # print(final)
# from random import randint

# final_type_location = ["1ihikjhl","3hkgyu","jkjvvg5","bhjblh7","kjljblhjb9","11","13","15"]
# # print("len = ",len(data))
# type_location = []
# # i = 1
# # while i <= len(data):
# #     r = randint(0, len(data)-1)
# #     data_check = data[r]
# #     if data_check not in new_r: 
# #         new_r.append(data[r])
# #         i = i+1

# data = [[1,2,7]]
# print(data)
# print(data[0][2])
# data = data[0].pop(2)
# print("final",data)

# i = 1
# while i <= len(final_type_location):
#     r = randint(0, len(final_type_location)-1)
#     location_check = final_type_location[r]
#     if location_check not in type_location: 
#         type_location.append(final_type_location[r])
#         i = i + 1
#         print("type_location",type_location)



# from datetime import datetime
# from datetime import timedelta
# import time

# import responses
# import googlemaps

# import requests
# from haversine import haversine, Unit
# from googlemaps import convert
# from pprint import pprint

# API_KEY = 'AIzaSyC3IbO2CjNOMP1g1F_Y7jamCp0aEu4asKE'

# map_client = googlemaps.Client(API_KEY)

# l = [(14.5931616442162, 100.38006288184202), (14.593349574908624, 100.45974649718559)]

# def _has_method(arg, method):
#     return hasattr(arg, method) and callable(getattr(arg, method))

# def _is_list(arg):
#     """Checks if arg is list-like. This excludes strings and dicts."""
#     if isinstance(arg, dict):
#         return False
#     if isinstance(arg, str): # Python 3-only, as str has __iter__
#         return False
#     return _has_method(arg, "__getitem__") if not _has_method(arg, "strip") else _has_method(arg, "__iter__")

# def normalize_lat_lng(arg):
#     """Take the various lat/lng representations and return a tuple.
#     Accepts various representations:
#     1) dict with two entries - "lat" and "lng"
#     2) list or tuple - e.g. (-33, 151) or [-33, 151]
#     :param arg: The lat/lng pair.
#     :type arg: dict or list or tuple
#     :rtype: tuple (lat, lng)
#     """
#     if isinstance(arg, dict):
#         if "lat" in arg and "lng" in arg:
#             return arg["lat"], arg["lng"]
#         if "latitude" in arg and "longitude" in arg:
#             return arg["latitude"], arg["longitude"]

#     # List or tuple.
#     if _is_list(arg):
#         return arg[0], arg[1]

#     raise TypeError(
#         "Expected a lat/lng dict or tuple, "
#         "but got %s" % type(arg).__name__)

# def encode_polyline(points):
#     last_lat = last_lng = 0
#     result = ""

#     for point in points:
#         ll = normalize_lat_lng(point)
#         lat = int(round(ll[0] * 1e5))
#         lng = int(round(ll[1] * 1e5))
#         d_lat = lat - last_lat
#         d_lng = lng - last_lng

#         for v in [d_lat, d_lng]:
#             v = ~(v << 1) if v < 0 else v << 1
#             while v >= 0x20:
#                 result += (chr((0x20 | (v & 0x1f)) + 63))
#                 v >>= 5
#             result += (chr(v + 63))

#         last_lat = lat
#         last_lng = lng

#     return result

# def encode_coords(coords):
#     '''Encodes a polyline using Google's polyline algorithm
    
#     See http://code.google.com/apis/maps/documentation/polylinealgorithm.html 
#     for more information.
    
#     :param coords: Coordinates to transform (list of tuples in order: latitude, 
#     longitude).
#     :type coords: list
#     :returns: Google-encoded polyline string.
#     :rtype: string    
#     '''
    
#     result = []
    
#     prev_lat = 0
#     prev_lng = 0
    
#     for x, y in coords:        
#         lat, lng = int(y * 1e5), int(x * 1e5)
        
#         d_lat = _encode_value(lat - prev_lat)
#         d_lng = _encode_value(lng - prev_lng)        
        
#         prev_lat, prev_lng = lat, lng
        
#         result.append(d_lat)
#         result.append(d_lng)
#     print("result = ",result)
    
#     return ''.join(c for r in result for c in r)
    
# def _split_into_chunks(value):
#     while value >= 32: #2^5, while there are at least 5 bits
        
#         # first & with 2^5-1, zeros out all the bits other than the first five
#         # then OR with 0x20 if another bit chunk follows
#         yield (value & 31) | 0x20 
#         value >>= 5
#     yield value

# def _encode_value(value):
#     # Step 2 & 4
#     value = ~(value << 1) if value < 0 else (value << 1)
    
#     # Step 5 - 8
#     chunks = _split_into_chunks(value)
    
#     # Step 9-10
#     return (chr(chunk + 63) for chunk in chunks)
 
# def decode(point_str):
#     '''Decodes a polyline that has been encoded using Google's algorithm
#     http://code.google.com/apis/maps/documentation/polylinealgorithm.html
     
#     This is a generic method that returns a list of (latitude, longitude) 
#     tuples.
     
#     :param point_str: Encoded polyline string.
#     :type point_str: string
#     :returns: List of 2-tuples where each tuple is (latitude, longitude)
#     :rtype: list
     
#     '''
             
#     # sone coordinate offset is represented by 4 to 5 binary chunks
#     coord_chunks = [[]]
#     for char in point_str:
         
#         # convert each character to decimal from ascii
#         value = ord(char) - 63
         
#         # values that have a chunk following have an extra 1 on the left
#         split_after = not (value & 0x20)         
#         value &= 0x1F
         
#         coord_chunks[-1].append(value)
         
#         if split_after:
#                 coord_chunks.append([])
         
#     del coord_chunks[-1]
     
#     coords = []
     
#     for coord_chunk in coord_chunks:
#         coord = 0
         
#         for i, chunk in enumerate(coord_chunk):                    
#             coord |= chunk << (i * 5) #there is a 1 on the right if the coord is negative if coord & 0x1: coord = ~coord #invert coord >>= 1
#         coord /= 100000.0
                     
#         coords.append(coord)
     
#     # convert the 1 dimensional list to a 2 dimensional list and offsets to 
#     # actual values
#     points = []
#     prev_x = 0
#     prev_y = 0
#     for i in range(0, len(coords) - 1, 2):
#         if coords[i] == 0 and coords[i + 1] == 0:
#             continue
         
#         prev_x += coords[i + 1]
#         prev_y += coords[i]
#         # a round to 6 digits ensures that the floats are the same as when 
#         # they were encoded
#         points.append((round(prev_x, 6), round(prev_y, 6)))
     
#     return points 

# def encode_coords(coords):
#     '''Encodes a polyline using Google's polyline algorithm
    
#     See http://code.google.com/apis/maps/documentation/polylinealgorithm.html 
#     for more information.
    
#     :param coords: Coordinates to transform (list of tuples in order: latitude, 
#     longitude).
#     :type coords: list
#     :returns: Google-encoded polyline string.
#     :rtype: string    
#     '''
    
#     result = []
    
#     prev_lat = 0
#     prev_lng = 0
    
#     for x, y in coords:        
#         lat, lng = int(y * 1e5), int(x * 1e5)
        
#         d_lat = _encode_value(lat - prev_lat)
#         d_lng = _encode_value(lng - prev_lng)        
        
#         prev_lat, prev_lng = lat, lng
        
#         result.append(d_lat)
#         result.append(d_lng)
    
#     return ''.join(c for r in result for c in r)
    
# def _split_into_chunks(value):
#     while value >= 32: #2^5, while there are at least 5 bits
        
#         # first & with 2^5-1, zeros out all the bits other than the first five
#         # then OR with 0x20 if another bit chunk follows
#         yield (value & 31) | 0x20 
#         value >>= 5
#     yield value

# def _encode_value(value):
#     # Step 2 & 4
#     value = ~(value << 1) if value < 0 else (value << 1)
    
#     # Step 5 - 8
#     chunks = _split_into_chunks(value)
    
#     # Step 9-10
#     return (chr(chunk + 63) for chunk in chunks)

# def decode(point_str):
#     '''Decodes a polyline that has been encoded using Google's algorithm
#     http://code.google.com/apis/maps/documentation/polylinealgorithm.html
    
#     This is a generic method that returns a list of (latitude, longitude) 
#     tuples.
    
#     :param point_str: Encoded polyline string.
#     :type point_str: string
#     :returns: List of 2-tuples where each tuple is (latitude, longitude)
#     :rtype: list
    
#     '''
            
#     # sone coordinate offset is represented by 4 to 5 binary chunks
#     coord_chunks = [[]]
#     for char in point_str:
        
#         # convert each character to decimal from ascii
#         value = ord(char) - 63
        
#         # values that have a chunk following have an extra 1 on the left
#         split_after = not (value & 0x20)         
#         value &= 0x1F
        
#         coord_chunks[-1].append(value)
        
#         if split_after:
#                 coord_chunks.append([])
        
#     del coord_chunks[-1]
    
#     coords = []
    
#     for coord_chunk in coord_chunks:
#         coord = 0
        
#         for i, chunk in enumerate(coord_chunk):                    
#             coord |= chunk << (i * 5) 
        
#         #there is a 1 on the right if the coord is negative
#         if coord & 0x1:
#             coord = ~coord #invert
#         coord >>= 1
#         coord /= 100000.0
                    
#         coords.append(coord)
    
#     # convert the 1 dimensional list to a 2 dimensional list and offsets to 
#     # actual values
#     points = []
#     prev_x = 0
#     prev_y = 0
#     for i in range(0, len(coords) - 1, 2):
#         if coords[i] == 0 and coords[i + 1] == 0:
#             continue
        
#         prev_x += coords[i + 1]
#         prev_y += coords[i]
#         # a round to 6 digits ensures that the floats are the same as when 
#         # they were encoded
#         points.append((round(prev_x, 6), round(prev_y, 6)))
    
#     return points    

# # ---------------------------------------------
# l22 = '14.5931616442162,100.38006288184202'
# l33 = '14.593349574908624,100.45974649718559'
# ---------------------------------------------

# path = 'https://maps.googleapis.com/maps/api/directions/json?'
# origin = 'origin='+ l22
# destination = '&destination='+l33
# key_client = '&key=AIzaSyC3IbO2CjNOMP1g1F_Y7jamCp0aEu4asKE'

# url2 = path+origin+destination+key_client
# print("url2 = ",url2)

# payload={}
# headers = {}

# response = requests.request("GET", url2, headers=headers, data=payload)

# data = response.text

# print(type(response))
# response_dict = response.json()
# print("response_dict = ", type(response_dict), response_dict)


# ---------------------------------------------
# print("Text = ", response.text)
# jsonstr = json.dumps(response_dict)
# ---------------------------------------------

# dictList=[]
# input1 = dictList[1][1][0]["overview_polyline"]["points"]
# print("1 : ",input1)

# for key, value in response_dict.items():
#     dictList.append([key, value])

# print("dictList",dictList)
# for i in range(len(dictList)):
#     print(i+1," = ",dictList[i])

# for i in range(len(dictList[1])):
#     print(i,"of routes = ",dictList[1][i])
# ---------------------------------------------
# final = decode(input1)
# print("final = ",type(final),final)
# ---------------------------------------------

# final_mock = [(100.38008, 14.593), (100.38056, 14.59301), (100.38127, 14.59302), 
#  (100.38153, 14.59301), (100.38156, 14.59317), (100.38215, 14.59652), (100.3822, 14.59694), 
#  (100.3822, 14.59744), (100.3821, 14.59883), (100.38198, 14.60069), (100.38189, 14.60169), 
#  (100.38157, 14.60165), (100.37882, 14.60136), (100.37851, 14.60133), (100.37848, 14.60144), 
#  (100.37865, 14.60146), (100.38059, 14.60167), (100.38183, 14.60177), (100.3846, 14.60205), 
#  (100.39114, 14.60273), (100.39267, 14.60288), (100.39452, 14.60303), (100.39544, 14.60315), 
#  (100.39751, 14.60337), (100.3987, 14.60348), (100.40178, 14.60382), (100.40424, 14.60407), 
#  (100.40727, 14.60438), (100.41069, 14.60475), (100.41142, 14.60483), (100.41244, 14.60495), 
#  (100.42015, 14.60578), (100.42234, 14.60601), (100.42243, 14.60605), (100.42251, 14.60588), 
#  (100.42273, 14.6053), (100.42308, 14.60448), (100.42332, 14.60418), (100.42355, 14.60397), 
#  (100.42372, 14.60385), (100.42399, 14.60371), (100.42413, 14.60366), (100.42464, 14.60354), 
#  (100.42499, 14.60345), (100.4261, 14.60324), (100.42691, 14.60307), (100.42779, 14.60284), 
#  (100.42898, 14.60258), (100.42959, 14.60241), (100.43014, 14.60226), (100.43158, 14.6019), 
#  (100.43219, 14.60174), (100.43353, 14.60141), (100.43404, 14.60128), (100.43526, 14.60099), 
#  (100.4359, 14.60083), (100.4364, 14.60071), (100.43723, 14.60044), (100.43772, 14.60024), 
#  (100.43926, 14.59963), (100.43962, 14.59948), (100.44005, 14.59935), (100.44068, 14.5991), 
#  (100.4411, 14.59893), (100.44223, 14.59849), (100.44237, 14.59842), (100.44332, 14.59803), 
#  (100.44357, 14.59786), (100.44369, 14.59775), (100.44386, 14.59751), (100.444, 14.59724), 
#  (100.44417, 14.59653), (100.44438, 14.5956), (100.4448, 14.59368), (100.44488, 14.5933), 
#  (100.44506, 14.5931), (100.44522, 14.59299), (100.44554, 14.5929), (100.4466, 14.5931), 
#  (100.44695, 14.59316), (100.44742, 14.59323), (100.44829, 14.5934), (100.44968, 14.5936), 
#  (100.45009, 14.59368), (100.45058, 14.59377), (100.45086, 14.59379), (100.45106, 14.59378), 
#  (100.45123, 14.59377), (100.45161, 14.59357), (100.45185, 14.59342), (100.45204, 14.59323), 
#  (100.45208, 14.59319), (100.45217, 14.59307), (100.4523, 14.59276), (100.45258, 14.59214), 
#  (100.45263, 14.59204), (100.45285, 14.59211), (100.45319, 14.59224), (100.45405, 14.59257), 
#  (100.4544, 14.59257), (100.45506, 14.59273), (100.45563, 14.59284), (100.45624, 14.59308), 
#  (100.45748, 14.59335), (100.45831, 14.59332), (100.45867, 14.59334), (100.45901, 14.59333), 
#  (100.45946, 14.59341), (100.45972, 14.59347)]

# # l2 = [14.5931616442162, 100.38006288184202]
# import google_api

lat1 = 14.5931616442162
long1 = 100.38006288184202
lat2 = 14.593349574908624
long2 = 100.45974649718559

# list_distance = google_api.distance_between_location(lat1,long1,lat2,long2)
# print("gg = ",type(list_distance),list_distance)

# #long,lat
latitude =  14.5931616442162
longitude = 100.38006288184202
data_latlong = []
data_latlong.append(longitude)
data_latlong.append(latitude)
# print("data_latlong",data_latlong)
# l2 = [100.38006288184202, 14.5931616442162]
# l3 = [14.593349574908624, 100.45974649718559]
# j = 1
# for i in list_distance:
#     # print(j,"=",haversine(i,l2))
#     hs = haversine(i,data_latlong)
#     if hs < 5:
#         print(j,"=",hs)
#     j += 1

# # print("distance = ", haversine(l2,l3))
# print(0 == 0.0)

l1 = 14.593349574908624
l2 = 100.45974649718559

x = [
  {
    "locationId": 13,
    "age":10
  },
  {
    "locationId": 5,
    "age":17
  },
  {
    "locationId": 4,
    "age":16
  },
  {
    "locationId": 8,
    "age":12
  },
  {
    "locationId": 11,
    "age":8
  },
]

for i in x:
    data_items = i.items()
    data_list = list(data_items)

    df = pd.DataFrame(data_list)
# data = {}     
# print(type(x),type(x[0])) 
# print(x[0].keys(),x[0].values())


# for i in x:
    # resulti = dict(i.items()
    


# x[0][da.keys] = da.values
# print(da)
# temp = 0
# for i in range(0,len(x)):
#     for j in range(i+1,len(x)):
#         if x[i]["locationId"] > x[j]["locationId"]:
#             temp = x[i]["locationId"]
#             x[i]["locationId"] = x[j]["locationId"]
#             x[j]["locationId"] = temp
# print("yes",x)


a = { "organization":"GeeksForGeeks",
    "city":"Noida",
    "country":"India"}
# print(type(a),x)
# c = {"distance": 1.252} 
# x[0]["distance"] = 1.25
# print(x[0])

# c = 1.54543216464324
# c = format(c,'.2f')
# print(c)
