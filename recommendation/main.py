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
from fastapi import FastAPI
import uvicorn
import joblib
import re
import json
# from fastapi.responses import HTMLResponse

# File, UploadFile

app = FastAPI()

# New
book_db = [
    {
        "title":"The C Programming",
        "price": 720
    },
    {
        "title":"Learn Python the Hard Way",
        "price": 870
    },
    {
        "title":"JavaScript: The Definitive Guide",
        "price": 1369
    },
    {
        "title":"Python for Data Analysis",
        "price": 1394
    },
    {
        "title":"Clean Code",
        "price": 1500
    },
]

@app.get("/")
async def main():
    return {"message": "This is the Recommondation of the API"}

@app.get("/book/")
async def get_books():
    return book_db

@app.get("/book/{book_id}")
async def get_book(book_id: int):
    return book_db[book_id-1]

# model = joblib.load('collaborative_rating.joblib')


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



# uvicorn main:app --reload

# from sqlalchemy import create_engine
# from sqlalchemy.ext.declarative import declarative_base
# from sqlalchemy.orm import sessionmaker
# from typing import List

# from fastapi import Depends, FastAPI, HTTPException
# from sqlalchemy.orm import Session

# from . import crud, models, schemas
# from .database import SessionLocal, engine

# SQLALCHEMY_DATABASE_URL = "https://git.heroku.com/travel-planning-ceproject.git"
# # SQLALCHEMY_DATABASE_URL = "postgresql://user:password@postgresserver/db"

# engine = create_engine(
#     SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False}
# )
# SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Base = declarative_base()
# print(user_final_ratings.iloc[1].sort_values(ascending = False)[0:10])
# print(user_final_ratings.iloc[136].sort_values(ascending = False)[0:10].keys().to_list())

# from joblib import dump
# dump(user_final_ratings, 'collaborative_rating.joblib')