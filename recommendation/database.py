# from sqlalchemy import MetaData, create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from databases import Database
import sqlalchemy 


SQLALCHEMY_DATABASE_URL = "postgresql://zfmsgbtyaipvev:0701919781293d9d17ff3aa96c31a3e91d70f6ea43e241179ffe6076e9d6e938@ec2-3-215-83-124.compute-1.amazonaws.com:5432/d3ngpebd1au102"

engine = sqlalchemy.create_engine(SQLALCHEMY_DATABASE_URL)
database = Database(SQLALCHEMY_DATABASE_URL)
metadata = sqlalchemy.MetaData()

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
# SessionLocal = sessionmaker(bind=engine)
metadata.create_all(engine)
Base = declarative_base()


# SessionLocal=sessionmaker(bind=engine)