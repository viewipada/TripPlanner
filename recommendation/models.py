from sqlalchemy.sql.expression import null
from database import Base
from sqlalchemy import Float, String,Boolean,Integer,Column,Text


class Location(Base):
    __tablename__= 'locations'
    id: Column(Integer,primary_key=True)
    locationName: Column(String(50),nullable=False,unique=True)
    category: Column(Integer,nullable=False)
    description: Column(String(300))
    contactNumber: Column(String(10))
    website: Column(String)
    imageUrl: Column(String(500))
    latitude: Column(Float)
    longitude: Column(Float)
    province: Column(String(100),default="Angthong")
    averageRating: Column(Float)
    totalCheckin: Column(Integer,nullable=False)
    createBy: Column(Integer,nullable=False)
    locationStatus: Column(String(15),default="inprogress")


    # def __repr__(self):
    #     return f"<Item name={self.name} price={self.price}>"

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