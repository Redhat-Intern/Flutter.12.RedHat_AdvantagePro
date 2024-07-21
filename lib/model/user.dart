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
  final Map<String, String>? id;
  final Map<String, String>? batch;
  final Map<String, String>? currentBatch;
  final int? experience;
  final List<String>? certificates;

  const UserModel({
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.imagePath,
    required this.userRole,
    this.occupation,
    this.occupationDetail,
    this.id,
    this.batch,
    this.currentBatch,
    this.experience,
    this.certificates,
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
    Map<String, String>? id,
    Map<String, String>? batch,
    Map<String, String>? currentBatch,
    int? experience,
    List<String>? certificates,
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
      id: id ?? this.id,
      batch: batch ?? this.batch,
      currentBatch: currentBatch ?? this.currentBatch,
      experience: experience ?? this.experience,
      certificates: certificates ?? this.certificates,
    );
  }

  // toString method
  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, password: $password, phoneNumber: $phoneNumber, imagePath: $imagePath, userRole: $userRole'
        '${userRole == UserRole.staff ? ', experience: $experience, certificates: $certificates' : ''}'
        '${userRole == UserRole.student ? ', occupation: $occupation, occupationDetail: $occupationDetail, id: $id, batch: $batch, currentBatch: $currentBatch' : ''})';
  }

  // fromJson method
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userRole = UserRole.fromString(json['userRole'].toString());
    return UserModel(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      phoneNumber: int.parse(json['phoneNumber'].toString()),
      imagePath: json['imagePath'],
      userRole: userRole,
      occupation: userRole == UserRole.student ? json['occupation'] : null,
      occupationDetail:
          userRole == UserRole.student ? json['occupationDetail'] : null,
      id: userRole == UserRole.student
          ? (json['id'] as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, value.toString()))
          : null,
      batch: userRole == UserRole.student
          ? (json['batch'] as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, value.toString()))
          : null,
      currentBatch: userRole == UserRole.student
          ? (json['currentBatch'] as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, value.toString()))
          : null,
      experience: userRole == UserRole.staff ? json['experience'] : null,
      certificates: userRole == UserRole.staff
          ? List<String>.from(json['certificates'])
          : null,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    final json = {
      'name': name,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'imagePath': imagePath,
      'userRole': userRole?.index,
    };

    if (userRole == UserRole.staff) {
      json.addAll({
        'experience': experience,
        'certificates': certificates,
      });
    } else if (userRole == UserRole.student) {
      json.addAll({
        'occupation': occupation,
        'occupationDetail': occupationDetail,
        'id': id,
        'batch': batch,
        'currentBatch': currentBatch,
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
    id: {},
    batch: {},
    currentBatch: {},
    experience: 0,
    certificates: [],
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
