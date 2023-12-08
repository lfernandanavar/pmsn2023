import 'package:pmsn20232/database/agendadb.dart';
import 'package:pmsn20232/models/career_model.dart';

class CareerController {
  String tbl = 'tblCareer';

  Future<List<CareerModel>> get() async {
    var conexion = await AgendaDB().database;
    var result = await conexion!.query(tbl);
    return result.map((career) => CareerModel.fromMap(career)).toList();
  }

  Future<List<String>> getAllStringName() async {
    List<String> list =
        await get().then((value) => value.map((e) => e.career!).toList());
    return list;
  }

  Future<int> insert(Map<String, dynamic> data) async {
    var conexion = await AgendaDB().database;
    return conexion!.insert(tbl, data);
  }

  Future<int> update(Map<String, dynamic> data) async {
    var conexion = await AgendaDB().database;
    return conexion!.update(tbl, data,
        where: 'idCareer = ?', whereArgs: [data['idCareer']]);
  }

  Future<int> delete(int id) async {
    var conexion = await AgendaDB().database;
    return conexion!.delete(tbl, where: 'idCareer = ?', whereArgs: [id]);
  }

  Future<List<CareerModel>> getCareerByName(String data) async {
    var conexion = await AgendaDB().database;
    var result = await conexion!
        .query(tbl, where: "career LIKE ?", whereArgs: ['%$data%']);
    return result.map((career) => CareerModel.fromMap(career)).toList();
  }
}
