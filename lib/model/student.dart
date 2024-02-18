
enum StudentOcc { college, professional }

class Student {
  String name;
  String email;
  String phoneNo;
  StudentOcc occupation;
  String occDetail;

  Student({
    required this.name,
    required this.email,
    required this.phoneNo,
    required this.occupation,
    required this.occDetail,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneNo': phoneNo,
      'occupation':
          occupation.toString().split('.').last,
      'occDetail': occDetail,
    };
  }
}
