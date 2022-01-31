from fastapi import FastAPI
import uvicorn
# from fastapi.responses import HTMLResponse

# File, UploadFile

app = FastAPI()


@app.get("/")
async def main():
    return {"message": "This is the Recommondation of the API"}


@app.get('/{name}')
def get_name(name: str):
    return {'Welcome to recommendation system' f'{name}'}


# from fastapi import FastAPI
# # from colabcode import ColabCode
# import uvicorn
# import pickle

# app = FastAPI()

# @app.get('/')
# def index():
#     return {'message': 'This is the Recommondation of the API '}

# @app.get('/name')
# def get_name(name: str):
#     return {'message': 'Welcome to recommendation {name}'}
