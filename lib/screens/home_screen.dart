import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dhikr_provider.dart';
import '../widgets/dhikr_list_item.dart';
import '../widgets/add_dhikr_modal.dart';
import '../models/dhikr.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showArchived = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dijital Zikirmatik',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.archive,
              color: _showArchived ? Theme.of(context).colorScheme.primary : null,
            ),
            onPressed: () => setState(() => _showArchived = !_showArchived),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Zikir Ekle'),
            onPressed: () => _showAddDhikrModal(context),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Consumer<DhikrProvider>(
        builder: (context, provider, child) {
          final items = _showArchived ? provider.archivedDhikrs : provider.dhikrs;
          
          if (items.isEmpty) {
            return Center(
              child: Text(
                _showArchived ? 'Arşivlenmiş zikir bulunmuyor' : 'Zikir listesi boş',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            );
          }

          return ReorderableListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            onReorder: (oldIndex, newIndex) {
              if (!_showArchived) {
                provider.reorderDhikrs(oldIndex, newIndex);
              }
            },
            itemBuilder: (context, index) {
              final dhikr = items[index];
              return DhikrListItem(
                key: ValueKey(dhikr.id),
                dhikr: dhikr,
                isArchived: _showArchived,
              );
            },
          );
        },
      ),
    );
  }

  void _showAddDhikrModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const AddDhikrModal(),
    );
  }
}