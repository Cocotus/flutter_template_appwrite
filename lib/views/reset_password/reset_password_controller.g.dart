// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controller for the password-reset completion screen.
///
/// Holds no widget-lifecycle objects and never receives a `BuildContext` —
/// same shape as [LoginController], just for the other half of the recovery
/// flow (see `AuthService.completePasswordReset`).

@ProviderFor(ResetPasswordController)
final resetPasswordControllerProvider = ResetPasswordControllerProvider._();

/// Controller for the password-reset completion screen.
///
/// Holds no widget-lifecycle objects and never receives a `BuildContext` —
/// same shape as [LoginController], just for the other half of the recovery
/// flow (see `AuthService.completePasswordReset`).
final class ResetPasswordControllerProvider
    extends $AsyncNotifierProvider<ResetPasswordController, void> {
  /// Controller for the password-reset completion screen.
  ///
  /// Holds no widget-lifecycle objects and never receives a `BuildContext` —
  /// same shape as [LoginController], just for the other half of the recovery
  /// flow (see `AuthService.completePasswordReset`).
  ResetPasswordControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resetPasswordControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resetPasswordControllerHash();

  @$internal
  @override
  ResetPasswordController create() => ResetPasswordController();
}

String _$resetPasswordControllerHash() =>
    r'9a1209f20797035e70ad18250a249e160e97054b';

/// Controller for the password-reset completion screen.
///
/// Holds no widget-lifecycle objects and never receives a `BuildContext` —
/// same shape as [LoginController], just for the other half of the recovery
/// flow (see `AuthService.completePasswordReset`).

abstract class _$ResetPasswordController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
