import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'shorebird_updater_ui_method_channel.dart';

abstract class ShorebirdUpdaterUiPlatform extends PlatformInterface {
  /// Constructs a ShorebirdUpdaterUiPlatform.
  ShorebirdUpdaterUiPlatform() : super(token: _token);

  static final Object _token = Object();

  static ShorebirdUpdaterUiPlatform _instance = MethodChannelShorebirdUpdaterUi();

  /// The default instance of [ShorebirdUpdaterUiPlatform] to use.
  ///
  /// Defaults to [MethodChannelShorebirdUpdaterUi].
  static ShorebirdUpdaterUiPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ShorebirdUpdaterUiPlatform] when
  /// they register themselves.
  static set instance(ShorebirdUpdaterUiPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Restarts the app by invoking the platform-specific implementation.
  Future<void> restartApp() {
    throw UnimplementedError('restartApp() has not been implemented.');
  }
}
