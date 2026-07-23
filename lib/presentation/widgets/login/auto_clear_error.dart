import 'dart:async';

import 'package:flutter/material.dart';

/// Shows an error string and clears it after [duration] (default 3s).
mixin AutoClearErrorMixin<T extends StatefulWidget> on State<T> {
  Timer? _errorClearTimer;
  String? authError;

  void showAuthError(String message) {
    _errorClearTimer?.cancel();
    setState(() => authError = message);
    _errorClearTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => authError = null);
    });
  }

  void clearAuthError() {
    _errorClearTimer?.cancel();
    if (authError != null) {
      setState(() => authError = null);
    }
  }

  @override
  void dispose() {
    _errorClearTimer?.cancel();
    super.dispose();
  }
}
