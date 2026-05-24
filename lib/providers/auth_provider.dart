// lib/providers/auth_provider.dart
import 'package:flutter/foundation.dart';

enum UserRole { relator, mahasiswa }

class AuthProvider extends ChangeNotifier {
  UserRole? _role;
  bool _isLoggedIn = false;

  UserRole? get role => _role;
  bool get isLoggedIn => _isLoggedIn;
  bool get isRelator => _role == UserRole.relator;

  String get roleLabel => _role == UserRole.relator ? 'Relator Kelas' : 'Mahasiswa';

  void login(UserRole role) {
    _role = role;
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _role = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
