import 'dart:async';

const Duration debounceDuration = Duration(milliseconds: 500);

typedef Debounceable<S, T> = Future<S> Function(T parameter);

Debounceable<S?, T> debounce<S, T>(Debounceable<S?, T> function) {
  DebounceTimer? debounceTimer;

  return (T parameter) async {
    if (debounceTimer != null && !debounceTimer!.isCompleted) {
      debounceTimer!.cancel();
    }
    debounceTimer = DebounceTimer();
    try {
      await debounceTimer!.future;
    } on CancelException {
      return null;
    }
    return await function(parameter);
  };
}

// A wrapper around Timer used for debouncing.
class DebounceTimer {
  DebounceTimer() {
    _timer = Timer(debounceDuration, _onComplete);
  }

  late final Timer _timer;
  final Completer<void> _completer = Completer<void>();

  void _onComplete() {
    _completer.complete();
  }

  Future<void> get future => _completer.future;

  bool get isCompleted => _completer.isCompleted;

  void cancel() {
    _timer.cancel();
    _completer.completeError(const CancelException());
  }
}

class CancelException implements Exception {
  const CancelException();
}
