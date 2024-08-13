import '../utilities/static_data.dart';

class UserModel {
  final String name;
  final String email;
  final String password;
  final int phoneNumber;
  final String imagePath;
  final UserRole? userRole;
  final String? occupation;
  final String? occupationDetail;
  final Map<String, String>? studentId;
  final String? staffId;
  final List<String>? staffBatches;
  final Map<String, String>? batch;
  final Map<String, String>? currentBatch;
  final Map<String, dynamic>? courses;

  const UserModel({
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.imagePath,
    required this.userRole,
    this.occupation,
    this.occupationDetail,
    this.studentId,
    this.staffId,
    this.batch,
    this.currentBatch,
    this.courses,
    this.staffBatches,
  });

  // copyWith method
  UserModel copyWith({
    String? name,
    String? email,
    String? password,
    int? phoneNumber,
    String? imagePath,
    UserRole? userRole,
    String? occupation,
    String? occupationDetail,
    Map<String, String>? studentId,
    Map<String, String>? batch,
    Map<String, String>? currentBatch,
    Map<String, dynamic>? courses,
    String? staffId,
    List<String>? staffBatches,
  }) {
    return UserModel(
      name: name?.toString().trim() ?? this.name,
      email: email?.toString().trim() ?? this.email,
      password: password?.toString().trim() ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      imagePath: imagePath ?? this.imagePath,
      userRole: userRole ?? this.userRole,
      occupation: occupation ?? this.occupation,
      occupationDetail: occupationDetail ?? this.occupationDetail,
      studentId: studentId?.map((key, value) =>
              MapEntry(key.toUpperCase(), value.toUpperCase())) ??
          this.studentId,
      staffId: staffId?.toUpperCase() ?? this.staffId,
      batch: batch?.map((key, value) =>
              MapEntry(key.toUpperCase(), value.toUpperCase())) ??
          this.batch,
      currentBatch: currentBatch?.map((key, value) =>
              MapEntry(key.toUpperCase(), value.toUpperCase())) ??
          this.currentBatch,
      courses: courses ?? this.courses,
      staffBatches:
          staffBatches?.map((value) => value.toUpperCase()).toList() ??
              this.staffBatches,
    );
  }

  // toString method
  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, password: $password, phoneNumber: $phoneNumber, imagePath: $imagePath, userRole: $userRole'
        '${userRole == UserRole.staff ? ', staffId: $staffId, courses: $courses , Batches: $staffBatches' : ''}'
        '${userRole == UserRole.admin ? ', staffId: $staffId, courses: $courses' : ''}'
        '${userRole == UserRole.student ? ', occupation: $occupation, occupationDetail: $occupationDetail, studentId: $studentId, batch: $batch, currentBatch: $currentBatch' : ''})';
  }

  // fromJson method
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userRole = UserRole.fromString(json['userRole'].toString());
    return UserModel(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      phoneNumber: int.parse(json['phoneNo'].toString()),
      imagePath: json['imagePath'],
      userRole: userRole,
      occupation: userRole == UserRole.student ? json['occupation'] : null,
      occupationDetail:
          userRole == UserRole.student ? json['occupationDetail'] : null,
      studentId: userRole == UserRole.student
          ? (json['id'] as Map<String, dynamic>).map((key, value) =>
              MapEntry(key.toUpperCase(), value.toString().toUpperCase()))
          : null,
      staffId: userRole == UserRole.staff || userRole == UserRole.admin
          ? json['id'].toString().toUpperCase()
          : null,
      batch: userRole == UserRole.student
          ? (json['batch'] as Map<String, dynamic>).map((key, value) =>
              MapEntry(key.toUpperCase(), value.toString().toUpperCase()))
          : null,
      currentBatch: userRole == UserRole.student
          ? (json['currentBatch'] as Map<String, dynamic>).map((key, value) =>
              MapEntry(key.toUpperCase(), value.toString().toUpperCase()))
          : null,
      courses: userRole == UserRole.staff ||
              userRole == UserRole.admin && json['courses'] != null
          ? Map<String, dynamic>.from(json['courses'])
          : null,
      staffBatches: userRole == UserRole.staff && json["batches"] != null
          ? List.from(json["batches"])
              .map((value) => value.toString().toUpperCase())
              .toList()
          : null,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    final json = {
      'name': name,
      'email': email,
      'password': password,
      'phoneNo': phoneNumber,
      'imagePath': imagePath,
      'userRole': userRole?.name,
    };

    if (userRole == UserRole.staff) {
      if (staffBatches != null) {
        json.addAll({
          'batches': staffBatches!.map((value) => value.toUpperCase()).toList(),
        });
      }
      json.addAll({
        'id': staffId!.toUpperCase(),
        'courses': courses,
      });
    } else if (userRole == UserRole.admin) {
      json.addAll({
        'id': staffId!.toUpperCase(),
        'courses': courses,
      });
    } else if (userRole == UserRole.student) {
      json.addAll({
        'occupation': occupation,
        'occupationDetail': occupationDetail,
        'id': studentId!.map(
            (key, value) => MapEntry(key.toUpperCase(), value.toUpperCase())),
        'batch': batch!.map(
            (key, value) => MapEntry(key.toUpperCase(), value.toUpperCase())),
        'currentBatch': currentBatch!.map(
            (key, value) => MapEntry(key.toUpperCase(), value.toUpperCase())),
      });
    }

    return json;
  }

  // const empty method
  static const empty = UserModel(
    name: '',
    email: '',
    password: '',
    phoneNumber: 0,
    imagePath: '',
    userRole: null,
    occupation: '',
    occupationDetail: '',
    staffId: '',
    studentId: {},
    batch: {},
    currentBatch: {},
    courses: {},
  );

  // isNotEmpty method
  bool get isNotEmpty {
    return name.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        phoneNumber != 0 &&
        imagePath.isNotEmpty;
  }
}
