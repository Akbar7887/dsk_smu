class Kompleks {
  String active;
  int id;
  String name;

  Kompleks({required this.active, required this.id, required this.name});

  factory Kompleks.fromJson(Map<String, dynamic> json) {
    return Kompleks(
      active: json['active'],
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active'] = this.active;
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
