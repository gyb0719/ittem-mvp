import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';

class AuthService {
  UserModel? _currentUser;
  
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<AuthResult> signIn(String email, String password) async {
    try {
      // 실제로는 백엔드 API 호출
      await Future.delayed(const Duration(seconds: 2));
      
      // 더미 사용자 생성
      if (email == 'test@ittem.com' && password == 'password') {
        _currentUser = UserModel(
          id: '1',
          email: email,
          name: '김사용자',
          location: '강남구 역삼동',
          rating: 4.8,
          transactionCount: 23,
          isVerified: true,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          lastLoginAt: DateTime.now(),
        );
        return AuthResult.success(_currentUser!);
      } else {
        return AuthResult.failure('이메일 또는 비밀번호가 올바르지 않습니다.');
      }
    } catch (e) {
      return AuthResult.failure('로그인 중 오류가 발생했습니다: $e');
    }
  }

  Future<AuthResult> signUp({
    required String email,
    required String password,
    required String name,
    required String location,
    String? phoneNumber,
    String? residentNumber,
  }) async {
    try {
      // 실제로는 백엔드 API 호출
      await Future.delayed(const Duration(seconds: 2));
      
      _currentUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: name,
        location: location,
        phoneNumber: phoneNumber,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );
      
      return AuthResult.success(_currentUser!);
    } catch (e) {
      return AuthResult.failure('회원가입 중 오류가 발생했습니다: $e');
    }
  }

  Future<AuthResult> signInWithGoogle() async {
    try {
      // 실제로는 Google Sign-In 구현
      await Future.delayed(const Duration(seconds: 2));
      
      _currentUser = UserModel(
        id: 'google_${DateTime.now().millisecondsSinceEpoch}',
        email: 'google.user@gmail.com',
        name: '구글 사용자',
        location: '강남구 역삼동',
        profileImageUrl: 'https://example.com/profile.jpg',
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );
      
      return AuthResult.success(_currentUser!);
    } catch (e) {
      return AuthResult.failure('Google 로그인 중 오류가 발생했습니다: $e');
    }
  }

  Future<AuthResult> signInWithApple() async {
    try {
      // 실제로는 Apple Sign-In 구현
      await Future.delayed(const Duration(seconds: 2));
      
      _currentUser = UserModel(
        id: 'apple_${DateTime.now().millisecondsSinceEpoch}',
        email: 'apple.user@icloud.com',
        name: 'Apple 사용자',
        location: '강남구 역삼동',
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );
      
      return AuthResult.success(_currentUser!);
    } catch (e) {
      return AuthResult.failure('Apple 로그인 중 오류가 발생했습니다: $e');
    }
  }

  Future<void> signOut() async {
    _currentUser = null;
  }

  Future<bool> resetPassword(String email) async {
    try {
      // 실제로는 백엔드 API 호출
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<AuthResult> updateProfile({
    String? name,
    String? location,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    if (_currentUser == null) {
      return AuthResult.failure('로그인이 필요합니다.');
    }

    try {
      await Future.delayed(const Duration(seconds: 1));
      
      _currentUser = _currentUser!.copyWith(
        name: name,
        location: location,
        phoneNumber: phoneNumber,
        profileImageUrl: profileImageUrl,
      );
      
      return AuthResult.success(_currentUser!);
    } catch (e) {
      return AuthResult.failure('프로필 업데이트 중 오류가 발생했습니다: $e');
    }
  }
}

class AuthResult {
  final bool isSuccess;
  final UserModel? user;
  final String? error;

  AuthResult.success(this.user) : isSuccess = true, error = null;
  AuthResult.failure(this.error) : isSuccess = false, user = null;
}

// Riverpod 프로바이더
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final currentUserProvider = StateProvider<UserModel?>((ref) => null);

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier(ref.read(authServiceProvider));
});

class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthStateNotifier(this._authService) : super(AuthState.initial());

  Future<void> signIn(String email, String password) async {
    state = AuthState.loading();
    final result = await _authService.signIn(email, password);
    
    if (result.isSuccess) {
      state = AuthState.authenticated(result.user!);
    } else {
      state = AuthState.error(result.error!);
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String location,
    String? phoneNumber,
    String? residentNumber,
  }) async {
    state = AuthState.loading();
    final result = await _authService.signUp(
      email: email,
      password: password,
      name: name,
      location: location,
      phoneNumber: phoneNumber,
      residentNumber: residentNumber,
    );
    
    if (result.isSuccess) {
      state = AuthState.authenticated(result.user!);
    } else {
      state = AuthState.error(result.error!);
    }
  }

  Future<void> signInWithGoogle() async {
    state = AuthState.loading();
    final result = await _authService.signInWithGoogle();
    
    if (result.isSuccess) {
      state = AuthState.authenticated(result.user!);
    } else {
      state = AuthState.error(result.error!);
    }
  }

  Future<void> signInWithApple() async {
    state = AuthState.loading();
    final result = await _authService.signInWithApple();
    
    if (result.isSuccess) {
      state = AuthState.authenticated(result.user!);
    } else {
      state = AuthState.error(result.error!);
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    state = AuthState.unauthenticated();
  }

  void clearError() {
    if (state is AuthStateError) {
      state = AuthState.unauthenticated();
    }
  }
}

abstract class AuthState {
  const AuthState();
  
  factory AuthState.initial() => const AuthStateInitial();
  factory AuthState.loading() => const AuthStateLoading();
  factory AuthState.authenticated(UserModel user) => AuthStateAuthenticated(user);
  factory AuthState.unauthenticated() => const AuthStateUnauthenticated();
  factory AuthState.error(String message) => AuthStateError(message);
}

class AuthStateInitial extends AuthState {
  const AuthStateInitial();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateAuthenticated extends AuthState {
  final UserModel user;
  const AuthStateAuthenticated(this.user);
}

class AuthStateUnauthenticated extends AuthState {
  const AuthStateUnauthenticated();
}

class AuthStateError extends AuthState {
  final String message;
  const AuthStateError(this.message);
}