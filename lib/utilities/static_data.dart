import 'package:flutter/material.dart';

enum From { detail, add, edit }

enum CourseContentShifter { Title, Topics }

enum UserRole { student, staff, admin }

enum LoginSignup { login, singup }

enum ForumCategory { all, groups, staffs, students }

enum NotificationsCategory { invitations, admin, batches, students, staffs }

enum Status { online, offline }

enum MessageType { text, image, video, file, link }

const List<String> searchData = ["batches", "staffs", "students"];

const List<Color> primaryColors = [
  Color(0XFF5D44F8),
  Color(0XFFFA61D7),
  Color(0XFFFFAA57),
  Color(0XFF2ADDC7),
];
