// providers/auth_provider.dart
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  final DatabaseService _databaseService;
  
  UserModel? _currentUser;
  bool _isLoading = false;

  AuthProvider(this._authService, this._databaseService) {
    _loadCurrentUser();
  }

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  Future<void> _loadCurrentUser() async {
    _authService.authStateChanges.listen((firebaseUser) async {
      if (firebaseUser != null) {
        _currentUser = await _databaseService.getUser(firebaseUser.uid);
      } else {
        _currentUser = null;
      }
      notifyListeners();
    });
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final user = await _authService.signInWithEmail(email, password);
      if (user != null) {
        _currentUser = await _databaseService.getUser(user.id);
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final user = await _authService.signInWithGoogle();
      if (user != null) {
        await _databaseService.saveUser(user);
        _currentUser = user;
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> updateUserProfile(UserModel user) async {
    await _databaseService.saveUser(user);
    _currentUser = user;
    notifyListeners();
  }
}