# SmartSight

**Point your phone at an engine part. SmartSight tells you what it is and shows you how it works.**

SmartSight is a Flutter app built as my Final Year Project (BE Computer Engineering, NUST). It uses an on-device YOLOv5 model (TFLite) to identify car engine components from a photo, then brings up an interactive 3D model, labelled images and breakdown animations for that part, so anyone can understand automobile maintenance without being a mechanic.

## Features

- **Part recognition on the device:** capture or pick a photo, crop it, and a YOLOv5 model converted to TFLite identifies the component.
- **Interactive 3D models:** rotate and zoom `.glb` models of each part (Babylon.js viewer).
- **Breakdown animations:** step-by-step videos showing how each part comes apart, streamed from Firebase.
- **Labelled images:** annotated reference images for every supported part.
- **Firebase backend:** Cloud Firestore and Firebase Storage for content, plus a local SQLite cache.

**Recognised parts:** Air Coolant · Battery · Fuse Box · Main Engine · Radiator · Windscreen Washer

## Tech stack

| Layer | Tools |
|---|---|
| App | Flutter (Dart), Provider |
| ML | YOLOv5, exported to TFLite (`assets/best_float32.tflite`) |
| 3D | `.glb` models, `babylonjs_viewer` |
| Backend | Firebase Core, Cloud Firestore, Firebase Storage |
| Media | `image_picker`, `image_cropper`, `video_player`, `cached_network_image` |
| Storage | `sqflite`, `path_provider` |

## Project structure

```
lib/
├── main.dart               # App entry, Firebase init, providers
├── splash.dart             # Loading screen
├── homePage/               # Home, image capture and crop screens
├── bottomSheets/           # Model, label and animation viewers
└── provider/               # App state (FypProvider, SplashProvider)
assets/
├── best_float32.tflite     # Trained YOLOv5 model
├── labels.txt              # Class labels
├── glb/                    # 3D models of each part
└── image_thumbnail/        # Part thumbnails
```

## Getting started

```bash
git clone https://github.com/hk5ahi/SmartSight.git
cd SmartSight
flutter pub get
flutter run
```

Requires a Flutter SDK with Dart `>=2.19.2 <3.0.0` (Flutter 3.7–3.10). Firebase is already configured for Android via `android/app/google-services.json`. To use your own Firebase project, replace that file and regenerate `lib/firebase_options.dart` with `flutterfire configure`.

## Related

The model training pipeline (dataset labelling and YOLOv5 training) was a separate part of the project and isn't in this repo.
