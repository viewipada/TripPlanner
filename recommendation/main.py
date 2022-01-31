import fastapi as _fastapi
import service as _service
import starlette.responses as _responses

app = _fastapi.FastAPI()


@app.get("/")
async def root():
    return _responses.RedirectResponse("/redoc")


@app.get("/events/today")
async def today():
    return _service.todays_events()


@app.get("/events")
async def events():
    return _service.get_all_events()


@app.get("/events/{month}")
async def events_month(month: str):
    month_events = _service.month_events(month)
    if month_events:
        return month_events

    return _fastapi.HTTPException(
        status_code=404, detail=f"Month: {month} could not be found"
    )


@app.get("/events/{month}/{day}")
async def events_of_day(month: str, day: int):
    events = _service.day_events(month, day)
    if events:
        return events

    return _fastapi.HTTPException(
        status_code=404, detail=f"Date: {month}/{day} could not be found"
    )

# *********************************************************
# from fastapi import FastAPI
# import uvicorn
# # from fastapi.responses import HTMLResponse

# # File, UploadFile

# app = FastAPI()


# @app.get("/")
# async def main():
#     return {"message": "This is the Recommondation of the API"}


# @app.get('/{name}')
# def get_name(name: str):
#     return {'Welcome to recommendation system' f'{name}'}


# 55555555555555555555555555555555555555555555555

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
