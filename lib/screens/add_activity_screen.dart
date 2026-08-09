import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/activity_model.dart';
import '../providers/activity_provider.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({super.key});

  @override
  State<AddActivityScreen> createState() =>
      _AddActivityScreenState();
}

class _AddActivityScreenState
    extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _activityController =
      TextEditingController();

  TimeOfDay _selectedTime = TimeOfDay.now();

  String _selectedMood = '😊';

  final List<String> _moods = [
    '😊',
    '😄',
    '😐',
    '😔',
    '😡',
  ];

  @override
  void dispose() {
    _activityController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final result = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (result != null) {
      setState(() {
        _selectedTime = result;
      });
    }
  }

  Future<void> _saveActivity() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final now = DateTime.now();

    final selectedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final activity = ActivityModel(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),
      activityName:
          _activityController.text.trim(),
      time: selectedDateTime,
      mood: _selectedMood,
      date: DateTime(
        now.year,
        now.month,
        now.day,
      ),
    );

    await context
        .read<ActivityProvider>()
        .addActivity(activity);

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Catatan'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                'Nama Aktivitas',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: _activityController,
                decoration: const InputDecoration(
                  hintText: 'Contoh: Belajar Flutter',
                  prefixIcon: Icon(Icons.edit_note),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Nama aktivitas wajib diisi';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              const Text(
                'Waktu',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                  side: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .outlineVariant,
                  ),
                ),
                leading:
                    const Icon(Icons.access_time),
                title: Text(
                  _selectedTime.format(context),
                ),
                trailing:
                    const Icon(Icons.chevron_right),
                onTap: _pickTime,
              ),

              const SizedBox(height: 24),

              const Text(
                'Mood Kamu',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _moods.map((mood) {
                  final isSelected =
                      mood == _selectedMood;

                  return ChoiceChip(
                    selected: isSelected,
                    label: Text(
                      mood,
                      style:
                          const TextStyle(fontSize: 24),
                    ),
                    onSelected: (_) {
                      setState(() {
                        _selectedMood = mood;
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: _saveActivity,
                  icon: const Icon(Icons.save),
                  label:
                      const Text('Simpan Catatan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}