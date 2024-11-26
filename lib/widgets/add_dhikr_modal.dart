import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dhikr.dart';
import '../providers/dhikr_provider.dart';

class AddDhikrModal extends StatefulWidget {
  const AddDhikrModal({super.key});

  @override
  State<AddDhikrModal> createState() => _AddDhikrModalState();
}

class _AddDhikrModalState extends State<AddDhikrModal> {
  final _titleController = TextEditingController();
  final _arabicController = TextEditingController();
  final _meaningController = TextEditingController();
  final _targetController = TextEditingController(text: '33');
  final _vibrateThresholdController = TextEditingController(text: '3');
  final _vibrateIntervalController = TextEditingController(text: '10');
  bool _countUp = true;
  bool _vibrateNearEnd = true;
  bool _vibrateOnInterval = false;
  bool _soundOnComplete = true;
  String _resetPeriod = 'daily';

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
    if (_titleController.text.isEmpty) return;

    final provider = context.read<DhikrProvider>();
    final newDhikr = Dhikr(
      id: DateTime.now().millisecondsSinceEpoch,
      title: _titleController.text,
      arabicText: _arabicController.text.isEmpty 
        ? _titleController.text 
        : _arabicController.text,
      meaning: _meaningController.text.isEmpty 
        ? _titleController.text 
        : _meaningController.text,
      target: int.tryParse(_targetController.text) ?? 33,
      countUp: _countUp,
      vibrateNearEnd: _vibrateNearEnd,
      vibrateThreshold: int.tryParse(_vibrateThresholdController.text) ?? 3,
      vibrateOnInterval: _vibrateOnInterval,
      vibrateInterval: int.tryParse(_vibrateIntervalController.text) ?? 10,
      soundOnComplete: _soundOnComplete,
      resetPeriod: _resetPeriod,
    );
    provider.addDhikr(newDhikr);
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
            'Yeni Zikir Ekle',
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
              labelText: 'Arapça Metin (İsteğe bağlı)',
              border: OutlineInputBorder(),
            ),
            textDirection: TextDirection.rtl,
            style: const TextStyle(fontFamily: 'Amiri'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _meaningController,
            decoration: const InputDecoration(
              labelText: 'Anlamı (İsteğe bağlı)',
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
                  ButtonSegment( <boltAction type="file" filePath="lib/widgets/add_dhikr_modal.dart">                    value: 'weekly',
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
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }
}