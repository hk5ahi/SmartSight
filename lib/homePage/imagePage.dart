import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../bottomSheets/animationPage.dart';
import '../bottomSheets/labelPage.dart';
import '../bottomSheets/modelPage.dart';

List<String> Engine_Parts = ['MainEngine', 'Radiator'];

List<String> pt() {
  return Engine_Parts;
}

Widget buildIconWithBadge(Widget icon, bool hasContent) {
  return Stack(
    children: <Widget>[
      icon,
      if (hasContent)
        Positioned(
          right: 0,
          child: Container(
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(6),
            ),
            constraints: BoxConstraints(
              minWidth: 10,
              minHeight: 10,
            ),
            child: Text(
              '',
              style: TextStyle(
                color: Colors.white,
                fontSize: 8,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
    ],
  );
}

class ImagePage extends StatefulWidget {
  final String _imagePath;
  final String name;

  const ImagePage(this._imagePath, this.name);

  @override
  ImagePageState createState() => ImagePageState();
}

class ImagePageState extends State<ImagePage> {
  bool processed = true;

  final List<String> objUrls = modelPageState().objUrls;

  final List<String> videoUrls = AnimationPageState().videoUrls;

  Future<bool> isListEmpty(List<String> list) async {
    return list.isEmpty;
  }

  void openlabel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
          height: MediaQuery.of(context).size.height * 0.8, child: labelPage()),
    );
  }

  void open3D() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
          height: MediaQuery.of(context).size.height * 0.8, child: modelPage()),
    );
  }

  void openAnimation() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: AnimationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black87,
          elevation: 0,
          centerTitle: processed ? true : false,
          title: Text(
            widget.name,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 15,
              fontStyle: FontStyle.italic,
            ),
          ),
          bottom: PreferredSize(
            preferredSize:
                Size.fromHeight(1.0), // Set the height of the green border line
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      width: 2.0,
                      color: Colors
                          .green), // Set the width and color of the green border line
                ),
              ),
            ),
          )),
      body: Container(
        color: Colors.black87,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            processed
                ? Image.file(File(widget._imagePath))
                : Image.asset('assets/engin.jpeg'),
          ],
        ),
      ),
      bottomNavigationBar: processed
          ? Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.green,
                    width: 2.0,
                  ),
                ),
              ),
              child: BottomAppBar(
                color: Colors.black87,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.green,
                          ),
                          height: 40,
                          width: 70,
                          child: IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                    content: SizedBox(
                                      height: 40,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('Processing Image'),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    elevation: 0,
                                    backgroundColor: Colors.grey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    margin: EdgeInsets.only(
                                        bottom: 560, left: 100, right: 100),
                                    padding: EdgeInsets.zero,
                                  ))
                                  .closed
                                  .then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: SizedBox(
                                      height: 40,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('Image Processed'),
                                          Icon(
                                            Icons.done,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    elevation: 0,
                                    backgroundColor: Colors.grey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    margin: EdgeInsets.only(
                                        bottom: 560, left: 100, right: 100),
                                    padding: EdgeInsets.zero,
                                  ),
                                );
                              });
                              Future.delayed(Duration(seconds: 6), () {
                                setState(() {
                                  processed = false;
                                });
                              });
                              //
                            },
                            icon: Icon(Icons.done),
                            color: Colors.white,
                          )),
                    )
                  ],
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.green,
                    width: 2.0,
                  ),
                ),
              ),
              child: BottomAppBar(
                color: Colors.black87,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                      onPressed: () => openlabel(),
                      icon: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 2,
                          ),
                          ImageIcon(
                            AssetImage('assets/labels.png'),
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            'Labels',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 12),
                          ),
                        ],
                      ),
                      label: SizedBox.shrink(),
                    ),
                    FutureBuilder<bool>(
                      future: isListEmpty(objUrls),
                      builder:
                          (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        bool isEmpty = snapshot.data!;
                        return TextButton.icon(
                          onPressed: () => open3D(),
                          icon: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 2,
                              ),
                              buildIconWithBadge(
                                Icon(
                                  CupertinoIcons.cube_fill,
                                  color: Colors.white,
                                ),
                                !isEmpty,
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                '3D Models',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                          label: SizedBox.shrink(),
                        );
                      },
                    ),
                    FutureBuilder<bool>(
                      future: isListEmpty(videoUrls),
                      builder:
                          (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        bool isEmpty = snapshot.data!;
                        return TextButton.icon(
                          onPressed: () => openAnimation(),
                          icon: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 2,
                              ),
                              buildIconWithBadge(
                                ImageIcon(
                                  AssetImage('assets/Vector.png'),
                                  color: Colors.white,
                                ),
                                !isEmpty,
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                'Animations',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                          label: SizedBox.shrink(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
