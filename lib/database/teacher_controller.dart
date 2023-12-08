import 'package:pmsn20232/database/agendadb.dart';
import 'package:pmsn20232/models/teacher_model.dart';

class TeacherController {
  String tbl = 'tblTeacher';

  Future<List<TeacherModel>> get() async {
    var conexion = await AgendaDB().database;
    var result = await conexion!.query(tbl);
    return result.map((teacher) => TeacherModel.fromMap(teacher)).toList();
  }

  Future<List<String>> getAllStringName() async {
    List<String> list =
        await get().then((value) => value.map((e) => e.name!).toList());
    return list;
  }

  Future<int> insert(Map<String, dynamic> data) async {
    var conexion = await AgendaDB().database;
    return conexion!.insert(tbl, data);
  }

  Future<int> update(Map<String, dynamic> data) async {
    var conexion = await AgendaDB().database;
    return conexion!.update(tbl, data,
        where: 'idTeacher = ?', whereArgs: [data['idTeacher']]);
  }

  Future<int> delete(int id) async {
    var conexion = await AgendaDB().database;
    return conexion!.delete(tbl, where: 'idTeacher = ?', whereArgs: [id]);
  }

  Future<List<TeacherModel>> getTeacherByName(String data) async {
    var conexion = await AgendaDB().database;
    var result = await conexion!
        .query(tbl, where: "name LIKE ?", whereArgs: ['%$data%']);
    return result.map((teacher) => TeacherModel.fromMap(teacher)).toList();
  }
}
