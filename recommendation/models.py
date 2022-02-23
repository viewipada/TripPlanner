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