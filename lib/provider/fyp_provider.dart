import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tflite/tflite.dart';
import 'path/to/image_list.dart';
import '../homePage/cropPage.dart';

class FypProvider with ChangeNotifier {
  Database? _database;
  List<Map<String, dynamic>> imageslist = [];

  CroppedFile? imageFile;

  Future<void> initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = "${documentsDirectory.path}/images.db";

    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE images (id INTEGER PRIMARY KEY, name TEXT, imagePath TEXT, dateTime TEXT)");
    });
    await loadImagesFromDatabase();
  }

  Future<void> loadImagesFromDatabase() async {
    if (_database == null) {
      await initDatabase();
    }

    if (_database != null) {
      List<Map<String, dynamic>> images =
          await _database!.rawQuery("SELECT * FROM images ORDER BY id DESC ");

      imageslist = images;
      notifyListeners();
    }
  }

  Future<void> saveImageToDatabase(String imagePath) async {
    int imageCount = await _database!
        .rawQuery("SELECT COUNT(*) FROM images")
        .then((value) => Sqflite.firstIntValue(value)!);

    if (imageCount >= 10) {
      await _database!.rawDelete("DELETE FROM images WHERE id = 1");
      await _database!.execute("UPDATE images SET id = id - 1");
      notifyListeners();
    }

    String name =
        "NewFile ${DateFormat('yy-MM-dd HH:mm:ss').format(DateTime.now())}";
    String dateTime =
        "Accessed:  ${DateFormat('yy-MM-dd HH:mm:ss').format(DateTime.now()).toString()}";
    await _database!.rawInsert(
        "INSERT INTO images (name, imagePath, dateTime) VALUES (?, ?, ?)",
        [name, imagePath, dateTime]);

    await loadImagesFromDatabase();
  }

  Future<void> pickImageFromCamera(BuildContext context) async {
    try {
      ImageCache cache = ImageCache();
      cache.clear();

      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 20,
      );

      if (pickedFile != null) {
        imageFile = CroppedFile(pickedFile.path);
        notifyListeners();
        await _cropImage(context);
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<void> _cropImage(BuildContext context) async {
    final cropper = ImageCropper();
    final croppedFile = await cropper.cropImage(
      sourcePath: imageFile!.path,
      cropStyle: CropStyle.rectangle,
      compressQuality: 40,
      aspectRatioPresets: [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Edit Image',
          statusBarColor: Colors.black87,
          toolbarColor: Colors.black87,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Edit Image',
        ),
      ],
    );

    if (croppedFile != null) {
      imageFile = CroppedFile(croppedFile.path);
      notifyListeners();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CroppedImg(imageFile),
        ),
      );

      await saveImageToDatabase(imageFile!.path);
      await performInference(imageFile!.path);
    }
  }

  Future<void> performInference(String imagePath) async {
    // Load the TensorFlow Lite model
    await Tflite.loadModel(
      model: 'assets/best_float32.tflite',
      labels: 'assets/labels.txt',
    );

    // Perform inference on the cropped image using the TensorFlow Lite model
    var output = await Tflite.runModelOnImage(
      path: imagePath,
      numResults: 10,
      threshold: 0.2,
    );

    // Process the output tensor data to extract the detected objects, bounding boxes, labels, etc.
    // ...

    // Save the output to the imagesList
    Map<String, dynamic> outputData = {
      'imagePath': imagePath,
      'output': output,
    };
    imagesList.add(outputData);

    // Display the results or perform any desired actions in your Flutter app based on the model's output
    // ...
  }
}
