import pandas as pd
import numpy as np

from sklearn.metrics.pairwise import cosine_similarity
from sklearn.metrics import pairwise_distances
from sklearn.model_selection import train_test_split
from fastapi import FastAPI,status,HTTPException

import sqlalchemy
import uvicorn
import joblib
import re
import json
import asyncpg

import databases
import sqlalchemy 

from pydantic import BaseModel, Field
from typing import Optional,List
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import session

SQLALCHEMY_DATABASE_URL = "postgresql://zfmsgbtyaipvev:0701919781293d9d17ff3aa96c31a3e91d70f6ea43e241179ffe6076e9d6e938@ec2-3-215-83-124.compute-1.amazonaws.com:5432/d3ngpebd1au102"

engine = sqlalchemy.create_engine(SQLALCHEMY_DATABASE_URL)
database = databases.Database(SQLALCHEMY_DATABASE_URL)
metadata = sqlalchemy.MetaData()

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


# @app.get("/location/{location_id}/", response_model=Location, status_code = status.HTTP_200_OK)
# async def read_location(location_id: int):
#     query = Location.select().where(Location.c.id == location_id)
#     return await db.fetch_one(query)

@app.get('/location/{location_id}',response_model=Location,status_code=status.HTTP_200_OK)
async def get_an_item(location_id:int):
    location = locations.select().where(locations.c.locationId == location_id)
    data = database.fetch_one(location)
    return await data

@app.get('/nearly_user_rating/{latlong}')
async def get_nearly_location(lot:float,long:float):
    # location = locations.select()
    return 'Please wait the system is developing.'

def User_rating(User_id):
    df_restaurant = pd.read_csv("C:/Users/User/Desktop/Project/Project/Git/test.csv")

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

    user_final_ratings = user_final_ratings.iloc[User_id].sort_values(ascending = False)[0:10].keys().to_list()
    # user_db = json.dumps(user_final_ratings)
    return user_final_ratings

@app.get("/rating/{User_id}")
async def get_location(User_id: int):
    final_rating = User_rating(User_id)
    location = locations.select().where(locations.c.locationId.in_(final_rating))
    data = database.fetch_all(location)
    return await data

# cd recommendation
# .env\Scripts\activate
# uvicorn main:app --reload
# pip install aiohttp 

# URL = "http://127.0.0.1:8000"

# async def send_req(session: ClientSession):
#     async with session.get(URL) as resp:
#         if resp.status == 200:
#             r = await resp.json()
#             print(r)
#         else:
#             print(resp.status)

# async def main():
#     # check what loop is really running in our Main Thread now
#     loop = asyncio.get_running_loop()
#     print(loop)
#     # no need to create ClientSession for all send_req, you need only one ClientSession
#     async with ClientSession() as session:
#         # asyncio gather creates tasks itself, no need to create tasks outside
#         await asyncio.gather(*[send_req(session) for _ in range(8)])

# if __name__ == '__main__':
#     # set another loop implementation:
#     asyncio.set_event_loop_policy(asyncio.WindowsSelectorEventLoopPolicy())
#     asyncio.run(main())


