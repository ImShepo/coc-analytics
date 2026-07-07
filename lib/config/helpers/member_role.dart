import 'package:flutter/material.dart';

Color memberRoleColor(String role) {
  switch (role) {
    case 'leader':
      return const Color(0xFFD4A017);
    case 'coLeader':
      return const Color(0xFF6A5ACD);
    case 'admin':
      return const Color(0xFF2E7D32);
    default:
      return const Color(0xFF757575);
  }
}
