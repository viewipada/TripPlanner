from datetime import date, datetime
# from tkinter import DoubleVar
from tokenize import Triple
# from sqlite3 import Date
# from h11 import Data
import pandas as pd
import numpy as np
from joblib import PrintTime, dump, load
from random import randint

from sklearn.metrics.pairwise import cosine_similarity
from sklearn.metrics import pairwise_distances
from sklearn.model_selection import train_test_split
from fastapi import FastAPI, status, HTTPException, Request

import sqlalchemy
import uvicorn
import joblib
import re
import json
import asyncpg

import databases
import sqlalchemy

from pydantic import BaseModel, Field
from typing import Optional, List
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import session

from haversine import haversine, Unit
import googlemaps
import google_api
from pyrecord import Record

# import csv
# import sys
# import postgres_copy
# import from folderName import filename

# database
SQLALCHEMY_DATABASE_URL = "postgresql://zfmsgbtyaipvev:0701919781293d9d17ff3aa96c31a3e91d70f6ea43e241179ffe6076e9d6e938@ec2-3-215-83-124.compute-1.amazonaws.com:5432/d3ngpebd1au102"

engine = sqlalchemy.create_engine(SQLALCHEMY_DATABASE_URL)
database = databases.Database(SQLALCHEMY_DATABASE_URL)
metadata = sqlalchemy.MetaData()

metadata.create_all(engine)
Base = declarative_base()

app = FastAPI()

# uvicorn main:app --root-path /api/v1
# app = FastAPI(root_path="")

# ============================================ Location table ============================================
locations = sqlalchemy.Table(
    "locations",
    metadata,
    sqlalchemy.Column("locationId", sqlalchemy.Integer, primary_key=True),
    sqlalchemy.Column("locationName", sqlalchemy.String(50)),
    sqlalchemy.Column("category", sqlalchemy.Integer),
    sqlalchemy.Column("description", sqlalchemy.String(300)),
    sqlalchemy.Column("contactNumber", sqlalchemy.String(10)),
    sqlalchemy.Column("website", sqlalchemy.String),
    sqlalchemy.Column("duration", sqlalchemy.Integer),
    sqlalchemy.Column("type", sqlalchemy.String),
    sqlalchemy.Column("imageUrl", sqlalchemy.String(500)),
    sqlalchemy.Column("latitude", sqlalchemy.Float),
    sqlalchemy.Column("longitude", sqlalchemy.Float),
    sqlalchemy.Column("province", sqlalchemy.String(100), default="Angthong"),
    sqlalchemy.Column("averageRating", sqlalchemy.Float),
    sqlalchemy.Column("totalCheckin", sqlalchemy.Integer),
    sqlalchemy.Column("createBy", sqlalchemy.Integer),
    sqlalchemy.Column("locationStatus", sqlalchemy.String(15),
                      default="inprogress"),
)


class Location(BaseModel):  # serializer
    locationId: int
    locationName: str = None
    category: int
    description: str = None
    contactNumber: str = None
    website: str = None
    duration: int = None
    type: str
    imageUrl: str = None
    latitude: float
    longitude: float
    province: str = None
    averageRating: float
    totalCheckin: int = None
    createBy: int = None
    locationStatus: str = None


# ============================================ User table ============================================
users = sqlalchemy.Table(
    "users",
    metadata,
    sqlalchemy.Column("id", sqlalchemy.Integer, primary_key=True),
    sqlalchemy.Column("username", sqlalchemy.String(15)),
    sqlalchemy.Column("password", sqlalchemy.String),
    sqlalchemy.Column("imgUrl", sqlalchemy.String),
    sqlalchemy.Column("birthDate", sqlalchemy.Date),
    sqlalchemy.Column("gender", sqlalchemy.String),
    sqlalchemy.Column("role", sqlalchemy.String),
)


class User(BaseModel):  # serializer
    id: int
    username: str = None
    password: str = None
    imgUrl: str = None
    birthDate: datetime = None
    gender: str = None
    role: str = None


# ============================================ User Interest Table ============================================
user_interested = sqlalchemy.Table(
    "userInteresteds",
    metadata,
    sqlalchemy.Column("userId", sqlalchemy.Integer, primary_key=True),
    sqlalchemy.Column("first_activity", sqlalchemy.String),
    sqlalchemy.Column("second_activity", sqlalchemy.String),
    sqlalchemy.Column("third_activity", sqlalchemy.String),
    sqlalchemy.Column("first_food", sqlalchemy.String),
    sqlalchemy.Column("second_food", sqlalchemy.String),
    sqlalchemy.Column("third_food", sqlalchemy.String),
    sqlalchemy.Column("first_hotel", sqlalchemy.String),
    sqlalchemy.Column("second_hotel", sqlalchemy.String),
    sqlalchemy.Column("third_hotel", sqlalchemy.String),
    sqlalchemy.Column("min_price", sqlalchemy.Integer),
    sqlalchemy.Column("max_price", sqlalchemy.Integer),
)


class User_interested(BaseModel):  # serializer
    userId: int
    first_activity: str
    second_activity: str
    third_activity: str
    first_food: str
    second_food: str
    third_food: str
    first_hotel: str
    second_hotel: str
    third_hotel: str 
    min_price: int = None
    max_price: int = None

# ============================================ review Table ============================================


reviews = sqlalchemy.Table(
    "reviews",
    metadata,
    sqlalchemy.Column("userId", sqlalchemy.Integer, primary_key=True),
    sqlalchemy.Column("locationId", sqlalchemy.Integer, primary_key=True),
    sqlalchemy.Column("reviewRate", sqlalchemy.Integer),
    sqlalchemy.Column("reviewCaption", sqlalchemy.String(120)),
    sqlalchemy.Column("reviewImg1", sqlalchemy.String),
    sqlalchemy.Column("reviewImg2", sqlalchemy.String),
    sqlalchemy.Column("reviewImg3", sqlalchemy.String),
)


class Review(BaseModel):  # serializer
    userId: int
    locationId: int
    reviewRate: int
    reviewCaption: str = None
    reviewImg1: str = None
    reviewImg2: str = None
    reviewImg3: str = None


# ============================================ Trip Table ============================================
trips = sqlalchemy.Table(
    "trips",
    metadata,
    sqlalchemy.Column("id", sqlalchemy.Integer, primary_key=True),
    sqlalchemy.Column("userId", sqlalchemy.Integer),
    sqlalchemy.Column("name", sqlalchemy.String(30)),
    sqlalchemy.Column("totalPeople", sqlalchemy.Integer),
    sqlalchemy.Column("totalDay", sqlalchemy.Integer),
    sqlalchemy.Column("startDate", sqlalchemy.Date),
    sqlalchemy.Column("firstLocation", sqlalchemy.String),
    sqlalchemy.Column("lastLocation", sqlalchemy.String),
    sqlalchemy.Column("thumnail", sqlalchemy.String),
    sqlalchemy.Column("status", sqlalchemy.String(15)),
)


