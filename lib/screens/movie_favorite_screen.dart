import 'package:flutter/material.dart';
import 'package:pmsn20232/database/movie_controller.dart';
import 'package:pmsn20232/models/movie_model.dart';
import 'package:pmsn20232/services/provider/detail_movie_favorite_provider.dart';
import 'package:pmsn20232/widgets/item_movie_widget.dart';
import 'package:provider/provider.dart';

class MovieFavoriteScreen extends StatefulWidget {
  const MovieFavoriteScreen({super.key});

  @override
  State<MovieFavoriteScreen> createState() => _MovieFavoriteScreenState();
}

class _MovieFavoriteScreenState extends State<MovieFavoriteScreen> {
  MovieController? movieController;

  @override
  void initState() {
    super.initState();
    movieController = MovieController();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DetailMovieFavoriteProvider>(context);
    if (provider.isUpdated) {}
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Screen"),
      ),
      body: FutureBuilder(
        future: movieController?.get(),
        builder: (context, AsyncSnapshot<List<MovieModel>?> snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              padding: const EdgeInsets.all(2),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .7,
                crossAxisSpacing: 5,
                mainAxisSpacing: 10,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return itemMovieWidget(snapshot.data![index], context, 0);
              },
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text("Algo salió mal"),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
