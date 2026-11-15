import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'animationPlay.dart';
import '../homePage/imagePage.dart';

class AnimationPage extends StatefulWidget {
  @override
  State<AnimationPage> createState() => AnimationPageState();
}

List<String> getVideoUrls(List<String>? parts) {
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
  return parts.map((part) => '$baseUrl${part}.mp4').toList();
}

class AnimationPageState extends State<AnimationPage> {
  bool check_animy = true;
  List<String> videoUrls = [];
  List<String> parts = [];
  List<Future<Uint8List?>> videoThumbnails = [];

  @override
  void initState() {
    super.initState();
    parts = pt();
    updateVideoUrls();
  }

  void updateVideoUrls() {
    final newVideoUrls = getVideoUrls(parts);

    if (_areListsEqual(newVideoUrls, videoUrls)) {
      // Video URLs have not changed
      return;
    }

    videoUrls = newVideoUrls;
    setState(() {
      check_animy = videoUrls.isNotEmpty;
    });

    // Load the thumbnails for all videos
    for (String videoUrl in videoUrls) {
      videoThumbnails.add(VideoThumbnail.thumbnailData(
        video: videoUrl,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 150,
        maxHeight: 150,
        quality: 25,
      ));
    }
  }

  bool _areListsEqual(List<String> list1, List<String> list2) {
    if (list1.length != list2.length) {
      return false;
    }

    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) {
        return false;
      }
    }

    return true;
  }

  @override
  void didUpdateWidget(AnimationPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newParts = pt();

    if (!_areListsEqual(newParts, parts)) {
      parts = newParts;
      updateVideoUrls();
    }
  }

  // Rest of your code...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Animations'),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: GridView.builder(
            itemCount: videoUrls.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          VideoPlayerPage(videoUrl: videoUrls[index]),
                    ),
                  );
                },
                child: Card(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.green, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: FutureBuilder(
                    future: videoThumbnails[index],
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Image.memory(snapshot.data);
                      } else {
                        return Center(
                            child: CircularProgressIndicator(
                          color: Colors.white,
                        ));
                      }
                    },
                  ),
                ),
              );
            },
          ),
          // Column(
          //
          //   children: [
          //     SizedBox(height: 20,),
          //     ImageIcon(AssetImage('assets/file.png'),size:150,color: Colors.grey,),
          //     SizedBox(height: 10,),
          //     Text('No Animations found',style: TextStyle(
          //         color: Colors.grey
          //     ),),
          //     IconButton(onPressed:  () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (_) =>Placeholder() //PlayFileScreen(file: file),
          //         ),
          //       );
          //     }, icon: Icon(Icons.play_circle,color: Colors.white,))
          //   ],
          // ),
        ),
      ),
    );
  }
}
