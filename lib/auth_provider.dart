import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_service.dart';
import 'models.dart';
import 'storage_service.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final String? token;
  final String? username;
  final User? user;

  bool get isLoggedIn => token != null && token!.isNotEmpty;

  const AuthState({
    this.isLoading = false,
    this.error,
    this.token,
    this.username,
    this.user,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    String? token,
    String? username,
    User? user,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      token: token ?? this.token,
      username: username ?? this.username,
      user: user ?? this.user,
    );
  }
}

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState();
  }

  Future<void> login(String username, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final api = ref.read(apiServiceProvider);
      final storage = ref.read(storageServiceProvider);

      final token = await api.login(username, password);
      await storage.saveSession(token, username);
      final user = await api.fetchUserByUsername(username);

      state = state.copyWith(
        isLoading: false,
        token: token,
        username: username,
        user: user,
      );
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'Network error. Please check your connection.',
      );
    }
  }

  Future<void> logout() async {
    await ref.read(storageServiceProvider).clearSession();
    state = const AuthState();
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);
