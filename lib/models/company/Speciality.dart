class Speciality {
  final int id;
  final String title;
  final String image;

  Speciality({required this.id, required this.title, required this.image});

  factory Speciality.fromJson(Map<String, dynamic> json) {
    return Speciality(id: json['id'], title: json['title'], image: json['image']);
  }
}
