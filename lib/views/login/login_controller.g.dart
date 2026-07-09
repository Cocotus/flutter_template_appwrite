// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controller for the login/register screen.
///
/// Holds no widget-lifecycle objects and never receives a `BuildContext`.
/// It only receives plain [String] values from the view and exposes its
/// progress as an `AsyncValue<void>`: loading while a request runs, data on
/// success, error on failure. The view reacts via `ref.listen`.

@ProviderFor(LoginController)
final loginControllerProvider = LoginControllerProvider._();

/// Controller for the login/register screen.
///
/// Holds no widget-lifecycle objects and never receives a `BuildContext`.
/// It only receives plain [String] values from the view and exposes its
/// progress as an `AsyncValue<void>`: loading while a request runs, data on
/// success, error on failure. The view reacts via `ref.listen`.
final class LoginControllerProvider
    extends $AsyncNotifierProvider<LoginController, void> {
  /// Controller for the login/register screen.
  ///
  /// Holds no widget-lifecycle objects and never receives a `BuildContext`.
  /// It only receives plain [String] values from the view and exposes its
  /// progress as an `AsyncValue<void>`: loading while a request runs, data on
  /// success, error on failure. The view reacts via `ref.listen`.
  LoginControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginControllerHash();

  @$internal
  @override
  LoginController create() => LoginController();
}

String _$loginControllerHash() => r'e4d3e34f7d6318ee2f7ebe2799599a3dc79e337e';

/// Controller for the login/register screen.
///
/// Holds no widget-lifecycle objects and never receives a `BuildContext`.
/// It only receives plain [String] values from the view and exposes its
/// progress as an `AsyncValue<void>`: loading while a request runs, data on
/// success, error on failure. The view reacts via `ref.listen`.

abstract class _$LoginController extends $AsyncNotifier<void> {
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
