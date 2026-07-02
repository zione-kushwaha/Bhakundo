import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HostChallengeSheet extends StatefulWidget {
  final void Function(String teamName, String venue, DateTime date, String time) onSubmit;

  const HostChallengeSheet({
    super.key,
    required this.onSubmit,
  });

  @override
  State<HostChallengeSheet> createState() => _HostChallengeSheetState();
}

class _HostChallengeSheetState extends State<HostChallengeSheet> {
  final _teamNameController = TextEditingController();
  final _venueController = TextEditingController();
  final _timeController = TextEditingController();
  DateTime _matchDate = DateTime.now();

  @override
  void dispose() {
    _teamNameController.dispose();
    _venueController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 24,
        left: 24,
        right: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'HOST OPEN CHALLENGE',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Post a match slot to invite opponents',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          
          // Form Fields
          TextField(
            controller: _teamNameController,
            decoration: const InputDecoration(
              hintText: 'Your Team Name',
              prefixIcon: Icon(Icons.shield_outlined),
            ),
          ),
          const SizedBox(height: 16),
          
          TextField(
            controller: _venueController,
            decoration: const InputDecoration(
              hintText: 'Futsal Venue (e.g. Camp Nou)',
              prefixIcon: Icon(Icons.location_on_outlined),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _matchDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 30)),
                    );
                    if (picked != null) {
                      setState(() {
                        _matchDate = picked;
                      });
                    }
                  },
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: Text(DateFormat('d MMM yyyy').format(_matchDate)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _timeController,
                  decoration: const InputDecoration(
                    hintText: 'Time (e.g. 7-8 PM)',
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.secondary,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () {
              if (_teamNameController.text.trim().isEmpty ||
                  _venueController.text.trim().isEmpty ||
                  _timeController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields')),
                );
                return;
              }

              widget.onSubmit(
                _teamNameController.text.trim(),
                _venueController.text.trim(),
                _matchDate,
                _timeController.text.trim(),
              );
            },
            child: const Text(
              'POST TO WAITING POOL',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