class Trip(BaseModel):  # serializer
    # tripId: int
    # userId: int
    # tripName: str
    # totalPeople: int = None
    # sumOfLocation: int = None
    # travelingDay: datetime = None
    # startedPoint: str = None
    # endedPoint: str = None
    # imageUrl: str = None
    # status: str = None

    id: int
    userId: int
    name: str = None
    totalPeople: int = None
    totalDay: int = None
    startDate: datetime = None
    firstLocation: str = None
    lastLocation: str = None
    thumnail: str = None
    status: str = None


tripitems = sqlalchemy.Table(
    "tripItems",
    metadata,
    sqlalchemy.Column("tripId", sqlalchemy.Integer),
    sqlalchemy.Column("day", sqlalchemy.Integer),
    sqlalchemy.Column("order", sqlalchemy.Integer),
    sqlalchemy.Column("locationId", sqlalchemy.Integer),
    sqlalchemy.Column("locationName", sqlalchemy.String),
    sqlalchemy.Column("imageUrl", sqlalchemy.String),
    sqlalchemy.Column("lat", sqlalchemy.Float),
    sqlalchemy.Column("lng", sqlalchemy.Float),
    sqlalchemy.Column("locationCategory", sqlalchemy.Integer),
    sqlalchemy.Column("startTime", sqlalchemy.Date),
    sqlalchemy.Column("distance", sqlalchemy.Float),
    sqlalchemy.Column("duration", sqlalchemy.Integer),
    sqlalchemy.Column("drivingDuration", sqlalchemy.Integer),
    sqlalchemy.Column("note", sqlalchemy.String),
)


class Tripitem(BaseModel):  # serializer
    tripId: int
    day: int = None
    order: int = None
    locationId: int = None
    locationName: str = None
    imageUrl: str = None
    lat: float = None
    lng: float = None
    locationCategory: int = None
    startTime: datetime = None
    distance: float = None
    duration: int = None
    drivingDuration:  int = None
    note: str = None


class Config:
    orm_mode = True

# db = SessionLocal()
# ============================================ Fastapi ============================================


@app.on_event("startup")
async def startup():
    await database.connect()


@app.on_event("shutdown")
async def shutdown():
    await database.disconnect()


# ============================================ location api ============================================
@app.get('/location/{location_id}', response_model=Location, status_code=status.HTTP_200_OK)
async def get_an_item(location_id: int):
    location = locations.select().where(locations.c.locationId == location_id)
    data = database.fetch_one(location)
    return await data


# @app.get('/all_location/', response_model=List[Location], status_code=status.HTTP_200_OK)
# async def all_location():
#     query = locations.select()
#     final = await database.fetch_all(query)
#     data = []
#     for i in range(0, len(final)):
#         result = dict(final[i].items())
#         if final[i]["locationStatus"] == "Approved":
#             data.append(final[i])

#     # print("len all location", len(query))
#     return data


# @app.get('/location_type/{location_type}', response_model=List[Location], status_code=status.HTTP_200_OK)
# async def get_location_type(location_type: str):
#     location = locations.select().where(locations.c.type == str(location_type))
#     data = database.fetch_all(location)
#     # print("data type = ",type(data))
#     return await data


@app.get('/location_category/{category}', response_model=List[Location], status_code=status.HTTP_200_OK)
async def get_location_category(category: int):
    if category == 0:
        location = locations.select()
        data = database.fetch_all(location)
    else:
        location = locations.select().where(locations.c.category == category)
        data = database.fetch_all(location)
    return await data


@app.get('/all_location_order/{category}', response_model=List[Location], status_code=status.HTTP_200_OK)
async def all_location_order(category: int):
    if category == 0:
        location = locations.select()
        data = await database.fetch_all(location)
    else:
        # .where(locations.c.category == category) // .order_by("locationId")
        location = locations.select().where(locations.c.category == category)
        data = await database.fetch_all(location)

    for i in range(0, len(data)):
        for j in range(i+1, len(data)):
            resulti = dict(data[i].items())
            resultj = dict(data[j].items())
            if resulti["locationId"] > resultj["locationId"]:
                temp = data[i]
                data[i] = data[j]
                data[j] = temp

    return data


# ============================================ user api ==============================================
@app.get('/user/{user_id}', response_model=User, status_code=status.HTTP_200_OK)
async def get_user(user_id: int):
    user = users.select().where(users.c.id == user_id)
    data = database.fetch_one(user)
    return await data


# @app.get('/all_of_user/', response_model=[User], status_code=status.HTTP_200_OK)
# async def all_of_user():
#     user = users.select()
#     data = database.fetch_all(user)
#     return await data


@app.get('/user_interested/{user_id}', response_model=User_interested, status_code=status.HTTP_200_OK)
async def get_an_user(user_id: int):
    user = user_interested.select().where(user_interested.c.userId == user_id)
    data = database.fetch_one(user)
    return await data


@app.get('/user_interested', response_model=List[User_interested], status_code=status.HTTP_200_OK)
async def get_all_user():
    user = user_interested.select()
    data = database.fetch_all(user)
    return await data


# ============================================ hybrid api ==============================================
#  response_model=List[Review],status_code=status.HTTP_200_OK
@app.get("/hybrid_trip/{user_id}")
async def hybrid_trip(user_id: int):
    review = reviews.select().where(reviews.c.userId == user_id)
    data = await database.fetch_all(review)
    hybrid = 0
    if len(data) >= 10:
        hybrid = 1
    else:
        hybrid = 0
    return hybrid


@app.get("/recomendation_home/{user_id}")
async def hybrid_home(user_id: int):
    review = reviews.select().where(reviews.c.userId == user_id)
    data = await database.fetch_all(review)
    if len(data) >= 10:
        data1 = await rating_home(user_id)
        print(" colla")
    else:
        data1 = await get_Type_location(user_id)
        print("demo")

    for i in range(0, len(data1)):
        for j in range(i+1, len(data1)):
            resulti = dict(data1[i].items())
            resultj = dict(data1[j].items())
            if resulti["averageRating"] < resultj["averageRating"]:
                if data1[i]["locationStatus"] == "Approved":
                    temp = data1[i]
                    data1[i] = data1[j]
                    data1[j] = temp
    return data1


# ============================================ nearly api ==============================================

