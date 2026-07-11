// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controller for the home page's widget demo.
///
/// Shows the template's standard controller pattern in its smallest form:
/// the view calls plain methods, the controller owns an `AsyncValue` state,
/// and a fake [save] demonstrates the loading-spinner flow of
/// `AppPrimaryButton`. Replace together with `HomeView` when you build your
/// app's real home page.

@ProviderFor(HomeController)
final homeControllerProvider = HomeControllerProvider._();

/// Controller for the home page's widget demo.
///
/// Shows the template's standard controller pattern in its smallest form:
/// the view calls plain methods, the controller owns an `AsyncValue` state,
/// and a fake [save] demonstrates the loading-spinner flow of
/// `AppPrimaryButton`. Replace together with `HomeView` when you build your
/// app's real home page.
final class HomeControllerProvider
    extends $AsyncNotifierProvider<HomeController, HomeDemoState> {
  /// Controller for the home page's widget demo.
  ///
  /// Shows the template's standard controller pattern in its smallest form:
  /// the view calls plain methods, the controller owns an `AsyncValue` state,
  /// and a fake [save] demonstrates the loading-spinner flow of
  /// `AppPrimaryButton`. Replace together with `HomeView` when you build your
  /// app's real home page.
  HomeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeControllerHash();

  @$internal
  @override
  HomeController create() => HomeController();
}

String _$homeControllerHash() => r'9835db4180d6aa0d839407c51397780dd29ae39b';

/// Controller for the home page's widget demo.
///
/// Shows the template's standard controller pattern in its smallest form:
/// the view calls plain methods, the controller owns an `AsyncValue` state,
/// and a fake [save] demonstrates the loading-spinner flow of
/// `AppPrimaryButton`. Replace together with `HomeView` when you build your
/// app's real home page.

abstract class _$HomeController extends $AsyncNotifier<HomeDemoState> {
  FutureOr<HomeDemoState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<HomeDemoState>, HomeDemoState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<HomeDemoState>, HomeDemoState>,
              AsyncValue<HomeDemoState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
