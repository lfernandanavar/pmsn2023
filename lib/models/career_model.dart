class CareerModel {
  int? idCareer;
  String? career;

  CareerModel({this.idCareer, this.career});

  factory CareerModel.fromMap(Map<String, dynamic> map) {
    return CareerModel(
      idCareer: map['idCareer'],
      career: map['career'],
    );
  }

  Map<String, dynamic> getValuesMap() {
    return {
      'idCareer': idCareer,
      'career': career,
    };
  }
}
