import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dhikr.dart';
import '../providers/dhikr_provider.dart';
import '../screens/counter_screen.dart';
import 'edit_dhikr_modal.dart';

class DhikrListItem extends StatelessWidget {
  final Dhikr dhikr;
  final bool isArchived;

  const DhikrListItem({
    super.key,
    required this.dhikr,
    this.isArchived = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(dhikr.id),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Archive/Unarchive
          final provider = context.read<DhikrProvider>();
          if (isArchived) {
            await provider.unarchiveDhikr(dhikr);
          } else {
            await provider.archiveDhikr(dhikr);
          }
          return false;
        } else {
          // Delete
          return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Zikiri Sil'),
              content: const Text('Bu zikiri silmek istediğinizden emin misiniz?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('İptal'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Sil'),
                ),
              ],
            ),
          );
        }
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          context.read<DhikrProvider>().deleteDhikr(dhikr);
        }
      },
      background: Container(
        color: isArchived ? Colors.green : Colors.orange,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Icon(
          isArchived ? Icons.unarchive : Icons.archive,
          color: Colors.white,
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: InkWell(
          onTap: isArchived ? null : () => _openCounter(context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.drag_handle, color: Colors.grey),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dhikr.arabicText,
                        style: const TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dhikr.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        dhikr.meaning,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (dhikr.target != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'Hedef: ${dhikr.target}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (!isArchived) ...[
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () => _showEditModal(context),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openCounter(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CounterScreen(dhikr: dhikr),
      ),
    );
  }

  void _showEditModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => EditDhikrModal(dhikr: dhikr),
    );
  }
}