@app.get('/recommendation_nearly_user/{user_id},{category},{lat1},{long1},{lat2},{long2}')
async def recommendation_nearly_user(user_id: int, category: int, lat1: float, long1: float, lat2: float, long2: float):

    if category == 0:
        location = locations.select()
        data = await database.fetch_all(location)
        catstat = 0
    else:
        location = locations.select().where(locations.c.category == category)
        data = await database.fetch_all(location)
        catstat = category
    # print("catstat = ", catstat)

    if lat2 == 0 and long2 == 0:
        print("state = Start")
        list_distance = []
        radius = 8
        l = (long1, lat1)
        list_distance.append(l)
    elif lat1 == 0 and long1 == 0:
        print("state = destination")
        list_distance = []
        radius = 8
        l = (long2, lat2)
        list_distance.append(l)
    else:
        print("state = between")
        list_distance = []
        radius = 3
        list_distance = google_api.distance_between_location(
            lat1, long1, lat2, long2)

    data_longlat = []
    data_hs_nodis = []
    data_hs = []
    test = []
    hs = 0
    bf_hs = 0
    for i in range(len(data)):
        data_latitude = data[i]['latitude']
        data_longitude = data[i]['longitude']
        data_longlat.append(data_longitude)
        data_longlat.append(data_latitude)
        bf_hs = 0
        for j in list_distance:
            # hs = haversine(j,data_longlat)
            hs = haversine2(j[0], j[1], data_longitude, data_latitude)
            # อยู่ในรัศมีที่กำหนดและ latlong ไม่ตรงกับ latlong เป้าหมาย
            if hs < radius and data[i]['latitude'] != j[1] and data[i]['longitude'] != j[0]:
                # print("data hs = ",i,data[i]["locationId"],hs)
                if hs < bf_hs or bf_hs == 0:
                    test = data[i]
                    bf_hs = hs
                    # print("yes = ",bf_hs,"test = ",test["locationId"])
        if test != [] and data[i] not in data_hs_nodis:
            hs = format(bf_hs, '.2f')
            d = dict(data[i].items())
            d["distance"] = float(hs)
            data_hs_nodis.append(data[i])
            if d["locationStatus"] == "Approved":
                data_hs.append(d)
        # print("Hello = ",i,data[i]["locationId"],hs)
        test = []
        data_longlat = []

    hybrid = await hybrid_trip(user_id)
    final_data = []

    if hybrid == 0:
        print("hybrid = 0")
        demo = await decision_tree_nearby(user_id, category)
        # print("len demo = ", len(demo))
        for i in demo:
            for k in range(len(data_hs)):
                if int(i["locationId"]) == int(data_hs[k]["locationId"]):
                    if i not in final_data:
                        if data_hs[k]["locationStatus"] == "Approved":
                            final_data.append(data_hs[k])
        print("demo = ", len(final_data))
    elif hybrid == 1:
        print("hybrid = 1")
        colla = await rating_database(user_id)
        # print("len colla = ", len(colla))
        len_hs = len(data_hs)

        for j in colla:
            for k in range(len(data_hs)):
                if int(j["locationId"]) == int(data_hs[k]["locationId"]):
                    if j not in final_data:
                        if data_hs[k]["locationStatus"] == "Approved":
                            final_data.append(data_hs[k])
        if len(final_data) == 0 or len(final_data) <= 5:
            print("Switched model because can not use collaborative model")
            demo = await decision_tree_nearby(user_id, category)
            print("len demo = ", len(demo))
            final_data = []
            for i in demo:
                for k in range(len(data_hs)):
                    if int(i["locationId"]) == int(data_hs[k]["locationId"]):
                        if i not in final_data:
                            if data_hs[k]["locationStatus"] == "Approved":
                                final_data.append(data_hs[k])

    if len(final_data) == 0:
        final_data = data_hs
        if len(final_data) == 0:
            print("Sorry but don't have location near user ")
        else:
            print("print all data because don't have recommendation data")
    
    if radius == 3:
        final_nodis = []
        finaldis = []
        for i in final_data:
            hs = haversine2(long1, lat1, i['longitude'], i['latitude'])
            if i not in final_nodis:
                hs = format(hs, '.2f')
                d = dict(i.items())
                d["distance"] = float(hs)
                final_nodis.append(i)
                if d["locationStatus"] == "Approved":
                    finaldis.append(d)

        for i in range(0, len(finaldis)):
            for j in range(i+1, len(finaldis)):
                resulti = dict(finaldis[i].items())
                resultj = dict(finaldis[j].items())
                if resulti["distance"] > resultj["distance"]:
                    temp = finaldis[i]
                    finaldis[i] = finaldis[j]
                    finaldis[j] = temp
    else:
        for i in range(0, len(final_data)):
            for j in range(i+1, len(final_data)):
                resulti = dict(final_data[i].items())
                resultj = dict(final_data[j].items())
                if resulti["distance"] > resultj["distance"]:
                    temp = final_data[i]
                    final_data[i] = final_data[j]
                    final_data[j] = temp
        finaldis = final_data

    print("len data_hs = ", len(data_hs))
    print("len finaldis = ", len(finaldis))

    return finaldis

# ============================================ rating api ==============================================
@app.get("/rating_home_cattravel/{user_id}", response_model=List[Location], status_code=status.HTTP_200_OK)
async def rating_home(user_id: int):

    review = reviews.select()
    data = await database.fetch_all(review)
    print("1")

    df = pd.DataFrame.from_records(data)
    df.to_csv(index=False)
    # df = pd.read_csv("test.csv")

    x_train, x_test = train_test_split(
        df, test_size=0.30, random_state=42)

    user_data = x_train.pivot(
        index='userId', columns='locationId', values='reviewRate').fillna(0)
    dummy_train = x_train.pivot(
        index='userId', columns='locationId', values='reviewRate').fillna(0)
    dummy_test = x_test.pivot(
        index='userId', columns='locationId', values='reviewRate').fillna(1)
    # print("dummy_train",dummy_train)

    test = user_data
    test['user_index'] = np.arange(0, dummy_train.shape[0], 1)
    test.set_index(['user_index'], inplace=True)

    user_similarity = cosine_similarity(test)
    user_similarity[np.isnan(user_similarity)] = 0

    user_predicted_ratings = np.dot(user_similarity, test)
    user_final_ratings = np.multiply(user_predicted_ratings, dummy_train)
    # print("user_final_ratings",user_final_ratings)

    user_final_ratings = user_final_ratings.loc[user_id].sort_values(ascending=False)[
        :].keys().to_list()
    # print("user_final_ratings = ", len(user_final_ratings), user_final_ratings)

    # data_location = []
    # print("user_final_ratings = ",user_final_ratings)
    # for i in user_final_ratings:
    #     location = locations.select().where(
    #         locations.c.locationId == (i))
    #     location_db = await database.fetch_one(location)
    #     data_location.append(location_db)


    # print("data_location = ", len(data_location))
    # final_data = []
    # sum_i = 0
    # while len(final_data) < 10 and len(final_data) <= len(data_location):
    #     print("sum = ",sum_i," = ",data_location[sum_i]["locationId"])
    #     if data_location[sum_i] not in final_data and data_location[sum_i]["category"] == 1:
    #         final_data.append(data_location)
    #         print("final_data = ", len(final_data))
    #     sum_i += 1

    final_data = []
    sum_i = 10
    status = 0
    user = []
    while len(final_data) < 10 and sum_i <= len(user_final_ratings):
        if len(final_data) < 10 and status == 1:
            user = user_final_ratings[sum_i-1:sum_i]
            # print("go2", user)  # ++ptint importan
        else:
            user = user_final_ratings[:10]
            status = 1
            # print("not go2", user)

        for i in user:
            # print("sim_location_forrrrr = ", i)
            location = locations.select().where(
                locations.c.locationId == int(i))
            data_location = await database.fetch_one(location)
            if data_location not in final_data and data_location["category"] == 1:
                final_data.append(data_location)
                # print("final_data = ", len(final_data))

        if len(final_data) <= 10:
            sum_i = sum_i + 1
        # print("sum =",sum_i)

    return final_data


