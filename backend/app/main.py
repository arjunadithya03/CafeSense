from fastapi import FastAPI

from app.routers.auth import router as auth_router


app = FastAPI(
    title="CafeSense API",
    version="0.2.0",
)


app.include_router(auth_router)


@app.get("/health")
def health_check():
    return {
        "status": "UP",
        "service": "CafeSense API",
    }