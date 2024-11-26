import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/dhikr.dart';

class CounterScreen extends StatefulWidget {
  final Dhikr dhikr;
  final VoidCallback? onNext;

  const CounterScreen({
    super.key,
    required this.dhikr,
    this.onNext,
  });

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  late int _count;
  bool _isComplete = false;
  final _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _count = widget.dhikr.currentCount;
    _loadAudio();
  }

  Future<void> _loadAudio() async {
    await _audioPlayer.setSource(AssetSource('sounds/complete.mp3'));
    await _audioPlayer.setVolume(1.0);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _increment() {
    if (_isComplete) return;

    setState(() {
      if (widget.dhikr.countUp) {
        _count++;
      } else {
        _count--;
      }

      // Titreşim kontrolü
      if (widget.dhikr.vibrateNearEnd) {
        final remaining = widget.dhikr.countUp
          ? widget.dhikr.target - _count
          : _count;
        
        if (remaining <= widget.dhikr.vibrateThreshold) {
          Vibrate.feedback(FeedbackType.medium);
        }
      }

      // Aralıklı titreşim kontrolü
      if (widget.dhikr.vibrateOnInterval) {
        if (_count % widget.dhikr.vibrateInterval == 0) {
          Vibrate.feedback(FeedbackType.light);
        }
      }

      final isComplete = widget.dhikr.countUp
        ? _count >= widget.dhikr.target
        : _count <= 0;

      if (isComplete && !_isComplete) {
        _isComplete = true;
        _onComplete();
      }
    });
  }

  Future<void> _onComplete() async {
    if (widget.dhikr.soundOnComplete) {
      await _audioPlayer.resume();
    }
    if (widget.dhikr.vibrateNearEnd) {
      Vibrate.feedback(FeedbackType.success);
    }
  }

  void _reset() {
    setState(() {
      _count = widget.dhikr.startValue;
      _isComplete = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.dhikr.countUp
      ? _count / widget.dhikr.target
      : _count / widget.dhikr.target;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GestureDetector(
        onTap: _increment,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.dhikr.arabicText,
                    style: const TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 48,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 12,
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .surfaceVariant,
                        ),
                      ),
                      Text(
                        _count.toString(),
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_isComplete)
              Container(
                color: Colors.black54,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: const Text('Tekrar Et'),
                        onPressed: _reset,
                      ),
                      const SizedBox(height: 16),
                      if (widget.onNext != null)
                        FilledButton.icon(
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Sonraki Zikir'),
                          onPressed: widget.onNext,
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}