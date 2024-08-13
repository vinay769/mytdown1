import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  final _textController = TextEditingController();
  String? title;
  String? author;
  String? duration;

  Future<void> getVideoInfo() async {
    final yt = YoutubeExplode();
    try {
      final video = await yt.videos.get(_textController.text);
      setState(() {
        title = video.title;
        author = video.author;
        duration = video.duration.toString();
      });
    } catch (error) {
      print('Error fetching video details: $error');
      setState(() {
        title = "Error fetching video";
        author = "";
      });
    }
  }

  Future<void> downloadYouTubeVideo(String videoUrl) async {
    final yt = YoutubeExplode();
    try {
      final video = await yt.videos.get(videoUrl);
      final manifest = await yt.videos.streamsClient.getManifest(video.id);

      final streamInfo = manifest.muxed.withHighestBitrate();
      final stream = yt.videos.streamsClient.get(streamInfo);

      Directory? directory;
      if (Platform.isAndroid) {
        if (await Permission.storage.request().isGranted) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory != null) {
        final filePath = '${directory.path}/${video.title}.mp4';
        final file = File(filePath);

        final fileStream = file.openWrite();
        await stream.pipe(fileStream);
        await fileStream.flush();
        await fileStream.close();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download completed: $filePath')),
        );
      }
    } catch (e) {
      print('Error downloading video: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading video: $e')),
      );
    } finally {
      yt.close();
    }
  }

  Future<void> requestPermissionsAndDownload() async {
    if (await Permission.storage.request().isGranted) {
      if (_textController.text.isNotEmpty) {
        await downloadYouTubeVideo(_textController.text);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid YouTube link')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Storage permission is required to download the video')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
              child: Text(
                "      mYTdown",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Color(0xffFFDFD6)),
              )),
          backgroundColor: const Color(0xff694F8E),
          elevation: 1,
          actions: [
            IconButton(
                onPressed: requestPermissionsAndDownload,
                icon: const Icon(
                  Icons.download,
                  color: Color(0xffE3A5C7),
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(50, 5, 0, 0),
                child: Text(
                  "Welcome To mYTdown",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 50,
                      color: Color(0xffE3A5C7)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * .40,
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          controller: _textController,
                          maxLines: 1,
                          cursorColor: const Color(0XFFE3A5C7),
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.link),
                            border: OutlineInputBorder(),
                            hintText: "Paste YT Link",
                            label: Text("Link"),
                          ),
                        ),
                      ),
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      height: 55,
                      color: const Color(0xffB692C2),
                      highlightElevation: 5.0,
                      onPressed: getVideoInfo,
                      child: const Icon(
                        Icons.info_outline,
                        color: Color(0xff694F8E),
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                color: const Color(0xffE3A5C7),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (title != null)
                        Text(
                          '⚫ Title: $title',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54),
                        ),
                      if (author != null)
                        Text(
                          '⚫ Author: $author',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54),
                        ),
                      if (title != null)
                        Text(
                          '⚫ Duration: $duration',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
