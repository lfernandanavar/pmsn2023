class CreditsModel {
  int? id;
  String? knownForDepartment;
  String? name;
  String? img;

  CreditsModel({
    this.id,
    this.name,
    this.img,
    this.knownForDepartment,
  });

  factory CreditsModel.fromMap(Map<String, dynamic> map) {
    return CreditsModel(
      id: map['id'],
      name: map['name'],
      img: map['profile_path'],
      knownForDepartment: map['known_for_department'],
    );
  }
}
