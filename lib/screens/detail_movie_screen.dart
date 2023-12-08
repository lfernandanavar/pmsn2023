import 'package:flutter/material.dart';
import 'package:pmsn20232/database/movie_controller.dart';
import 'package:pmsn20232/models/api/credits_model.dart';
import 'package:pmsn20232/models/api/popular_model.dart';
import 'package:pmsn20232/models/movie_model.dart';
import 'package:pmsn20232/network/api_popular.dart';
import 'package:pmsn20232/services/provider/detail_movie_provider.dart';
import 'package:pmsn20232/utils/messages.dart';
import 'package:pmsn20232/widgets/actors_widget.dart';
import 'package:pmsn20232/widgets/youtube_video_widget.dart';
import 'package:provider/provider.dart';

class DetailMovieScreen extends StatefulWidget {
  const DetailMovieScreen({super.key});

  @override
  State<DetailMovieScreen> createState() => _DetailMovieScreenState();
}

class _DetailMovieScreenState extends State<DetailMovieScreen> {
  PopularModel? movie;
  MovieModel? movieFavorite;
  String? actors;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DetailMovieProvider>(context);
    movie = ModalRoute.of(context)!.settings.arguments as PopularModel;
    if (movieFavorite == null) {
      getMovie(movie!.id!.toString());
    }
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
              if (movieFavorite == null || movieFavorite!.favorite! == 0) {
                String idKeyYT = getYTKey(movie!.id!).toString();
                MovieController().insert(
                  {
                    'favorite': 1,
                    'movie': movie!.id!.toString(),
                    'title': movie!.title,
                    'key': idKeyYT,
                    'actors': actors,
                    'overview': movie!.overview,
                    'poster_path': movie!.posterPath,
                    'vote_average': (movie!.voteAverage is String)
                        ? movie!.voteAverage!.toDouble()
                        : movie!.voteAverage,
                  },
                ).then(
                  (value) {
                    movieFavorite = MovieModel(
                      id: value,
                      favorite: 1,
                      movie: movie!.id!.toString(),
                    );
                    if (value > 0) {
                      Messages().okMessage(Messages().okInsert, context);
                    } else {
                      Messages().failMessage(Messages().failInsert, context);
                    }
                    provider.isUpdated = !provider.isUpdated;
                  },
                );
              } else {
                movieFavorite!.favorite! == 1 ? 0 : 1;
                MovieController().delete({"movie": movie!.id!}).then(
                  (value) {
                    movieFavorite!.favorite =
                        movieFavorite!.favorite! == 1 ? 0 : 1;
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
              movieFavorite != null
                  ? (movieFavorite!.favorite == 1
                      ? Icons.star
                      : Icons.star_outline)
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
                'https://image.tmdb.org/t/p/w500/${movie!.posterPath!}'),
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
                child: getActors(movie!.id!),
              ),
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

  FutureBuilder<List<CreditsModel>> getActors(int id) {
    return FutureBuilder(
      future: ApiPopular().getCredits(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Mientras se carga el Future, muestra un indicador de carga
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Si hay un error, muestra un mensaje de error
          return Text('Error: ${snapshot.error}');
        } else {
          // Una vez que el Future se completa con éxito, muestra los datos en un ListView
          final data = snapshot.data;
          if (data == null) {
            return const Center(
              child: Text("No data found"),
            );
          } else {
            actors = "";
            final filterActor = data.map((e) {
              if (e.knownForDepartment! == "Acting") {
                actors =
                    "$actors, ${e.name ?? 'no name'}-${e.img ?? 'https://pic.re/image'}";
                return e;
              }
            }).toList();
            return ListView(
              scrollDirection: Axis.horizontal,
              children: filterActor.map((e) {
                if (e == null) {
                  return ActorsWidget(
                    name: 'no name',
                    img: 'https://pic.re/image',
                  );
                }

                var img = 'https://pic.re/image';
                if (e.img != null) {
                  img = "https://image.tmdb.org/t/p/w500/${e.img}";
                }
                var name = 'vacio';
                if (e.name != null) {
                  name = "${e.name}";
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ActorsWidget(
                    name: name,
                    img: img,
                  ),
                );
              }).toList(),
            );
          }
        }
      },
    );
  }

  Future<void> getMovie(String id) async {
    final data = await MovieController().getFavoriteByMovieId(id);
    if (data!.isNotEmpty) {
      movieFavorite = data[0];
      setState(() {});
    }
  }

  Future<String> getYTKey(int id) async {
    final data = await ApiPopular().getDetailMovie(id);
    if (data.isNotEmpty) {
      movieFavorite!.keyYT = data[0].id!;
    }
    return "fO2a-5Wyh0I";
  }
}
