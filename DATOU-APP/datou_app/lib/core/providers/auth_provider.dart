import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _init();
  }

  void _init() {
    // Listen to auth state changes
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        state = AuthState(
          isAuthenticated: true,
          userId: session.user.id,
          email: session.user.email,
        );
      } else {
        state = const AuthState(
          isAuthenticated: false,
          userId: null,
          email: null,
        );
      }
    });

    // Check initial auth state
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      state = AuthState(
        isAuthenticated: true,
        userId: session.user.id,
        email: session.user.email,
      );
    }
  }

  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
  }

  Future<void> signInAnonymously() async {
    await Supabase.instance.client.auth.signInAnonymously();
  }
}

class AuthState {
  final bool isAuthenticated;
  final String? userId;
  final String? email;

  const AuthState({
    this.isAuthenticated = false,
    this.userId,
    this.email,
  });

  bool get isGuest => !isAuthenticated;
}
