import 'package:coffee_app/services/auth/auth_user.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateUnInitialized extends AuthState {
  const AuthStateUnInitialized() : super();
}

class AuthStateInitialized extends AuthState {
  const AuthStateInitialized() : super();
}

class AuthStateRegistering extends AuthState {
  const AuthStateRegistering() : super();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({required this.user}) : super();
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification() : super();
}

class AuthStateLoggedOut extends AuthState {
  const AuthStateLoggedOut() : super();
}
