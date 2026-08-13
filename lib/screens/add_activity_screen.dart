import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/activity_model.dart';
import '../providers/activity_provider.dart';
import '../widgets/theme_toggle_button.dart';

const _purple = Color(0xFF5B4DFB);
const _neon = Color(0xFFCCFF00);

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({super.key});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _activityController = TextEditingController();

  // Otomatis mengambil jam dan menit saat ini dari HP
  TimeOfDay _selectedTime = TimeOfDay.now();

  String _selectedMood = '😄';

  @override
  void dispose() {
    _activityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.colorScheme.onSurface;
    final surface = theme.colorScheme.surface;
    final outline = theme.colorScheme.outline.withOpacity(.22);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,

        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_rounded,
            color: text,
          ),
        ),

        title: Text(
          'Tambah Catatan',
          style: TextStyle(
            color: text,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),

        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: ThemeToggleButton(size: 38),
          ),
        ],
      ),

      body: Form(
        key: _formKey,

        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            24,
          ),

          children: [
            Text(
              'Apa yang\nkamu lakukan?',
              style: TextStyle(
                color: text,
                fontSize: 32,
                height: 1.08,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
            ),

            const SizedBox(height: 26),

            const _FieldLabel('Nama aktivitas'),

            const SizedBox(height: 8),

            TextFormField(
              controller: _activityController,
              textInputAction: TextInputAction.done,

              decoration: _inputDecoration(
                hint: 'Contoh: Belajar Flutter',
                icon: Icons.menu_book_outlined,
              ),

              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama aktivitas wajib diisi';
                }

                return null;
              },
            ),

            const SizedBox(height: 18),

            const _FieldLabel('Waktu'),

            const SizedBox(height: 8),

            InkWell(
              borderRadius: BorderRadius.circular(17),

              onTap: _pickTime,

              child: Container(
                height: 64,

                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                ),

                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(
                    color: outline,
                  ),
                ),

                child: Row(
                  children: [
                    _IconBox(
                      icon: Icons.schedule_rounded,
                      color: _purple,
                    ),

                    const SizedBox(width: 12),

                    Text(
                      _formatTime(_selectedTime),

                      style: TextStyle(
                        color: text,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const Spacer(),

                    Icon(
                      Icons.chevron_right_rounded,
                      color: text.withOpacity(.45),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Pilih mood-mu',

              style: TextStyle(
                color: text,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 116,

              child: Row(
                children: moodInfos.map((info) {
                  final selected =
                      info.emoji == _selectedMood;

                  final color =
                      Color(info.color.value);

                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right:
                            info == moodInfos.last ? 0 : 6,
                      ),

                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedMood = info.emoji;
                          });
                        },

                        child: AnimatedContainer(
                          duration:
                              const Duration(milliseconds: 150),

                          decoration: BoxDecoration(
                            color: selected
                                ? color.withOpacity(.28)
                                : surface,

                            borderRadius:
                                BorderRadius.circular(16),

                            border: Border.all(
                              color: selected
                                  ? text
                                  : outline,

                              width: selected ? 2 : 1,
                            ),
                          ),

                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,

                            children: [
                              Text(
                                info.emoji,

                                style:
                                    const TextStyle(
                                  fontSize: 27,
                                ),
                              ),

                              const SizedBox(height: 7),

                              Text(
                                info.label,

                                style: TextStyle(
                                  color: text,
                                  fontSize: 9.5,

                                  fontWeight: selected
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: _neon.withOpacity(.22),
                borderRadius: BorderRadius.circular(16),
              ),

              child: Row(
                children: [
                  const Text(
                    '💡',
                    style: TextStyle(fontSize: 20),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      'Catat kegiatan sesuai waktu sebenarnya agar riwayat harianmu lebih rapi.',

                      style: TextStyle(
                        color: text.withOpacity(.70),
                        fontSize: 11,
                        height: 1.35,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(
          20,
          8,
          20,
          14,
        ),

        child: SizedBox(
          height: 54,

          child: FilledButton(
            onPressed: _saveActivity,

            style: FilledButton.styleFrom(
              backgroundColor: _purple,
              foregroundColor: Colors.white,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17),
              ),

              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),

            child: const Text(
              'Simpan Catatan',
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // FORMAT WAKTU 24 JAM
  // ============================================================

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');

    final minute =
        time.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  // ============================================================
  // INPUT DECORATION
  // ============================================================

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    final theme = Theme.of(context);

    final text =
        theme.colorScheme.onSurface;

    final outline =
        theme.colorScheme.outline.withOpacity(.22);

    return InputDecoration(
      hintText: hint,

      hintStyle: TextStyle(
        color: text.withOpacity(.48),
        fontSize: 13,
      ),

      prefixIcon: Padding(
        padding: const EdgeInsets.all(10),

        child: _IconBox(
          icon: icon,
          color: _purple,
        ),
      ),

      filled: true,

      fillColor:
          theme.colorScheme.surface,

      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 18,
      ),

      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(17),

        borderSide:
            BorderSide(color: outline),
      ),

      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(17),

        borderSide:
            BorderSide(color: outline),
      ),

      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(17),

        borderSide:
            const BorderSide(
          color: _purple,
          width: 1.5,
        ),
      ),

      errorBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(17),

        borderSide:
            const BorderSide(
          color: Color(0xFFFF7676),
        ),
      ),

      focusedErrorBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(17),

        borderSide:
            const BorderSide(
          color: Color(0xFFFF7676),
        ),
      ),
    );
  }

  // ============================================================
  // PILIH WAKTU
  // ============================================================

  Future<void> _pickTime() async {
    final result =
        await showModalBottomSheet<TimeOfDay>(
      context: context,

      isScrollControlled: true,

      backgroundColor:
          Colors.transparent,

      builder: (context) {
        return _WheelTimePicker(
          initialTime: _selectedTime,
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedTime = result;
      });
    }
  }

  // ============================================================
  // SAVE ACTIVITY
  // ============================================================

  Future<void> _saveActivity() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final now = DateTime.now();

    final activity = ActivityModel(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),

      activityName:
          _activityController.text.trim(),

      time: DateTime(
        now.year,
        now.month,
        now.day,
        _selectedTime.hour,
        _selectedTime.minute,
      ),

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

    if (mounted) {
      Navigator.pop(context);
    }
  }
}

// ================================================================
// FIELD LABEL
// ================================================================

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,

      style: TextStyle(
        color: Theme.of(context)
            .colorScheme
            .onSurface,

        fontSize: 13,

        fontWeight: FontWeight.w700,
      ),
    );
  }
}

// ================================================================
// ICON BOX
// ================================================================

class _IconBox extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _IconBox({
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,

      decoration: BoxDecoration(
        color: color.withOpacity(.11),
        borderRadius:
            BorderRadius.circular(12),
      ),

      alignment: Alignment.center,

      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }
}

// ================================================================
// WHEEL TIME PICKER
// ================================================================

class _WheelTimePicker extends StatefulWidget {
  final TimeOfDay initialTime;

  const _WheelTimePicker({
    required this.initialTime,
  });

  @override
  State<_WheelTimePicker> createState() =>
      _WheelTimePickerState();
}

class _WheelTimePickerState
    extends State<_WheelTimePicker> {

  late int selectedHour;
  late int selectedMinute;

  late FixedExtentScrollController
      hourController;

  late FixedExtentScrollController
      minuteController;

  // Jam 00 - 23
  final List<int> hours =
      List.generate(24, (index) => index);

  // Menit 00 - 59
  final List<int> minutes =
      List.generate(60, (index) => index);

  @override
  void initState() {
    super.initState();

    // Mengikuti waktu HP saat ini
    selectedHour =
        widget.initialTime.hour;

    selectedMinute =
        widget.initialTime.minute;

    hourController =
        FixedExtentScrollController(
      initialItem: selectedHour,
    );

    minuteController =
        FixedExtentScrollController(
      initialItem: selectedMinute,
    );
  }

  @override
  void dispose() {
    hourController.dispose();
    minuteController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final text =
        theme.colorScheme.onSurface;

    final surface =
        theme.colorScheme.surface;

    return Container(
      decoration: BoxDecoration(
        color: surface,

        borderRadius:
            const BorderRadius.vertical(
          top: Radius.circular(32),
        ),
      ),

      padding:
          const EdgeInsets.fromLTRB(
        24,
        12,
        24,
        24,
      ),

      child: SafeArea(
        top: false,

        child: Column(
          mainAxisSize:
              MainAxisSize.min,

          children: [
            // ==================================================
            // HANDLE
            // ==================================================

            Container(
              width: 48,
              height: 5,

              decoration:
                  BoxDecoration(
                color:
                    text.withOpacity(.18),

                borderRadius:
                    BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 24),

            // ==================================================
            // TITLE
            // ==================================================

            Align(
              alignment:
                  Alignment.centerLeft,

              child: Text(
                'Pilih waktu',

                style: TextStyle(
                  color: text,
                  fontSize: 24,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),
            ),

            const SizedBox(height: 18),

            // ==================================================
            // PREVIEW
            // ==================================================

            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 14,
              ),

              decoration:
                  BoxDecoration(
                color:
                    _purple.withOpacity(.10),

                borderRadius:
                    BorderRadius.circular(18),
              ),

              child: Text(
                _formattedSelectedTime(),

                style:
                    const TextStyle(
                  color: _purple,
                  fontSize: 30,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ==================================================
            // WHEEL
            // ==================================================

            SizedBox(
              height: 210,

              child: Row(
                children: [
                  // ==========================================
                  // JAM
                  // ==========================================

                  Expanded(
                    child: _TimeWheel(
                      controller:
                          hourController,

                      itemCount:
                          hours.length,

                      selectedIndex:
                          selectedHour,

                      itemBuilder:
                          (index) {
                        return hours[index]
                            .toString()
                            .padLeft(2, '0');
                      },

                      onChanged:
                          (index) {
                        setState(() {
                          selectedHour =
                              hours[index];
                        });
                      },
                    ),
                  ),

                  // ==========================================
                  // :
                  // ==========================================

                  Padding(
                    padding:
                        const EdgeInsets.only(
                      top: 42,
                    ),

                    child: Text(
                      ':',

                      style: TextStyle(
                        color: text,
                        fontSize: 28,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                  ),

                  // ==========================================
                  // MENIT
                  // ==========================================

                  Expanded(
                    child: _TimeWheel(
                      controller:
                          minuteController,

                      itemCount:
                          minutes.length,

                      selectedIndex:
                          selectedMinute,

                      itemBuilder:
                          (index) {
                        return minutes[index]
                            .toString()
                            .padLeft(2, '0');
                      },

                      onChanged:
                          (index) {
                        setState(() {
                          selectedMinute =
                              minutes[index];
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ==================================================
            // BUTTON
            // ==================================================

            SizedBox(
              width: double.infinity,
              height: 54,

              child: FilledButton(
                onPressed:
                    _confirmTime,

                style:
                    FilledButton.styleFrom(
                  backgroundColor:
                      _purple,

                  foregroundColor:
                      Colors.white,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      17,
                    ),
                  ),

                  textStyle:
                      const TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                child: const Text(
                  'Pilih Waktu',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // FORMAT PREVIEW
  // ============================================================

  String _formattedSelectedTime() {
    final hour =
        selectedHour
            .toString()
            .padLeft(2, '0');

    final minute =
        selectedMinute
            .toString()
            .padLeft(2, '0');

    return '$hour:$minute';
  }

  // ============================================================
  // CONFIRM TIME
  // ============================================================

  void _confirmTime() {
    Navigator.pop(
      context,

      TimeOfDay(
        hour: selectedHour,
        minute: selectedMinute,
      ),
    );
  }
}

// ================================================================
// TIME WHEEL
// ================================================================

class _TimeWheel extends StatelessWidget {
  final FixedExtentScrollController
      controller;

  final int itemCount;

  final int selectedIndex;

  final String Function(int index)
      itemBuilder;

  final ValueChanged<int> onChanged;

  const _TimeWheel({
    required this.controller,
    required this.itemCount,
    required this.selectedIndex,
    required this.itemBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final text =
        theme.colorScheme.onSurface;

    return ListWheelScrollView.useDelegate(
      controller: controller,

      itemExtent: 48,

      perspective: 0.002,

      diameterRatio: 1.5,

      physics:
          const FixedExtentScrollPhysics(),

      onSelectedItemChanged:
          onChanged,

      childDelegate:
          ListWheelChildBuilderDelegate(
        childCount: itemCount,

        builder:
            (context, index) {
          final selected =
              index == selectedIndex;

          return Center(
            child:
                AnimatedDefaultTextStyle(
              duration:
                  const Duration(
                milliseconds: 120,
              ),

              style: TextStyle(
                color: selected
                    ? _purple
                    : text.withOpacity(.35),

                fontSize:
                    selected ? 26 : 19,

                fontWeight: selected
                    ? FontWeight.w900
                    : FontWeight.w500,
              ),

              child: Text(
                itemBuilder(index),
              ),
            ),
          );
        },
      ),
    );
  }
}