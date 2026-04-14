import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/schedule_provider.dart';

class TaskInputScreen extends StatefulWidget {
  const TaskInputScreen({super.key});
  @override
  State<TaskInputScreen> createState() => _TaskInputScreenState();
}

class _TaskInputScreenState extends State<TaskInputScreen> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String _category = 'Class';
  final DateTime _date = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 1);
  double _urgency = 3;
  double _importance = 3;
  final double _effort = 1.0;
  String _energy = 'Medium';

  final List<String> _cats = ['Class', 'Org Work', 'Study', 'Rest', 'Other'];
  final List<String> _energies = ['Low', 'Medium', 'High'];

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(context: context, initialTime: isStart ? _startTime : _endTime);
    if (picked != null) setState(() => isStart ? _startTime = picked : _endTime = picked);
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Provider.of<ScheduleProvider>(context, listen: false).addTask(
        title: _title, category: _category, date: _date,
        startTime: _startTime, endTime: _endTime,
        urgency: _urgency.toInt(), importance: _importance.toInt(),
        estimatedEffortHours: _effort, energyLevel: _energy,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ADD TASK')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'TASK TITLE'),
                style: const TextStyle(fontWeight: FontWeight.w700),
                onSaved: (value) => _title = value!,
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'CATEGORY'),
                icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF1A1A1A)),
                items: _cats.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontWeight: FontWeight.w700)))).toList(),
                onChanged: (val) => setState(() => _category = val!),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF1A1A1A),
                          side: const BorderSide(color: Color(0xFF1A1A1A), width: 3.0),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () => _pickTime(true),
                        child: Text("START: ${_startTime.format(context)}", style: const TextStyle(fontWeight: FontWeight.w900)),
                      )
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF1A1A1A),
                          side: const BorderSide(color: Color(0xFF1A1A1A), width: 3.0),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () => _pickTime(false),
                        child: Text("END: ${_endTime.format(context)}", style: const TextStyle(fontWeight: FontWeight.w900)),
                      )
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  border: Border.all(color: const Color(0xFF1A1A1A), width: 3.0),
                  boxShadow: const [BoxShadow(color: Color(0xFF1A1A1A), offset: Offset(4, 4))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('URGENCY (1-5)', style: TextStyle(fontWeight: FontWeight.w900)),
                    Slider(
                        value: _urgency, min: 1, max: 5, divisions: 4,
                        activeColor: const Color(0xFF1A1A1A),
                        inactiveColor: const Color(0xFF1A1A1A).withOpacity(0.2),
                        onChanged: (val) => setState(() => _urgency = val)
                    ),
                    const Divider(color: Color(0xFF1A1A1A), thickness: 2.0),
                    const SizedBox(height: 8),
                    const Text('IMPORTANCE (1-5)', style: TextStyle(fontWeight: FontWeight.w900)),
                    Slider(
                        value: _importance, min: 1, max: 5, divisions: 4,
                        activeColor: const Color(0xFF1A1A1A),
                        inactiveColor: const Color(0xFF1A1A1A).withOpacity(0.2),
                        onChanged: (val) => setState(() => _importance = val)
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                initialValue: _energy,
                decoration: const InputDecoration(labelText: 'ENERGY LEVEL'),
                icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF1A1A1A)),
                items: _energies.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontWeight: FontWeight.w700)))).toList(),
                onChanged: (val) => setState(() => _energy = val!),
              ),
              const SizedBox(height: 48),
              Container(
                decoration: const BoxDecoration(
                  boxShadow: [BoxShadow(color: Color(0xFF1A1A1A), offset: Offset(4, 4))],
                ),
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('ADD TASK TO TIMELINE'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}