@app.get("/rating_database/{user_id}", response_model=List[Location], status_code=status.HTTP_200_OK)
async def rating_database(user_id: int):

    review = reviews.select()
    all_data = await database.fetch_all(review)

    df = pd.DataFrame.from_records(all_data)
    df.to_csv(index=False)

    x_train, x_test = train_test_split(
        df, test_size=0.30, random_state=42)

    user_data = x_train.pivot(
        index='userId', columns='locationId', values='reviewRate').fillna(0)
    dummy_train = x_train.pivot(
        index='userId', columns='locationId', values='reviewRate').fillna(0)
    dummy_test = x_test.pivot(
        index='userId', columns='locationId', values='reviewRate').fillna(1)

    test = user_data
    test['user_index'] = np.arange(0, dummy_train.shape[0], 1)
    test.set_index(['user_index'], inplace=True)

    user_similarity = cosine_similarity(test)
    user_similarity[np.isnan(user_similarity)] = 0

    user_predicted_ratings = np.dot(user_similarity, test)
    user_final_ratings = np.multiply(user_predicted_ratings, dummy_train)

    # print(user_final_ratings.iloc[1].sort_values(ascending = False)[:])

    user_final_ratings = user_final_ratings.loc[user_id].sort_values(ascending=False)[
        :].keys().to_list()
    # print("user_final_ratings", len(user_final_ratings), user_final_ratings)

    location = locations.select().where(
        locations.c.locationId.in_(user_final_ratings))
    data = await database.fetch_all(location)

    return data


@app.get("/rating_trip/{user_id}")
async def rating_trip(user_id: int):

    review = reviews.select()
    all_data = await database.fetch_all(review)

    user = users.select()
    data_user = await database.fetch_all(user)

    df = pd.DataFrame.from_records(all_data)
    df.to_csv(index=False)

    x_train, x_test = train_test_split(
        df, test_size=0.30, random_state=42)

    user_data = x_train.pivot(
        index='userId', columns='locationId', values='reviewRate').fillna(0)
    dummy_train = x_train.pivot(
        index='userId', columns='locationId', values='reviewRate').fillna(0)
    dummy_test = x_test.pivot(
        index='userId', columns='locationId', values='reviewRate').fillna(1)
    # print("train = ",dummy_train.head(10))

    cosine = cosine_similarity(dummy_train)
    np.fill_diagonal(cosine, 0)
    similarity_with_user = pd.DataFrame(cosine, index=dummy_train.index)
    similarity_with_user.columns = dummy_train.index
    # print("similarity_with_user",similarity_with_user.head(10))
    # print(similarity_with_user.shape)

    def find_n_neighbours(df, n):
        order = np.argsort(df.values, axis=1)[:, :n]
        df = df.apply(lambda x: pd.Series(x.sort_values(ascending=False)
                                          .iloc[:n].index,
                                          index=['top{}'.format(i) for i in range(1, n+1)]), axis=1)
        return df
    # print("finish")
    # sum_i = 5
    # status = 0
    # g = 1
    # final_list = []
    num = len(similarity_with_user.sum(axis=0))
    # print("num",num)
    sim_user = find_n_neighbours(similarity_with_user, num)
    # print("data_user_interest = ", len(all_data),
    #       len(sim_user))  # ++ptint importan
    all_sim = sim_user.iloc[user_id][:].to_list()
    return all_sim


# @app.get("/rating_data_mock/{User_id}", response_model=List[Location], status_code=status.HTTP_200_OK)
# async def rating_data_mock(User_id: int):
#     final_rating = colla_model(User_id)
#     location = locations.select().where(locations.c.locationId.in_(final_rating))
#     data = database.fetch_all(location)
#     return await data


# ============================================ decition tree api ==============================================
@app.get("/Decision_tree_10/{user_id}", response_model=List[Location], status_code=status.HTTP_200_OK)
async def get_Type_location(user_id: int):

    data = await get_user(user_id)
    data_user_interest = await get_an_user(user_id)

    x_predict = [[]]
    code_Age = 1

    data_gender = data['gender']
    # print(data_gender)
    Dict_gender = {'หญิง': 1, 'ชาย': 2, 'male': 2}
    code_gender = Dict_gender[data_gender]
    x_predict[0].append(code_gender)
    # print("code_gender = ", code_gender)

    input_age = data['birthDate']
    # print("input_age = ", input_age)
    # print(type(input_age))
    format_age = '%Y-%m-%d'
    now = datetime.now()
    one_or_zero = ((now.month, now.day) < (input_age.month, input_age.day))
    year_difference = now.year - input_age.year
    data_age = year_difference - one_or_zero
    # print("data_age = ",data_age)

    if data_age >= 0 and data_age < 18:
        code_Age == 1
    elif data_age >= 18 and data_age <= 25:
        code_Age == 2
    elif data_age >= 26 and data_age <= 35:
        code_Age == 3
    elif data_age >= 36 and data_age <= 55:
        code_Age == 4
    else:
        code_Age == 5
    x_predict[0].append(code_Age)
    # print("code_age = ",code_Age)
    data_activity = []
    code_activity = []
    all_location = []
    final_type_location = []

    data_activity.append(data_user_interest["first_activity"])
    data_activity.append(data_user_interest["second_activity"])
    data_activity.append(data_user_interest["third_activity"])

    print("activity = ", data_activity)
    Dict_activity = {'บันจี้จัมป์': 1, 'ปีนเขา': 1, 'ปาร์ตี้': 2, 'ดูพระอาทิตย์ขึ้น-ตก': 3,
                     'ดูทะเลหมอก': 3, 'พายเรือล่องแก่ง': 4, 'ล่องเรือ': 4, 'ดูสวนดอกไม้': 5, 'ดูงานศิลปะ': 6,
                     'สำรวจประวัติศาสตร์': 7, 'ชุมชน/เมืองจำลอง': 8, 'ถ่ายภาพสถานที่': 8}
    code_activity.append(Dict_activity[data_activity[0]])
    code_activity.append(Dict_activity[data_activity[1]])
    code_activity.append(Dict_activity[data_activity[2]])
    # print("code activity = ", code_activity)
    output_activity = []
    for i in range(3):
        x_predict[0].append(code_activity[i])
        # print("code_activity[i]",code_activity[i])
        # print("x_predict[0].append(code_activity[i]) = ",x_predict)
        if code_activity[i] not in output_activity:
            output_activity.append(code_activity[i])
            type_location = decision_tree(x_predict)
            data_location_type = locations.select().where(locations.c.type == type_location)
            final_data_type = await database.fetch_all(data_location_type)
            print("len final_data_type = ",len(final_data_type))
            
            for i in range(len(final_data_type)):
                final_type_location.append(final_data_type[i])
        x_predict[0].pop(2)

    i = 1
    while i <= len(final_type_location):
        r = randint(0, len(final_type_location)-1)
        location_check = final_type_location[r]
        if location_check not in all_location:
            all_location.append(final_type_location[r])
            i = i + 1

    return all_location[:10]


