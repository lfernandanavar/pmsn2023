class TeacherModel {
  int? idTeacher;
  int? idCareer;
  String? name;
  String? email;

  TeacherModel({this.idTeacher, this.name, this.email, this.idCareer});

  factory TeacherModel.fromMap(Map<String, dynamic> map) {
    return TeacherModel(
      idTeacher: map['idTeacher'],
      name: map['name'],
      idCareer: map['idCareer'],
      email: map['email'],
    );
  }

  Map<String, dynamic> getValuesMap() {
    return {
      'idTeacher': idTeacher,
      'name': name,
      'email': email,
      'idCareer': idCareer,
    };
  }
}
