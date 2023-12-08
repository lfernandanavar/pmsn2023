class MovieModel {
  int? id;
  int? favorite;
  String? title;
  String? movie;
  String? keyYT;
  String? actors;
  String? overview;
  String? posterPath;
  double? voteAverage;

  MovieModel(
      {this.id,
      this.favorite,
      this.movie,
      this.keyYT,
      this.actors,
      this.overview,
      this.posterPath,
      this.voteAverage,
      this.title});

  factory MovieModel.fromMap(Map<String, dynamic> map) {
    return MovieModel(
      id: map['idMovie'],
      favorite: map['favorite'],
      movie: map['movie'],
      title: map['title'],
      overview: map['overview'],
      posterPath: map['poster_path'],
      voteAverage: map['vote_average'],
      actors: map['actors'],
      keyYT: map['key'],
    );
  }
}
