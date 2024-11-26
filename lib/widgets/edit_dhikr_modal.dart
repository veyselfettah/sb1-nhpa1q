import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dhikr.dart';
import '../providers/dhikr_provider.dart';

class EditDhikrModal extends StatefulWidget {
  final Dhikr dhikr;

  const EditDhikrModal({
    super.key,
    required this.dhikr,
  });

  @override
  State<EditDhikrModal> createState() => _EditDhikrModalState();
}

class _EditDhikrModalState extends State<EditDhikrModal> {
  late TextEditingController _titleController;
  late TextEditingController _arabicController;
  late TextEditingController _meaningController;
  late TextEditingController _targetController;
  late TextEditingController _vibrateThresholdController;
  late TextEditingController _vibrateIntervalController;
  late bool _countUp;
  late bool _vibrateNearEnd;
  late bool _vibrateOnInterval;
  late bool _soundOnComplete;
  late String _resetPeriod;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.dhikr.title);
    _arabicController = TextEditingController(text: widget.dhikr.arabicText);
    _meaningController = TextEditingController(text: widget.dhikr.meaning);
    _targetController = TextEditingController(text: widget.dhikr.target.toString());
    _vibrateThresholdController = TextEditingController(text: widget.dhikr.vibrateThreshold.toString());
    _vibrateIntervalController = TextEditingController(text: widget.dhikr.vibrateInterval.toString());
    _countUp = widget.dhikr.countUp;
    _vibrateNearEnd = widget.dhikr.vibrateNearEnd;
    _vibrateOnInterval = widget.dhikr.vibrateOnInterval;
    _soundOnComplete = widget.dhikr.soundOnComplete;
    _resetPeriod = widget.dhikr.resetPeriod;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _arabicController.dispose();
    _meaningController.dispose();
    _targetController.dispose();
    _vibrateThresholdController.dispose();
    _vibrateIntervalController.dispose();
    super.dispose();
  }

  void _save() {
    final provider = context.read<DhikrProvider>();
    final updatedDhikr = widget.dhikr.copyWith(
      title: _titleController.text,
      arabicText: _arabicController.text,
      meaning: _meaningController.text,
      target: int.tryParse(_targetController.text) ?? widget.dhikr.target,
      countUp: _countUp,
      vibrateNearEnd: _vibrateNearEnd,
      vibrateThreshold: int.tryParse(_vibrateThresholdController.text) ?? widget.dhikr.vibrateThreshold,
      vibrateOnInterval: _vibrateOnInterval,
      vibrateInterval: int.tryParse(_vibrateIntervalController.text) ?? widget.dhikr.vibrateInterval,
      soundOnComplete: _soundOnComplete,
      resetPeriod: _resetPeriod,
    );
    provider.updateDhikr(updatedDhikr);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Zikir Düzenle',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Başlık',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _arabicController,
            decoration: const InputDecoration(
              labelText: 'Arapça Metin',
              border: OutlineInputBorder(),
            ),
            textDirection: TextDirection.rtl,
            style: const TextStyle(fontFamily: 'Amiri'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _meaningController,
            decoration: const InputDecoration(
              labelText: 'Anlamı',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _targetController,
                  decoration: const InputDecoration(
                    labelText: 'Hedef',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(
                    value: true,
                    label: Text('Artan'),
                    icon: Icon(Icons.arrow_upward),
                  ),
                  ButtonSegment(
                    value: false,
                    label: Text('Azalan'),
                    icon: Icon(Icons.arrow_downward),
                  ),
                ],
                selected: {_countUp},
                onSelectionChanged: (Set<bool> newSelection) {
                  setState(() {
                    _countUp = newSelection.first;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Titreşim Ayarları',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('Bitişe Yakın Titret'),
                    value: _vibrateNearEnd,
                    onChanged: (value) => setState(() => _vibrateNearEnd = value),
                  ),
                  if (_vibrateNearEnd)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: TextField(
                        controller: _vibrateThresholdController,
                        decoration: const InputDecoration(
                          labelText: 'Son kaç sayıda titretilsin?',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  SwitchListTile(
                    title: const Text('Belirli Aralıklarla Titret'),
                    value: _vibrateOnInterval,
                    onChanged: (value) => setState(() => _vibrateOnInterval = value),
                  ),
                  if (_vibrateOnInterval)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: TextField(
                        controller: _vibrateIntervalController,
                        decoration: const InputDecoration(
                          labelText: 'Kaç sayıda bir titretilsin?',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Bitişte Ses Çal'),
            value: _soundOnComplete,
            onChanged: (value) => setState(() => _soundOnComplete = value),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Sıfırlama:'),
              const SizedBox(width: 16),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'daily',
                    label: Text('Günlük'),
                  ),
                  ButtonSegment(
                    value: 'weekly',
                    label: Text('Haftalık'),
                  ),
                ],
                selected: {_resetPeriod},
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() {
                    _resetPeriod = newSelection.first;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _save,
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }
}