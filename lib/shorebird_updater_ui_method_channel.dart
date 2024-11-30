import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'shorebird_updater_ui_platform_interface.dart';

/// An implementation of [ShorebirdUpdaterUiPlatform] that uses method channels.
class MethodChannelShorebirdUpdaterUi extends ShorebirdUpdaterUiPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('shorebird_updater_ui');

  @override
  Future<void> restartApp() async {
    try {
      await methodChannel.invokeMethod('restartApp');
    } on PlatformException catch (e) {
      debugPrint('Failed to restart the app: ${e.message}');
      rethrow;
    }
  }
}
