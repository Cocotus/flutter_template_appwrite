// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controller for the profile view.
///
/// The profile data itself comes straight from `currentUserProvider`; this
/// controller only owns the logout action and its progress state.

@ProviderFor(ProfileController)
final profileControllerProvider = ProfileControllerProvider._();

/// Controller for the profile view.
///
/// The profile data itself comes straight from `currentUserProvider`; this
/// controller only owns the logout action and its progress state.
final class ProfileControllerProvider
    extends $AsyncNotifierProvider<ProfileController, void> {
  /// Controller for the profile view.
  ///
  /// The profile data itself comes straight from `currentUserProvider`; this
  /// controller only owns the logout action and its progress state.
  ProfileControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileControllerHash();

  @$internal
  @override
  ProfileController create() => ProfileController();
}

String _$profileControllerHash() => r'42aaff2a8bbd347b218b6c625271c6732fe04822';

/// Controller for the profile view.
///
/// The profile data itself comes straight from `currentUserProvider`; this
/// controller only owns the logout action and its progress state.

abstract class _$ProfileController extends $AsyncNotifier<void> {
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