@app.get("/decision_tree_nearby/{user_id},{category}", response_model=List[Location], status_code=status.HTTP_200_OK)
async def decision_tree_nearby(user_id: int, category: int):

    data = await get_user(user_id)
    data_user_interest = await get_an_user(user_id)

    if category == 1:
        print("cat = 1")
        x_predict = [[]]
        code_Age = 1

        data_gender = data['gender']
        Dict_gender = {'หญิง': 1, 'ชาย': 2}
        code_gender = Dict_gender[data_gender]
        x_predict[0].append(code_gender)

        input_age = data['birthDate']
        format_age = '%Y-%m-%d'
        now = datetime.now()
        one_or_zero = ((now.month, now.day) < (input_age.month, input_age.day))
        year_difference = now.year - input_age.year
        data_age = year_difference - one_or_zero

        if data_age >= 0 and data_age < 18:
            code_Age == 1
        elif data_age >= 18 and data_age <= 25:
            code_Age == 2
        elif data_age >= 26 and data_age <= 35:
            code_Age == 3
        elif data_age >= 36 and data_age <= 55:
            code_Age == 4
        else:
            code_Age == 5
        x_predict[0].append(code_Age)

        data_activity = []
        code_activity = []
        all_location = []
        final_type_location = []

        data_activity.append(data_user_interest["first_activity"])
        data_activity.append(data_user_interest["second_activity"])
        data_activity.append(data_user_interest["third_activity"])

        Dict_activity = {'บันจี้จัมป์': 1, 'ปีนเขา': 1, 'ปาร์ตี้': 2, 'ดูพระอาทิตย์ขึ้น-ตก': 3,
                         'ดูทะเลหมอก': 3, 'พายเรือล่องแก่ง': 4, 'ล่องเรือ': 4, 'ดูสวนดอกไม้': 5, 'ดูงานศิลปะ': 6,
                         'สำรวจประวัติศาสตร์': 7, 'ชุมชน/เมืองจำลอง': 8, 'ถ่ายภาพสถานที่': 8}
        code_activity.append(Dict_activity[data_activity[0]])
        code_activity.append(Dict_activity[data_activity[1]])
        code_activity.append(Dict_activity[data_activity[2]])

        output_activity = []
        for i in range(3):
            x_predict[0].append(code_activity[i])
            if code_activity[i] not in output_activity:
                output_activity.append(code_activity[i])
                type_location = decision_tree(x_predict)
                data_location_type = locations.select().where(locations.c.type == type_location)
                final_data_type = await database.fetch_all(data_location_type)

                for i in range(len(final_data_type)):
                    final_type_location.append(final_data_type[i])
            x_predict[0].pop(2)

        v = 1
        while v <= len(final_type_location):
            r = randint(0, len(final_type_location)-1)
            location_check = final_type_location[r]
            if location_check not in all_location:
                all_location.append(final_type_location[r])
                v = v + 1

    elif category == 2:
        print("cat = 2")
        code_food = []
        all_location = []
        code_food.append(data_user_interest["first_food"])
        code_food.append(data_user_interest["second_food"])
        code_food.append(data_user_interest["third_food"])
        for i in range(3):
            type_food = code_food[i]
            data_food_type = locations.select().where(
                locations.c.type == type_food).order_by("locationId")
            final_data_type = await database.fetch_all(data_food_type)

            for i in range(len(final_data_type)):
                all_location.append(final_data_type[i])

        # print("all_location = ",len(all_location),all_location)
        for i in range(0, len(all_location)):
            for j in range(i+1, len(all_location)):
                # print("all_location[i] = ",j,all_location[i])
                resulti = dict(all_location[i].items())
                resultj = dict(all_location[j].items())
                if resulti["averageRating"] < resultj["averageRating"]:
                    temp = all_location[i]
                    all_location[i] = all_location[j]
                    all_location[j] = temp

    elif category == 3:
        print("cat = 3")
        code_hotel = []
        all_location = []
        code_hotel.append(data_user_interest["first_hotel"])
        code_hotel.append(data_user_interest["second_hotel"])
        code_hotel.append(data_user_interest["third_hotel"])
        for i in range(3):
            type_food = code_hotel[i]
            data_hotel_type = locations.select().where(
                locations.c.type == type_food).order_by("locationId")
            final_data_type = await database.fetch_all(data_hotel_type)

            for i in range(len(final_data_type)):
                all_location.append(final_data_type[i])

        # print("all_location = ",len(all_location))
        for i in range(0, len(all_location)):
            for j in range(i+1, len(all_location)):
                resulti = dict(all_location[i].items())
                resultj = dict(all_location[j].items())
                if resulti["averageRating"] < resultj["averageRating"]:
                    temp = all_location[i]
                    all_location[i] = all_location[j]
                    all_location[j] = temp

    else:
        print("cat = 10")
        x_predict = [[]]
        code_Age = 1

        data_gender = data['gender']
        Dict_gender = {'หญิง': 1, 'ชาย': 2}
        code_gender = Dict_gender[data_gender]
        x_predict[0].append(code_gender)

        input_age = data['birthDate']
        format_age = '%Y-%m-%d'
        now = datetime.now()
        one_or_zero = ((now.month, now.day) < (input_age.month, input_age.day))
        year_difference = now.year - input_age.year
        data_age = year_difference - one_or_zero

        if data_age >= 0 and data_age < 18:
            code_Age == 1
        elif data_age >= 18 and data_age <= 25:
            code_Age == 2
        elif data_age >= 26 and data_age <= 35:
            code_Age == 3
        elif data_age >= 36 and data_age <= 55:
            code_Age == 4
        else:
            code_Age == 5
        x_predict[0].append(code_Age)

        data_activity = []
        code_activity = []
        all_location1 = []
        final_type_location1 = []

        data_activity.append(data_user_interest["first_activity"])
        data_activity.append(data_user_interest["second_activity"])
        data_activity.append(data_user_interest["third_activity"])

        Dict_activity = {'บันจี้จัมป์': 1, 'ปีนเขา': 1, 'ปาร์ตี้': 2, 'ดูพระอาทิตย์ขึ้น-ตก': 3,
                         'ดูทะเลหมอก': 3, 'พายเรือล่องแก่ง': 4, 'ล่องเรือ': 4, 'ดูสวนดอกไม้': 5, 'ดูงานศิลปะ': 6,
                         'สำรวจประวัติศาสตร์': 7, 'ชุมชน/เมืองจำลอง': 8, 'ถ่ายภาพสถานที่': 8}
        code_activity.append(Dict_activity[data_activity[0]])
        code_activity.append(Dict_activity[data_activity[1]])
        code_activity.append(Dict_activity[data_activity[2]])

        output_activity = []
        for i in range(3):
            x_predict[0].append(code_activity[i])
            if code_activity[i] not in output_activity:
                output_activity.append(code_activity[i])
                type_location = decision_tree(x_predict)
                data_location_type = locations.select().where(locations.c.type == type_location)
                final_data_type = await database.fetch_all(data_location_type)

                for i in range(len(final_data_type)):
                    final_type_location1.append(final_data_type[i])
            x_predict[0].pop(2)

        all_location1 = final_type_location1
        print("cat = 20")
        code_food = []
        all_location2 = []
        code_food.append(data_user_interest["first_food"])
        code_food.append(data_user_interest["second_food"])
        code_food.append(data_user_interest["third_food"])
        for i in range(3):
            type_food = code_food[i]
            data_food_type = locations.select().where(
                locations.c.type == type_food).order_by("locationId")
            final_data_type = await database.fetch_all(data_food_type)

            for i in range(len(final_data_type)):
                all_location2.append(final_data_type[i])

        print("cat = 30")
        code_hotel = []
        all_location3 = []
        code_hotel.append(data_user_interest["first_hotel"])
        code_hotel.append(data_user_interest["second_hotel"])
        code_hotel.append(data_user_interest["third_hotel"])
        for i in range(3):
            type_food = code_hotel[i]
            data_hotel_type = locations.select().where(
                locations.c.type == type_food).order_by("locationId")
            final_data_type = await database.fetch_all(data_hotel_type)

            for i in range(len(final_data_type)):
                all_location3.append(final_data_type[i])

        result = []
        final_type = []
        all_location = []
        result.append(all_location1)
        result.append(all_location2)
        result.append(all_location3)
        for i in range(len(result)):
            for j in result[i]:
                all_location.append(j)
                # final_type.append(j)

        for i in range(0, len(all_location)):
            for j in range(i+1, len(all_location)):
                resulti = dict(all_location[i].items())
                resultj = dict(all_location[j].items())
                if resulti["averageRating"] < resultj["averageRating"]:
                    temp = all_location[i]
                    all_location[i] = all_location[j]
                    all_location[j] = temp

    return all_location

