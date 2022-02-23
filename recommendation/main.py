# import fastapi as _fastapi
# import service as _service
# import starlette.responses as _responses

# app = _fastapi.FastAPI()


# @app.get("/")
# async def root():
#     return _responses.RedirectResponse("/redoc")


# @app.get("/events/today")
# async def today():
#     return _service.todays_events()


# @app.get("/events")
# async def events():
#     return _service.get_all_events()


# @app.get("/events/{month}")
# async def events_month(month: str):
#     month_events = _service.month_events(month)
#     if month_events:
#         return month_events

#     return _fastapi.HTTPException(
#         status_code=404, detail=f"Month: {month} could not be found"
#     )


# @app.get("/events/{month}/{day}")
# async def events_of_day(month: str, day: int):
#     events = _service.day_events(month, day)
#     if events:
#         return events

#     return _fastapi.HTTPException(
#         status_code=404, detail=f"Date: {month}/{day} could not be found"
#     )

# *********************************************************

import pandas as pd
import numpy as np

from sklearn.metrics.pairwise import cosine_similarity
from sklearn.metrics import pairwise_distances
from sklearn.model_selection import train_test_split
from fastapi import FastAPI,status,HTTPException
# from sqlalchemy.orm import Session

import sqlalchemy
import uvicorn
import joblib
import re
import json

from pydantic import BaseModel, Field
from typing import Optional,List
# from database import SessionLocal
import asyncpg
# import databases
# import sqlalchemy 
# import models
# import databases
# from database import Base
# from sqlalchemy import Float, String,Boolean,Integer,Column,Text
# SELECT * FROM locations;

from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import session
import databases
import sqlalchemy 


SQLALCHEMY_DATABASE_URL = "postgresql://zfmsgbtyaipvev:0701919781293d9d17ff3aa96c31a3e91d70f6ea43e241179ffe6076e9d6e938@ec2-3-215-83-124.compute-1.amazonaws.com:5432/d3ngpebd1au102"

engine = sqlalchemy.create_engine(SQLALCHEMY_DATABASE_URL)
database = databases.Database(SQLALCHEMY_DATABASE_URL)
metadata = sqlalchemy.MetaData()

# SessionLocal = session(autocommit=False, autoflush=False, bind=engine)
metadata.create_all(engine)
Base = declarative_base()


# metadata = sqlalchemy.MetaData()

app = FastAPI()

locations = sqlalchemy.Table(
    "locations",
    metadata,
    sqlalchemy.Column("locationId",sqlalchemy.Integer,primary_key=True),
    sqlalchemy.Column("locationName",sqlalchemy.String(50)),
    sqlalchemy.Column("category",sqlalchemy.Integer),
    sqlalchemy.Column("description",sqlalchemy.String(300)),
    sqlalchemy.Column("contactNumber",sqlalchemy.String(10)),
    sqlalchemy.Column("website",sqlalchemy.String),
    sqlalchemy.Column("imageUrl",sqlalchemy.String(500)),
    sqlalchemy.Column("latitude",sqlalchemy.Float),
    sqlalchemy.Column("longitude",sqlalchemy.Float),
    sqlalchemy.Column("province",sqlalchemy.String(100),default="Angthong"),
    sqlalchemy.Column("averageRating",sqlalchemy.Float),
    sqlalchemy.Column("totalCheckin",sqlalchemy.Integer),
    sqlalchemy.Column("createBy",sqlalchemy.Integer),
    sqlalchemy.Column("locationStatus",sqlalchemy.String(15),default="inprogress"),
)
# class location(SessionLocal):
#     __tablename__ = 'locations'
#     id:Column(Integer,primary_key=True)
#     locationName: Column(String(50),nullable=False,unique=True)
#     category: Column(Integer,nullable=False)
#     description: Column(String(300))
#     contactNumber: Column(String(10))
#     website: Column(String)
#     imageUrl: Column(String(500))
#     latitude: Column(Float)
#     longitude: Column(Float)
#     province: Column(String(100),default="Angthong")
#     averageRating: Column(Float)
#     totalCheckin: Column(Integer,nullable=False)
#     createBy: Column(Integer,nullable=False)
#     locationStatus: Column(String(15),default="inprogress")

