class MovieYoutubeModel {
  String? id;

  MovieYoutubeModel({this.id});

  factory MovieYoutubeModel.fromMap(Map<String, dynamic> map) {
    return MovieYoutubeModel(id: map['key']);
  }
}