# ใส้ distance in json
# ทำ dest between
# เพิ่ทข้อมูลใน database และข้อมูล mock
# ดึง data mock ดาต้าจริง ดึงข้อมูลใน database rating
# 14.59334905670791, 100.45946774041767 วัดต้นสน
# 14.60161317813929, 100.3806463788147 ร้านกาแฟ
# 14.593022624327629, 100.38001326263428 วัดม่วง
# 14.58781218 100.3517418 วัดวิเศษชัยชาญ
# 14.62050153 100.3448286 ตลาดศาลเจ้าโรงทอง
# 14.65833372 100.3371042 พระตำหนักคำหยาด
# 14.49526858 100.4331007 หมู่บ้านทำกลอง

# ============================================ Trip api ==============================================


@app.get("/an_Trip/{trip_id}", response_model=Trip, status_code=status.HTTP_200_OK)
async def an_Trip(trip_id: int):
    trip = trips.select().where(trips.c.id == trip_id)
    data = database.fetch_one(trip)
    return await data


@app.get("/all_Trip/", response_model=List[Trip], status_code=status.HTTP_200_OK)
async def all_Trip():
    trip = trips.select()
    data = database.fetch_all(trip)
    return await data


@app.get("/an_Trip_item/{trip_id}", response_model=List[Tripitem], status_code=status.HTTP_200_OK)
async def an_Trip_item(trip_id: int):
    trip = tripitems.select().where(tripitems.c.tripId == trip_id)
    data = database.fetch_all(trip)
    return await data


# @app.get("/all_Trip_item/", response_model=List[Tripitem], status_code=status.HTTP_200_OK)
# async def all_Trip_item():
#     trip = tripitems.select()
#     data = database.fetch_all(trip)
#     return await data


@app.get("/user_Trip/{user_id}", response_model=List[Trip], status_code=status.HTTP_200_OK)
async def user_Trip(user_id: int):
    trip = trips.select().where(trips.c.userId == user_id)
    data = database.fetch_all(trip)
    return await data

# **********************************************************


# @app.get("/Trip_recommendation/{user_id}")
# async def Trip_recommendation(user_id: int):

#     # data = await get_user(user_id)
#     data_user_interest = await get_all_user()
#     # review = reviews.select()
#     # all_data = await database.fetch_all(review)
#     data_rating = rating_trip(user_id)

#     Dict_activity = {'บันจี้จัมป์': 1, 'ปีนเขา': 1, 'ปาร์ตี้': 2, 'ดูพระอาทิตย์ขึ้น-ตก': 3,
#                      'ดูทะเลหมอก': 3, 'พายเรือล่องแก่ง': 4, 'ล่องเรือ': 4, 'ดูสวนดอกไม้': 5, 'ดูงานศิลปะ': 6,
#                      'สำรวจประวัติศาสตร์': 7, 'ชุมชน/เมืองจำลอง': 8, 'ถ่ายภาพสถานที่': 8}

