import 'package:flutter/material.dart';
import 'package:babylonjs_viewer/babylonjs_viewer.dart';
import '../homePage/imagePage.dart';

class modelPage extends StatefulWidget {
  @override
  State<modelPage> createState() => modelPageState();
}

class modelPageState extends State<modelPage> {
  bool check_model = false;
  List<String> parts = pt(); // List of parts received dynamically
  List<String> objUrls = [];
  List<String> objThumbnails = [];
  List<String> images = [];

  @override
  void initState() {
    super.initState();
    objUrls = getObjUrls(parts);
    objThumbnails = getObjThumbnails(parts);
    images = getImages(parts);

    setState(() {
      if (objUrls.isEmpty) {
        check_model = true;
      }
    });
  }

  List<String> getObjUrls(List<String> parts) {
    return parts.map((part) => 'assets/glb/$part.glb').toList();
  }

  List<String> getObjThumbnails(List<String> parts) {
    return parts.toList();
  }

  List<String> getImages(List<String> parts) {
    return parts.map((part) => 'assets/image_thumbnail/$part.png').toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('3D Models'),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: GridView.builder(
            itemCount: objUrls.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Scaffold(
                        backgroundColor: Colors.black87,
                        appBar: AppBar(
                          title: Text(objThumbnails[index]),
                          backgroundColor: Colors.black87,
                        ),
                        body: BabylonJSViewer(
                          src: objUrls[index],
                        ),
                      ),
                    ),
                  );
                },
                child: Card(
                    elevation: 5,
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.green, width: 1.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(child: Image.asset(images[index]))),
              );
            },
          ),
          // Column(
          //
          //   children: [
          //     SizedBox(height: 20,),
          //     ImageIcon(AssetImage('assets/file.png'),size:150,color: Colors.grey,),
          //     SizedBox(height: 10,),
          //     Text('No 3D Models found',style: TextStyle(
          //         color: Colors.grey
          //     ),)
          //   ],
          // ),
        ),
      ),
    );
  }
}
/*class modelPageState extends State<modelPage> {
  bool check_model = false;
  List<String> parts = pt(); // List of parts received dynamically
  List<String> objUrls = [];
  List<String> objThumbnails = [];
  List<String> images = [];

  @override
  void initState() {
    super.initState();
    objUrls = getObjUrls(parts);
    objThumbnails = getObjThumbnails(parts);
    images = getImages(parts);

    setState(() {
      if (objUrls.isEmpty) {
        check_model = true;
      }
    });
  }

  List<String> getObjUrls(List<String>? parts) {
    const String baseUrl =
        'https://storage.googleapis.com/smartsight-c30f8.appspot.com/';

    // Check if parts is null, empty, or contains null or empty strings
    if (parts == null ||
        parts.isEmpty ||
        parts.contains(null) ||
        parts.contains('')) {
      return [];
    }

    // Convert the part names to URLs
    return parts.map((part) => '$baseUrl${part}.glb').toList();
  }

  List<String> getObjThumbnails(List<String> parts) {
    if (parts.isEmpty) {
      return []; // Return an empty list if parts is empty
    }

    return parts.toList();
  }

  List<String> getImages(List<String>? parts) {
    const String baseUrl =
        'https://storage.googleapis.com/smartsight-c30f8.appspot.com/';

    // Check if parts is null, empty, or contains null or empty strings
    if (parts == null ||
        parts.isEmpty ||
        parts.contains(null) ||
        parts.contains('')) {
      return [];
    }

    // Convert the part names to URLs
    return parts.map((part) => '$baseUrl${part}.png').toList();
  }*/