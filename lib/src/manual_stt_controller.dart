import 'package:flutter/material.dart';

import 'manual_stt_service.dart';

/// Listening states for Manual-speech-to-text
enum ManualSttState { listening, paused, stopped }

class ManualSttController {
  late final ManualSttService _sttService;
  final BuildContext context;
  void Function(ManualSttState)? _onListeningStateChanged;
  void Function(String)? _onListeningTextChanged;
  void Function(double)? _onSoundLevelChanged;
  String _finalText = '';

  /// Constructor to initialize the service and set up callbacks
  ManualSttController(this.context) {
    _initializeService();
  }

  /// initialize the service
  void _initializeService() {
    _sttService = ManualSttService(
      context,
      onTextChanged: (liveText, finalText) {
        _finalText += finalText;
        _onListeningTextChanged?.call(_finalText + liveText);
      },
      onSoundLevelChanged: (level) => _onSoundLevelChanged?.call(level),
      onStateChanged: (state) => _onListeningStateChanged?.call(state),
    );
  }

  /// Listen method to set up callbacks and start listening
  void listen({
    required void Function(ManualSttState)? onListeningStateChanged,
    required void Function(String)? onListeningTextChanged,
    void Function(double)? onSoundLevelChanged,
  }) {
    _onListeningStateChanged = onListeningStateChanged;
    _onListeningTextChanged = onListeningTextChanged;
    _onSoundLevelChanged = onSoundLevelChanged;
  }

  /// handle permanently denied microphone permission
  void handlePermanentlyDeniedPermission(VoidCallback callBack) =>
      _sttService.permanentlyDeniedCallback = callBack;

  // Control methods
  void stopStt() {
    _finalText = '';
    _sttService.stopRecording();
  }

  void startStt() => _sttService.startRecording();
  void pauseStt() => _sttService.pauseRecording();
  void resumeStt() => _sttService.resumeRecording();
  void dispose() => _sttService.dispose();

  /// Enable/disable haptic feedback
  set enableHapticFeedback(bool enable) =>
      _sttService.enableHapticFeedback = enable;

  /// [localeId] is an optional locale that can be used to listen in a language other than the current system default.
  /// See [locales] to find the list of supported languages for listening.
  set localId(String localId) => _sttService.localId = localId;

  set permanentDenialDialogTitle(String text) =>
      _sttService.permanentDenialDialogTitle = text;
  set permanentDenialDialogContent(String text) =>
      _sttService.permanentDenialDialogContent = text;
}
