import 'package:flutter/material.dart';

enum From { detail, add, edit }

enum CourseContentShifter { Title, Topics }

enum FontFamilyENUM { IstokWeb, Lato, Nunito, Merriweather }

enum UserRole {
  student,
  staff,
  admin,
  superAdmin;

  String get displayName {
    switch (this) {
      case UserRole.superAdmin:
        return 'superAdmin';
      case UserRole.admin:
        return 'admin';
      case UserRole.staff:
        return 'staff';
      case UserRole.student:
        return 'student';
    }
  }

  static UserRole fromString(String role) {
    switch (role.trim()) {
      case 'superAdmin':
        return UserRole.superAdmin;
      case 'admin':
        return UserRole.admin;
      case 'staff':
        return UserRole.staff;
      case 'student':
        return UserRole.student;
      default:
        throw ArgumentError('Invalid UserRole: $role');
    }
  }
}

enum LoginSignup { login, singup }

enum ForumCategory { all, groups, staffs, students }

enum NotificationsCategory { invitations, admin, batches, students, staffs }

enum Status { online, offline }

enum MessageType { text, image, file }

enum WorkStatus { completed, pending, not_Started }

enum TestType { live, daily }

enum CourseFileListFrom { staffDetail, courseConent }

const List<String> searchData = ["batches", "staffs", "students"];

enum SnackBarType { success, error, info }

const emojis = {
  "0": "🤩",
  "1": "😇",
  "2": "😎",
  "3": "🥶",
  "4": "😢",
  "5": "🥵",
  "6": "🤕",
};

const List<Color> primaryColors = [
  Color(0XFF5D44F8),
  Color(0XFFFA61D7),
  Color(0XFFFFAA57),
  Color(0XFF2ADDC7),
];

const List<Map<String, dynamic>> sample_data = [
  {
    "question": "What is the default package manager in Red Hat Linux?",
    "options": {"A": "Yum", "B": "Apt", "C": "Dnf", "D": "RPM"},
    "answer": "A"
  },
  {
    "question": "How do you change the hostname in Red Hat Linux?",
    "options": {
      "A": "hostnamectl",
      "B": "ifconfig",
      "C": "uname",
      "D": "ipconfig"
    },
    "answer": "A"
  },
  {
    "question":
        "What command is used to list all currently running processes in Red Hat Linux?",
    "options": {"A": "ps", "B": "ls", "C": "top", "D": "ps aux"},
    "answer": "A"
  },
  {
    "question":
        "What command is used to change file permissions in Red Hat Linux?",
    "options": {"A": "chmod", "B": "chown", "C": "chgrp", "D": "perm"},
    "answer": "A"
  },
  {
    "question": "How do you determine the size of a file in Red Hat Linux?",
    "options": {"A": "size", "B": "ls -l", "C": "du", "D": "file_size"},
    "answer": "C"
  },
  {
    "question": "What is the purpose of the /etc/passwd file in Red Hat Linux?",
    "options": {
      "A": "Stores password hashes",
      "B": "Stores user login information",
      "C": "Stores system configuration",
      "D": "Stores software repositories"
    },
    "answer": "B"
  },
];
