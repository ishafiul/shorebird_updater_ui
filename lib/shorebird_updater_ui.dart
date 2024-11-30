
import 'package:flutter/material.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';


class ShorebirdUpdaterWrapper extends StatefulWidget {
  final Widget child;

  const ShorebirdUpdaterWrapper({Key? key, required this.child}) : super(key: key);

  @override
  _ShorebirdUpdaterWrapperState createState() => _ShorebirdUpdaterWrapperState();
}

class _ShorebirdUpdaterWrapperState extends State<ShorebirdUpdaterWrapper> {
  final _updater = ShorebirdUpdater();
  bool _isUpdaterAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkForUpdate();
  }

  Future<void> _checkForUpdate() async {
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      _isUpdaterAvailable = _updater.isAvailable;
    });
    if (_isUpdaterAvailable) {
      final status = await _updater.checkForUpdate();
      if (status == UpdateStatus.outdated) {
        _showUpdateAvailableBanner();
      }
    }
  }

  void _showUpdateAvailableBanner() {
    if(!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentMaterialBanner()
      ..showMaterialBanner(
        MaterialBanner(
          content: Text('Update available for the'),
          actions: [
            TextButton(
              onPressed: () async {
                await _updater.update();
                // Optionally show restart banner after download.
              },
              child: const Text('Download'),
            ),
          ],
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
