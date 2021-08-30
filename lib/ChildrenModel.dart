
class Children {
  String st_id, name, avatar, roll_no;

  Children(
      {required this.st_id,
      required this.name,
      required this.avatar,
      required this.roll_no});

  factory Children.fromMap(Map<String, dynamic> json) => new Children(
      st_id: json['st_id'],
      name: json['name'],
      avatar: json['avatar'],
      roll_no: json['roll_no']);

  Map<String, dynamic> toMap() {
    return {
      'st_id': st_id,
      'name': name,
      'avatar': avatar,
      'roll_no': roll_no,
    };
  }
}
