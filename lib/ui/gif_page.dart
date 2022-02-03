import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class GifPage extends StatelessWidget {
  final Map<dynamic, dynamic> _gifData;
  GifPage(this._gifData);

  downloadGif() async {
    try {
      // Saved with this method.
      var imageId = await ImageDownloader.downloadImage(
          _gifData["images"]["fixed_height"]["url"],
          destination: AndroidDestinationType.directoryDownloads);
      if (imageId == null) {
        print("imageid : $imageId");
        return;
      }

      // Below is a method of obtaining saved image information.
      var fileName = await ImageDownloader.findName(imageId);
      var path = await ImageDownloader.findPath(imageId);
      var size = await ImageDownloader.findByteSize(imageId);
      var mimeType = await ImageDownloader.findMimeType(imageId);
      print(
          "filename: $fileName | path: $path | size: $size | mimetype: $mimeType");
    } on PlatformException catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gifData['title']),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              onPressed: () {
                Share.share(_gifData["images"]["fixed_height"]["url"]);
              },
              icon: Icon(Icons.share)),
          IconButton(
              onPressed: () {
                downloadGif();
              },
              icon: Icon(Icons.download))
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(_gifData["images"]["fixed_height"]["url"]),
      ),
    );
  }
}
