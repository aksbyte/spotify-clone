import 'package:client/core/providers/current_user_notifier_provider.dart';
import 'package:client/core/model/user_model.dart';
import 'package:client/repositories/auth_local_repository.dart';
import 'package:client/repositories/auth_remote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../helper/logcat.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late AuthRemoteRepository _authRemoteRepository;
  late AuthLocalRepository _authLocalRepository;
  late CurrentUserNotifier _currentUserNotifier;

  AsyncValue<UserModel>? build() {
    // ignore: avoid_manual_providers_as_generated_provider_dependency
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    // ignore: avoid_manual_providers_as_generated_provider_dependency
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    // ignore: avoid_manual_providers_as_generated_provider_dependency
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);

    return null;
  }

  Future<void> initSharedPreferences() async {
    await _authLocalRepository.init();
  }

  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepository.signup(
      name: name,
      email: email,
      password: password,
    );
    final value = res.fold(
      (l) => state = AsyncValue.error(l.toString(), StackTrace.current),
      (r) => state = AsyncValue.data(r),
    );
    //logCat(value.toString());
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    await _authLocalRepository.init();
    final res = await _authRemoteRepository.login(
      email: email,
      password: password,
    );
    final value = res.fold(
      (l) => state = AsyncValue.error(l.toString(), StackTrace.current),
      (r) => _loginSuccess(r),
    );
    //logCat(value.toString());
  }

  AsyncValue<UserModel>? _loginSuccess(UserModel user) {
    _authLocalRepository.setToken(user.token);
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }

  Future<UserModel?> getData() async {
    state = const AsyncValue.loading();
    final token = _authLocalRepository.getToken();
    if (token != null) {
      final res = await _authRemoteRepository.getCurrentUser(token: token);
      final val = res.fold(
        (l) => state = AsyncValue.error(l.toString(), StackTrace.current),
        (r) => _getDataSuccess(r),
      );

      return val.value;
    }
    return null;
  }

  AsyncValue<UserModel> _getDataSuccess(UserModel user) {
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }
}