class Location(BaseModel): #serializer
    locationId :int
    locationName: str
    category: int
    description: str
    contactNumber: str
    website: str
    imageUrl: str
    latitude: float
    longitude: float
    province: str
    averageRating: float
    totalCheckin: int
    createBy: int
    locationStatus: str

    # class Config:
    #     orm_mode=True

# db = SessionLocal()

@app.get("/")
async def main():
    return {"message": "This is the Recommondation of the API"}

@app.on_event("startup")
async def startup():
    await database.connect()


@app.on_event("shutdown")
async def shutdown():
    await database.disconnect()

# @app.get('/location/{location_id}')
# def get_an_item(location_id:int):
#     location=db.query(models.Location).filter(models.Location.id==location_id).first()
#     return location

# @app.get("/location/{location_id}/", response_model=Location, status_code = status.HTTP_200_OK)
# async def read_location(location_id: int):
#     query = Location.select().where(Location.c.id == location_id)
#     return await db.fetch_one(query)

@app.get('/location/{location_id}',response_model=Location,status_code=status.HTTP_200_OK)
async def get_an_item(location_id:int):
    location = locations.select().where(locations.c.locationId == location_id)
    # return database.query(locations).filter(locations.c.locationId == location_id).first()
    return await database.fetch_one(location)

@app.get('/locations',response_model=List[Location],status_code=status.HTTP_200_OK)
async def get_all_item():
    location = locations.select()
    return await database.fetch_all(location)


def User_rating(User_id):
    df_restaurant = pd.read_csv("C:/Users/User/Desktop/Project/Project/Git/rating_final.csv")
    df_restaurant_cuisine = pd.read_csv('C:/Users/User/Desktop/Project/Project/Git/chefmozcuisine.csv')

    x_train, x_test = train_test_split(df_restaurant, test_size = 0.30, random_state = 42)

    user_data = x_train.pivot(index = 'userID', columns = 'placeID', values = 'rating').fillna(0)
    dummy_train = x_train.pivot(index = 'userID', columns = 'placeID', values = 'rating').fillna(0)
    dummy_test = x_test.pivot(index = 'userID', columns = 'placeID', values = 'rating').fillna(1)

    test = user_data
    test['user_index'] = np.arange(0, dummy_train.shape[0],1)
    test.set_index(['user_index'], inplace = True)

    user_similarity = cosine_similarity(test)
    user_similarity[np.isnan(user_similarity)] = 0

    user_predicted_ratings = np.dot(user_similarity, test)
    user_final_ratings = np.multiply(user_predicted_ratings, dummy_train)

    user_final_ratings = str(user_final_ratings.iloc[User_id].sort_values(ascending = False)[0:10].keys().to_list())
    user_db = json.dumps(user_final_ratings)
    return user_db

@app.get("/rating/{User_id}")
async def get_rating(User_id: int):
    return User_rating(User_id)


# @app.get("/rating/{User_id}")
# async def get_rating(User_id: int):
#     return User_rating(User_id)

# cd recommendation
# .env\Scripts\activate
# uvicorn main:app --reload



# book_db = [
#     {
#         "title":"The C Programming",
#         "price": 720
#     },
#     {
#         "title":"Learn Python the Hard Way",
#         "price": 870
#     },
#     {
#         "title":"JavaScript: The Definitive Guide",
#         "price": 1369
#     },
#     {
#         "title":"Python for Data Analysis",
#         "price": 1394
#     },
#     {
#         "title":"Clean Code",
#         "price": 1500
#     },
# ]

    # class Config:
    #     orm_mode=True
    
# @app.get("/book/")
# async def get_books():
#     return book_db

# @app.get("/book/{book_id}")
# async def get_book(book_id: int):
#     return book_db[book_id-1]

# model = joblib.load('collaborative_rating.joblib')