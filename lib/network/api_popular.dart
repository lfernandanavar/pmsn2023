import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pmsn20232/models/movie_youtube_model.dart';
import 'package:pmsn20232/models/api/credits_model.dart';
import 'package:pmsn20232/models/api/popular_model.dart';

class ApiPopular {
  Uri moviesLink = Uri.parse(
      'https://api.themoviedb.org/3/movie/popular?api_key=384e9389a683f1c69b464a2be42300f9&language=es-MX&page=1');

  Future<List<PopularModel>?> getAllPopular() async {
    var response = await http.get(moviesLink);
    if (response.statusCode == 200) {
      var jsonResult = jsonDecode(response.body)['results'] as List;
      return jsonResult
          .map((popular) => PopularModel.fromMap(popular))
          .toList();
    }

    return null;
  }

  Future<List<CreditsModel>> getCredits(int id) async {
    var creditsLink = Uri.parse(
        'https://api.themoviedb.org/3/movie/$id/credits?api_key=384e9389a683f1c69b464a2be42300f9&language=es-MX&page=1');
    var response = await http.get(creditsLink);
    if (response.statusCode == 200) {
      var jsonResult = jsonDecode(response.body)['cast'] as List;
      return jsonResult
          .map((credits) => CreditsModel.fromMap(credits))
          .toList();
    }
    return [];
  }

  Future<List<MovieYoutubeModel>> getDetailMovie(int id) async {
    var creditsLink = Uri.parse(
        'https://api.themoviedb.org/3/movie/$id/videos?api_key=384e9389a683f1c69b464a2be42300f9&language=es-MX');
    var response = await http.get(creditsLink);
    if (response.statusCode == 200) {
      var jsonResult = jsonDecode(response.body)['results'] as List;
      return jsonResult
          .map((credits) => MovieYoutubeModel.fromMap(credits))
          .toList();
    }
    return [];
  }
}
