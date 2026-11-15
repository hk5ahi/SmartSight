import 'package:flutter/material.dart';
import 'package:fyp/provider/path/to/image_list.dart';

class labelPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> images =
        imagesList.map((image) => image['imagePath'] as String).toList();

    final List<String> objThumbnails = List.generate(
      images.length,
      (index) => 'Label image ${index + 1}',
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Labelled Images'),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: GridView.builder(
            itemCount: images.length,
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
                        body: Center(child: Image.asset(images[index])),
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
                  child: Center(child: Image.asset(images[index])),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
