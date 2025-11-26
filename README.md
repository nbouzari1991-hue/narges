
Granite AI Assistant - Full (C) package
--------------------------------------

This package contains a full-featured Flutter front-end (Dart source) and a FastAPI backend skeleton.
IMPORTANT: To build APK you must generate platform folders using `flutter create .` inside flutter_app
or run the project in a local Flutter environment that has Android SDK installed.

Quickstart (backend):
1. cd backend
2. python -m venv .venv
3. source .venv/bin/activate   (Windows: .venv\Scripts\activate)
4. pip install -r requirements.txt
5. uvicorn main:app --reload --port 8000

Quickstart (flutter):
1. cd flutter_app
2. flutter pub get
3. flutter create .    # generate android/ios native folders if missing
4. flutter run         # or flutter build apk --release

Notes:
- Update API base URLs in lib/screens if your backend is not at 10.0.2.2:8000
- For production, integrate proper auth, data validation, and real OCR/vision models.
