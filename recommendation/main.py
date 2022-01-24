from fastapi import FastAPI, File, UploadFile
# from fastapi.responses import HTMLResponse

app = FastAPI()


@app.get("/")
async def main():
    return {"message": "This is the Recommondation of the API"}

@app.get('/name')
def get_name(name: str):
    return {'message': f'Welcome to recommendation {name}'}



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
