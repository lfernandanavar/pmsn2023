import 'package:pmsn20232/database/agendadb.dart';
import 'package:pmsn20232/models/movie_model.dart';

class MovieController {
  final tbl = "tblMovies";

  Future<List<MovieModel>> get() async {
    var conexion = await AgendaDB().database;
    var result = await conexion!.query(tbl);
    return result.map((movie) => MovieModel.fromMap(movie)).toList();
  }

  Future<List<MovieModel>?> getFavoriteByMovieId(String data) async {
    var conexion = await AgendaDB().database;
    var result =
        await conexion!.query(tbl, where: "movie = ?", whereArgs: [data]);
    return result.map((e) => MovieModel.fromMap(e)).toList();
  }

  Future<int> insert(Map<String, dynamic> data) async {
    var conexion = await AgendaDB().database;
    return conexion!.insert(tbl, data);
  }

  Future<int> update(Map<String, dynamic> data) async {
    var conexion = await AgendaDB().database;
    return conexion!
        .update(tbl, data, where: 'movie = ?', whereArgs: [data['movie']]);
  }

  Future<int> delete(Map<String, dynamic> data) async {
    var conexion = await AgendaDB().database;
    return conexion!
        .delete(tbl, where: 'movie = ?', whereArgs: [data['movie']]);
  }

  Future<int> deleteByID(Map<String, dynamic> data) async {
    var conexion = await AgendaDB().database;
    return conexion!.delete(tbl, where: 'idMovie = ?', whereArgs: [data['id']]);
  }
}
