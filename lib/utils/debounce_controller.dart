// lib/utils/debounce_controller.dart
import 'dart:async';
import 'package:flutter/foundation.dart';

class DebounceController {
  Timer? _timer;

  void run(Duration delay, VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}