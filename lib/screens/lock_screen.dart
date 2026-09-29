import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

/// Gates the app behind biometric / device credentials.
/// On web (preview only) there is no biometric hardware, so it unlocks directly.
class LockScreen extends StatefulWidget {
  const LockScreen({super.key, required this.child});
  final Widget child;

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final _auth = LocalAuthentication();
  bool _unlocked = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _unlock();
  }

  Future<void> _unlock() async {
    if (kIsWeb) {
      setState(() => _unlocked = true);
      return;
    }
    try {
      final supported = await _auth.isDeviceSupported();
      if (!supported) {
        setState(() => _unlocked = true);
        return;
      }
      final ok = await _auth.authenticate(
        localizedReason: 'Unlock the patient register',
      );
      setState(() {
        _unlocked = ok;
        _error = ok ? null : 'Authentication failed';
      });
    } catch (e) {
      setState(() => _error = 'Could not authenticate');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_unlocked) return widget.child;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline, size: 64),
            const SizedBox(height: 16),
            const Text('Patient register is locked'),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ],
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _unlock,
              icon: const Icon(Icons.fingerprint),
              label: const Text('Unlock'),
            ),
          ],
        ),
      ),
    );
  }
}
