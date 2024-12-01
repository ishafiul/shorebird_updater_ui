import 'package:flutter/material.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'package:shorebird_updater_ui/shorebird_updater_ui_platform_interface.dart';

class ShorebirdUpdaterWrapper extends StatefulWidget {
  final Widget child;

  const ShorebirdUpdaterWrapper({super.key, required this.child});

  @override
  State<ShorebirdUpdaterWrapper> createState() =>
      _ShorebirdUpdaterWrapperState();
}

class _ShorebirdUpdaterWrapperState extends State<ShorebirdUpdaterWrapper> {
  bool _isUpdateAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkForUpdates();
  }

  Future<void> _checkForUpdates() async {
    final updater = ShorebirdUpdater();
    final updateStatus =
        await updater.checkForUpdate(track: UpdateTrack.stable);

    if (updateStatus == UpdateStatus.outdated) {
      setState(() {
        _isUpdateAvailable = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isUpdateAvailable) return widget.child;
    return const MaterialApp(
      home: Scaffold(body: UpdateScreen()),
    );
  }
}

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

enum UpdateDownloadState { downloading, completed, failed, idle }

class _UpdateScreenState extends State<UpdateScreen> {
  final ValueNotifier<UpdateDownloadState> _downloadStateNotifier =
      ValueNotifier(UpdateDownloadState.idle);
  final ValueNotifier<bool> _isRestartingNotifier = ValueNotifier(false);
  UpdateTrack _currentTrack = UpdateTrack.stable;

  @override
  void initState() {
    super.initState();
    _startUpdateProcess();
  }

  Future<void> _startUpdateProcess() async {
    final updater = ShorebirdUpdater();

    try {
      _downloadStateNotifier.value = UpdateDownloadState.downloading;
      await updater.update(track: _currentTrack);

      _downloadStateNotifier.value = UpdateDownloadState.completed;
      _isRestartingNotifier.value = true;

      // Wait briefly before restarting the app
      await Future.delayed(const Duration(seconds: 2));
      ShorebirdUpdaterUiPlatform.instance.restartApp();
    } on UpdateException catch (error) {
      _downloadStateNotifier.value = UpdateDownloadState.failed;
      _showErrorSnackBar(error.message);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Update failed: $message'),
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ValueListenableBuilder<UpdateDownloadState>(
        valueListenable: _downloadStateNotifier,
        builder: (context, downloadState, child) {
          if (downloadState == UpdateDownloadState.downloading) {
            return _buildDownloadingUI();
          } else if (downloadState == UpdateDownloadState.completed) {
            return const Text(
              'Update downloaded successfully! Restarting...',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            );
          } else if (downloadState == UpdateDownloadState.failed) {
            return _buildErrorUI();
          }
          return _buildIdleUI();
        },
      ),
    );
  }

  Widget _buildDownloadingUI() {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text(
          'Downloading update...',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildErrorUI() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Failed to download update. Please try again.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.red),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _startUpdateProcess,
          child: const Text('Retry Update'),
        ),
      ],
    );
  }

  Widget _buildIdleUI() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'An update is available.',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _startUpdateProcess,
          child: const Text('Start Update'),
        ),
      ],
    );
  }
}
