import 'package:flutter/material.dart';

// Enum Definitions
enum From { detail, add, edit }

enum CourseContentShifter { Title, Topics }

enum FontFamilyENUM { IstokWeb, Lato, Nunito, Merriweather }

// File Categories Mapping
// Maps file extensions to their respective categories
final Map<String, String> fileCategories = {
  // Image extensions
  '.jpg': 'image',
  '.jpeg': 'image',
  '.png': 'image',
  '.gif': 'image',
  '.bmp': 'image',
  '.webp': 'image',
  '.svg': 'image',

  // Video extensions
  '.mp4': 'video',
  '.mov': 'video',
  '.avi': 'video',
  '.mkv': 'video',
  '.flv': 'video',
  '.wmv': 'video',
  '.webm': 'video',

  // Audio extensions
  '.mp3': 'audio',
  '.wav': 'audio',
  '.aac': 'audio',
  '.flac': 'audio',
  '.ogg': 'audio',
  '.m4a': 'audio',
  '.opus': 'audio',

  // Document extensions
  '.pdf': 'document',
  '.doc': 'document',
  '.docx': 'document',
  '.xls': 'document',
  '.xlsx': 'document',
  '.ppt': 'document',
  '.pptx': 'document',
  '.txt': 'document',
  '.csv': 'document',
  '.rtf': 'document',

  // Archive extensions
  '.zip': 'archive',
  '.rar': 'archive',
  '.7z': 'archive',
  '.tar': 'archive',
  '.gz': 'archive',

  // Other potential file types (commented out for future use)
  // '.exe': 'executable',
  // '.apk': 'executable',
  // '.iso': 'disk image',
};

// User Roles Enum
enum UserRole {
  student,
  staff,
  admin,
  superAdmin;

  // Provides display names for user roles
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

  // Converts a string to a UserRole enum value
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

// Other Enums
enum LoginSignup { login, signup }

enum ForumCategory { all, groups, staffs, students }

enum NotificationsCategory { invitations, admin, batches, students, staffs }

enum Status { online, offline }

enum MessageType { text, image, video, audio, document }

enum WorkStatus { completed, pending, not_Started }

enum TestType { live, daily }

enum SnackBarType { success, error, info }

enum CourseFileListFrom { staffDetail, courseConent }

// Constant Lists and Maps
const List<String> searchData = [
  "batches",
  "staffs",
  "students"
]; // Used for searching various entities

const emojis = ["🤩", "😇", "😎", "🥶", "😢", "🥵", "🤕"];

// Primary colors used in the application
const List<Color> primaryColors = [
  Color(0XFF5D44F8),
  Color(0XFFFA61D7),
  Color(0XFFFFAA57),
  Color(0XFF2ADDC7),
];

// Sample Data for quizzes or tests
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
