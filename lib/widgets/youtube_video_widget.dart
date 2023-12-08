import 'package:flutter/material.dart';
import 'package:pmsn20232/database/movie_controller.dart';
import 'package:pmsn20232/models/Movie_youtube_model.dart';
import 'package:pmsn20232/network/api_popular.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// ignore: must_be_immutable
class YoutubeVideoWidget extends StatefulWidget {
  int id;

  YoutubeVideoWidget({super.key, required this.id});

  @override
  State<YoutubeVideoWidget> createState() => _YoutubeVideoWidgetState();
}

class _YoutubeVideoWidgetState extends State<YoutubeVideoWidget> {
  YoutubePlayerController? _controller;

  Future<void> getIdVideo(int idMovie) async {
    final data = await ApiPopular().getDetailMovie(idMovie);
    var url = "https://www.youtube.com/watch?v=fO2a-5Wyh0I";
    if (data.isEmpty) {
      final videoID = YoutubePlayer.convertUrlToId(url);
      _controller = YoutubePlayerController(
        initialVideoId: videoID!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
        ),
      );
    } else {
      url = "https://www.youtube.com/watch?v=${data[0].id!}";
      final videoID = YoutubePlayer.convertUrlToId(url);
      _controller = YoutubePlayerController(
        initialVideoId: videoID!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
        ),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      getIdVideo(widget.id);
    }

    return YoutubePlayer(
      controller: _controller!,
      showVideoProgressIndicator: true,
      bottomActions: [
        CurrentPosition(),
        ProgressBar(
          isExpanded: true,
          colors: const ProgressBarColors(
            playedColor: Colors.red,
            handleColor: Colors.redAccent,
          ),
        ),
      ],
    );
  }
}