#     data_code = []
#     for i in range(len(data_user_interest)):
#         act1 = Dict_activity[data_user_interest[i]["first_activity"]]
#         act2 = Dict_activity[data_user_interest[i]["second_activity"]]
#         act3 = Dict_activity[data_user_interest[i]["third_activity"]]

#         d = dict(data_user_interest[i].items())
#         d["first_activity"] = act1
#         d["second_activity"] = act2
#         d["third_activity"] = act3
#         data_code.append(d)

#     df = pd.DataFrame.from_records(data_code)
#     df.to_csv(index=False)
#     # print("df = ",df.head(10))

#     df = df.drop(df.columns[4:], axis=1)
#     # print("df delete = ",df.head(10))

#     df_melt = df.melt(id_vars="userId", var_name="activity")
#     # print("df_melt = ",df_melt.head(10))
#     x_train, x_test = train_test_split(
#         df_melt, test_size=0.30, random_state=42)

#     user_data = x_train.pivot(
#         index='userId', columns='activity', values='value').fillna(0)
#     dummy_train = x_train.pivot(
#         index='userId', columns='activity', values='value').fillna(0)
#     # print("user_data = ",user_data.head(10))

#     dummy_test = x_test.pivot(
#         index='userId', columns='activity', values='value').fillna(1)

#     cosine = cosine_similarity(dummy_train)
#     np.fill_diagonal(cosine, 0)
#     similarity_with_user = pd.DataFrame(cosine, index=dummy_train.index)
#     similarity_with_user.columns = dummy_train.index
#     similarity_with_user.head(10)

#     def find_n_neighbours(df, n):
#         order = np.argsort(df.values, axis=1)[:, :n]
#         df = df.apply(lambda x: pd.Series(x.sort_values(ascending=False)
#                                           .iloc[:n].index,
#                                           index=['top{}'.format(i) for i in range(1, n+1)]), axis=1)
#         return df

#     sum_i = 5
#     status = 0
#     g = 1
#     final_list = []

#     sim_user = find_n_neighbours(similarity_with_user, len(data_user_interest))
#     # print("data_user_interest = ",len(data_user_interest),len(sim_user))#++ptint importan
#     all_sim = sim_user.iloc[user_id][:].to_list()
#     # for i in range(5):
#     #     sim_user.append(72)

#     # print("sim_user = ", len(all_sim))#++ptint importan

#     while len(final_list) < 10 and sum_i < len(all_sim):
#         # print("sum_i = ",sum_i)#++ptint importan
#         user_id = user_id - 1
#         if len(final_list) < 10 and status == 1:
#             user = sim_user.iloc[user_id][sum_i-1:sum_i].to_list()
#             # print("go",user)#++ptint importan
#         else:
#             user = sim_user.iloc[user_id][:sum_i].to_list()
#             status = 1
#             # for i in range(5): #good
#             #     user.append(72) #good
#             # print("not go",user)#++ptint importan
#         # print("sim_user_10_m = ", type(sim_user_10_m[0]), sim_user_10_m)
#         # !!!!!!!!!!!!!!!!!!!!!!!!เอา 72 ออก
#         for i in user:
#             # print("sim_user_forrrrr = ",i)#++ptint importan
#             list_trip = await user_Trip(i)
#             if len(list_trip) > 0:
#                 c = dict(list_trip[0].items())
#                 for j in range(len(list_trip)):
#                     list_item = await an_Trip_item(int(list_trip[j]['id']))
#                     d = dict(list_trip[j].items())
#                     d["sumOfLocation"] = len(list_item)  # !!!! right
#                     # d["sumOfLocation"] = g #good
#                     if d not in final_list:
#                         final_list.append(d)
#                         # print("len final_list = ",len(final_list),g)#++ptint importan
#                         # g+=1 #good
#                         # for i in range(9):
#                         #     final_list.append(d)
#                         # print("now add")
#                     # print("final_list",final_list)
#         if len(final_list) < 10:
#             sum_i = sum_i+1
#         # print("sum =",sum_i,len(final_list))#++ptint importan

#     # for i in range(15):
#     #     final_list.append(i)
#     v = 1
#     trip_recommen = []
#     while v <= len(final_list):
#         r = randint(0, len(final_list)-1)
#         location_check = final_list[r]
#         if location_check not in trip_recommen:
#             trip_recommen.append(final_list[r])
#             v = v + 1

#     if len(trip_recommen) > 10:
#         trip_recommen = trip_recommen[:10]
#     return trip_recommen


