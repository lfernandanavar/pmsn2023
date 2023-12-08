import 'package:flutter/material.dart';
import 'package:pmsn20232/database/movie_controller.dart';
import 'package:pmsn20232/models/movie_model.dart';
import 'package:pmsn20232/services/provider/detail_movie_favorite_provider.dart';
import 'package:pmsn20232/utils/messages.dart';
import 'package:pmsn20232/widgets/actors_widget.dart';
import 'package:pmsn20232/widgets/youtube_video_widget.dart';
import 'package:provider/provider.dart';

class DetailMovieFavoriteScreen extends StatefulWidget {
  DetailMovieFavoriteScreen({super.key});

  int favorite = 1;

  @override
  State<DetailMovieFavoriteScreen> createState() =>
      _DetailMovieFavoriteScreenState();
}

class _DetailMovieFavoriteScreenState extends State<DetailMovieFavoriteScreen> {
  MovieModel? movie;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DetailMovieFavoriteProvider>(context);
    movie ??= ModalRoute.of(context)!.settings.arguments as MovieModel;
    if (provider.isUpdated) {}
    const textStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              if (movie == null || movie!.favorite! == 0) {
                MovieController().insert(
                  {
                    'favorite': 1,
                    'movie': movie!.movie!.toString(),
                    'title': movie!.title,
                    'key': movie!.keyYT,
                    'actors': movie!.actors,
                    'overview': movie!.overview,
                    'poster_path': movie!.posterPath,
                    'vote_average': (movie!.voteAverage is String)
                        ? movie!.voteAverage!.toDouble()
                        : movie!.voteAverage,
                  },
                ).then(
                  (value) {
                    if (value > 0) {
                      movie!.id = value;
                      movie!.favorite = movie!.favorite! == 1 ? 0 : 1;
                      Messages().okMessage(Messages().okInsert, context);
                    } else {
                      Messages().failMessage(Messages().failInsert, context);
                    }
                    provider.isUpdated = !provider.isUpdated;
                  },
                );
              } else {
                MovieController().deleteByID({"id": movie!.id}).then(
                  (value) {
                    movie!.favorite = movie!.favorite! == 1 ? 0 : 1;
                    if (value > 0) {
                      Messages().okMessage(Messages().okUpdate, context);
                    } else {
                      Messages().failMessage(Messages().failUpdate, context);
                    }
                    provider.isUpdated = !provider.isUpdated;
                  },
                );
              }
              setState(() {});
            },
            icon: Icon(
              movie != null
                  ? (movie!.favorite == 1 ? Icons.star : Icons.star_outline)
                  : Icons.star_outline,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            opacity: .5,
            fit: BoxFit.fill,
            image: NetworkImage(
              'https://image.tmdb.org/t/p/w500/${movie!.posterPath!}',
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              Text(
                movie!.title!,
                textAlign: TextAlign.center,
                style: textStyle,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
              ),
              Text(
                "Description:\n\n${movie!.overview!}",
                style: textStyle,
                textAlign: TextAlign.justify,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
              ),
              Row(
                children: [
                  const Text(
                    "Rating: ",
                    style: textStyle,
                  ),
                  calculateRating(movie!.voteAverage!),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
              ),
              const Text(
                "Actors: ",
                style: textStyle,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
              ),
              SizedBox(
                  height: 50,
                  child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: createWidgetsFromInput(movie!.actors!))),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
              ),
              YoutubeVideoWidget(id: movie!.id!),
            ],
          ),
        ),
      ),
    );
  }

  Widget calculateRating(double rating) {
    int valInt = 10 - rating.toInt();
    double average = rating - valInt;
    List<IconData> iconData = [];
    for (var i = 0; i < 5; i++) {
      if (valInt > i) {
        iconData.add(Icons.star_rate);
      } else if (average > 0.5) {
        iconData.add(Icons.star_half);
        average = 0.0;
      } else {
        iconData.add(Icons.star_border);
      }
    }
    return Row(
      children: iconData.map((iconData) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Icon(
            iconData,
            size: 35.0,
            color: Colors.blue,
          ),
        );
      }).toList(),
    );
  }

  List<Widget> createWidgetsFromInput(String input) {
    List<String> pairs = input.split(',');
    List<Widget> widgets = [];

    for (String pair in pairs) {
      List<String> parts = pair.split('-');
      if (parts.length == 2) {
        String nombre = parts[0];
        String valor = parts[1];

        // Crea un widget para mostrar el par "nombre-valor"
        Widget widget = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ActorsWidget(
            name: nombre,
            img: "https://image.tmdb.org/t/p/w500/$valor",
          ),
        );

        // Agrega el widget a la lista de widgets
        widgets.add(widget);
      }
    }

    return widgets;
  }
}
