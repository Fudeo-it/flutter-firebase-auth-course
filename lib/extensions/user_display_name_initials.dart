import 'package:firebase_auth/firebase_auth.dart';

extension UserDisplayNameInitials on User {
  String get displayNameInitials {
    if (displayName == null || displayName!.isEmpty) {
      return '';
    }

    final split = displayName!.split(' ');
    if (split.length == 1) {
      return displayName!.substring(0, 1).toUpperCase();
    }

    return (split[0].substring(0, 1) + split[1].substring(0, 1)).toUpperCase();
  }
}