# @app.get("/Trip_recommendation_hybrid/{user_id}")
# async def Trip_recommendation_hybrid(user_id: int):
@app.get("/Trip_recommendation/{user_id}")
async def Trip_recommendation(user_id: int):

    data_user_interest = await get_all_user()

    Dict_activity = {'บันจี้จัมป์': 1, 'ปีนเขา': 1, 'ปาร์ตี้': 2, 'ดูพระอาทิตย์ขึ้น-ตก': 3,
                     'ดูทะเลหมอก': 3, 'พายเรือล่องแก่ง': 4, 'ล่องเรือ': 4, 'ดูสวนดอกไม้': 5, 'ดูงานศิลปะ': 6,
                     'สำรวจประวัติศาสตร์': 7, 'ชุมชน/เมืองจำลอง': 8, 'ถ่ายภาพสถานที่': 8}

    data_code = []
    for i in range(len(data_user_interest)):
        act1 = Dict_activity[data_user_interest[i]["first_activity"]]
        act2 = Dict_activity[data_user_interest[i]["second_activity"]]
        act3 = Dict_activity[data_user_interest[i]["third_activity"]]

        d = dict(data_user_interest[i].items())
        d["first_activity"] = act1
        d["second_activity"] = act2
        d["third_activity"] = act3
        data_code.append(d)

    df = pd.DataFrame.from_records(data_code)
    df.to_csv(index=False)
    # print("df = ",df.head(10))

    df = df.drop(df.columns[4:], axis=1)
    # print("df delete = ",df.head(10))

    df_melt = df.melt(id_vars="userId", var_name="activity")
    # print("df_melt = ",df_melt.head(10))
    x_train, x_test = train_test_split(
        df_melt, test_size=0.30, random_state=42)

    user_data = x_train.pivot(
        index='userId', columns='activity', values='value').fillna(0)
    dummy_train = x_train.pivot(
        index='userId', columns='activity', values='value').fillna(0)
    # print("user_data = ",user_data.head(10))

    dummy_test = x_test.pivot(
        index='userId', columns='activity', values='value').fillna(1)

    cosine = cosine_similarity(dummy_train)
    np.fill_diagonal(cosine, 0)
    similarity_with_user = pd.DataFrame(cosine, index=dummy_train.index)
    similarity_with_user.columns = dummy_train.index
    # similarity_with_user.head(10)

    def find_n_neighbours(df, n):
        order = np.argsort(df.values, axis=1)[:, :n]
        df = df.apply(lambda x: pd.Series(x.sort_values(ascending=False)
                                          .iloc[:n].index,
                                          index=['top{}'.format(i) for i in range(1, n+1)]), axis=1)
        return df

    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # !!!!!!!!!!!!!!ต้องเปลี่ยน Sum_i เป็น 10
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    sum_i = 10
    status = 0
    g = 1
    final_list = []

    hybrid = await hybrid_trip(user_id)
    print(hybrid) #++ptint importan
    if hybrid == 1:
        all_sim = await rating_trip(user_id)
        # print("sim", len(all_sim), all_sim) #++ptint importan
    else:
        sim_user = find_n_neighbours(
            similarity_with_user, len(data_user_interest)-1)
        # print("sim",sim_user,user_id)
        all_sim = sim_user.loc[user_id][:].to_list()
        # print("sim", len(all_sim), all_sim) #++ptint importan

    # print("sim_user = ", len(all_sim))#++ptint importan

    while len(final_list) <= 10 and sum_i <= len(all_sim):
        # print("sum_i = ",sum_i)#++ptint importan
        # user_id = user_id - 1
        if hybrid == 1:
            if len(final_list) <= 10 and status == 1:
                user = all_sim[sum_i-1:sum_i]
                # print("go2", user)  # ++ptint importan
            else:
                user = all_sim[:sum_i]
                status = 1
                # print("not go2", user) #++ptint importan
        else:
            if len(final_list) <= 10 and status == 1:
                user = sim_user.loc[user_id][sum_i-1:sum_i].to_list()
                # print("go", user)  # ++ptint importan
            else:
                user = sim_user.loc[user_id][:sum_i].to_list()
                status = 1
            # for i in range(5): #good
            #     user.append(72) #good
                # print("not go", user)  # ++ptint importan
        # print("sim_user_10_m = ", type(sim_user_10_m[0]), sim_user_10_m)
        # !!!!!!!!!!!!!!!!!!!!!!!!เอา 72 ออก
        for i in user:
            # print("sim_user_forrrrr = ", i)  # ++ptint importan
            list_trip = await user_Trip(i)
            if len(list_trip) > 0 and i != user_id:
                c = dict(list_trip[0].items())
                for j in range(len(list_trip)):
                    list_item = await an_Trip_item(int(list_trip[j]['id']))
                    d = dict(list_trip[j].items())
                    d["sumOfLocation"] = len(list_item)  # !!!! right
                    # d["sumOfLocation"] = g #good
                    if d not in final_list:
                        final_list.append(d)
                        # ++ptint importan
                        # print("len final_list = ", len(final_list))
                        # g+=1 #good
                        # for i in range(9):
                        #     final_list.append(d)
                        # print("now add")
                    # print("final_list",final_list)
        if len(final_list) <= 10:
            sum_i = sum_i+1
        # print("sum =", sum_i, len(final_list))  # ++ptint importan

    # for i in range(15):
    #     final_list.append(i)
    v = 1
    trip_recommen = []
    while v <= len(final_list):
        r = randint(0, len(final_list)-1)
        location_check = final_list[r]
        if location_check not in trip_recommen:
            trip_recommen.append(final_list[r])
            v = v + 1

    if len(trip_recommen) > 10:
        trip_recommen = trip_recommen[:10]
    return trip_recommen
# ============================================ model ==============================================
# >>>>>>>>>>>>>>> Decision tree <<<<<<<<<<<<<<


def decision_tree(input_activity):
    data = load(
        'decision_tree_model.joblib')
    arr_data = data.predict(input_activity)
    output = list(arr_data)
    return output[0]


# >>>>>>>>>>>>>>> Rating <<<<<<<<<<<<<<

def colla_model(user_id):
    df = pd.read_csv("dataset_mock/reviews_datamock.csv")

    x_train, x_test = train_test_split(
        df, test_size=0.30, random_state=42)

    user_data = x_train.pivot(
        index='userID', columns='placeID', values='rating').fillna(0)
    dummy_train = x_train.pivot(
        index='userID', columns='placeID', values='rating').fillna(0)
    dummy_test = x_test.pivot(
        index='userID', columns='placeID', values='rating').fillna(1)

    test = user_data
    test['user_index'] = np.arange(0, dummy_train.shape[0], 1)
    test.set_index(['user_index'], inplace=True)

    user_similarity = cosine_similarity(test)
    user_similarity[np.isnan(user_similarity)] = 0

    user_predicted_ratings = np.dot(user_similarity, test)
    user_final_ratings = np.multiply(user_predicted_ratings, dummy_train)

    user_final_ratings = user_final_ratings.iloc[user_id-1].sort_values(ascending=False)[
        :].keys().to_list()
    # print("user_final_ratings = ", len(user_final_ratings), user_final_ratings)
    # user_db = json.dumps(user_final_ratings)
    return user_final_ratings



from math import radians, cos, sin, asin, sqrt

def haversine2(lon1, lat1, lon2, lat2):
    """
    Calculate the great circle distance in kilometers between two points 
    on the earth (specified in decimal degrees)
    """
    # convert decimal degrees to radians 
    lon1, lat1, lon2, lat2 = map(radians, [lon1, lat1, lon2, lat2])

    # haversine formula 
    dlon = lon2 - lon1 
    dlat = lat2 - lat1 
    a = sin(dlat/2)**2 + cos(lat1) * cos(lat2) * sin(dlon/2)**2
    c = 2 * asin(sqrt(a)) 
    r = 6371 # Radius of earth in kilometers. Use 3956 for miles. Determines return value units.
    return c * r
# retern distance สานที่ว่าห่างจากที่ได้มาเท่าไร
# cd recommendation
# .env\Scripts\activate
# uvicorn main:app --reload
# pip install aiohttp

# URL = "http://127.0.0.1:8000"

# import asyncio
# import sys
# # asyncio.set_event_loop(asyncio.new_event_loop())

# if sys.platform:
#     asyncio.set_event_loop_policy(asyncio.WindowsSelectorEventLoopPolicy())

# try:
#     assert isinstance(loop := asyncio.new_event_loop(), asyncio.ProactorEventLoop)
#     # No ProactorEventLoop is in asyncio on other OS, will raise AttributeError in that case.

# except (AssertionError, AttributeError):
#     asyncio.run(hybrid_home())
    
# else:
#     async def proactor_wrap(loop_: asyncio.ProactorEventLoop, fut: asyncio.coroutines):
#         await fut
#         loop_.stop()

#     loop.create_task(proactor_wrap(loop, hybrid_home()))
#     loop.run_forever()