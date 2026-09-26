from fastapi import FastAPI

app = FastAPI(
    title="CafeSense API",
    version="0.1.0",
)


@app.get("/health")
def health_check():
    return {
        "status": "UP",
        "service": "CafeSense API",
    }