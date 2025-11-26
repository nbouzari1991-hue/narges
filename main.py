from fastapi import FastAPI, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
import aiofiles, os
from pydantic import BaseModel

app = FastAPI(title="GraniteBot Backend - Advanced")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class ChatIn(BaseModel):
    message: str

@app.post("/chat/")
async def chat_endpoint(payload: ChatIn):
    text = payload.message.lower()
    if "تولید" in text:
        return {"reply": "تولید امروز: 3200 عدد — ضایعات 4.2% (نمونه شبیه‌سازی)"}
    if "qc" in text or "کیو سی" in text:
        return {"reply": "3 مورد QC باز وجود دارد. لطفا بخش QC را بررسی کنید."}
    return {"reply": "من متوجه نشدم. لطفا سوال را دقیق‌تر بپرسید یا از کلیدواژه‌های تولید و QC استفاده کنید."}

@app.get("/summary")
async def summary():
    return {"text": "خلاصه سیستم: تولید پایدار، ضایعات در محدوده هدف."}

@app.post("/ocr/upload")
async def ocr_upload(file: UploadFile = File(...)):
    contents = await file.read()
    tmp = "/tmp/ocr_upload.jpg"
    async with aiofiles.open(tmp, 'wb') as out_file:
        await out_file.write(contents)
    return {"text": "متن استخراج‌شده (شبیه‌سازی)"}

@app.post("/vision/analyze")
async def vision_analyze(file: UploadFile = File(...)):
    contents = await file.read()
    tmp = "/tmp/vision_upload.jpg"
    async with aiofiles.open(tmp, 'wb') as out_file:
        await out_file.write(contents)
    return {"defect": False, "type": None, "confidence": 0.0}

@app.post("/production/")
async def create_production(rec: dict):
    os.makedirs("data", exist_ok=True)
    with open("data/production.jsonl", "a", encoding="utf-8") as f:
        f.write(str(rec) + "\n")
    return {"status": "created"}

@app.post("/qc/")
async def create_qc(rec: dict, file: UploadFile = File(None)):
    os.makedirs("data", exist_ok=True)
    entry = dict(rec)
    if file is not None:
        contents = await file.read()
        fn = f"data/qc_{len(os.listdir('data'))+1}.jpg"
        async with aiofiles.open(fn, 'wb') as out_file:
            await out_file.write(contents)
        entry['image'] = fn
    with open("data/qc.jsonl", "a", encoding="utf-8") as f:
        f.write(str(entry) + "\n")
    return {"status": "created"}
