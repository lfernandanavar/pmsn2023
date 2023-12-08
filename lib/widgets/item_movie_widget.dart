import 'package:flutter/material.dart';

Widget itemMovieWidget(dynamic movie, context, int type) {
  return GestureDetector(
    child: FadeInImage(
      fadeInDuration: const Duration(milliseconds: 500),
      placeholder: const AssetImage('assets/loading.gif'),
      image:
          NetworkImage('https://image.tmdb.org/t/p/w500/${movie.posterPath}'),
    ),
    onTap: () => Navigator.pushNamed(
      context,
      type == 1 ? '/detail' : '/detailFavorite',
      arguments: movie,
    ),
  );
}
