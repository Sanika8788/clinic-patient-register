import 'package:flutter/material.dart';

import '../models/patient.dart';

/// Add / edit form with validation. Pops with the saved [Patient].
class PatientForm extends StatefulWidget {
  const PatientForm({super.key, this.patient});
  final Patient? patient;

  @override
  State<PatientForm> createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm> {
  final _key = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.patient?.name);
  late final _age =
      TextEditingController(text: widget.patient?.age.toString() ?? '');
  late final _phone = TextEditingController(text: widget.patient?.phone);
  late final _notes = TextEditingController(text: widget.patient?.notes);
  late String _gender = widget.patient?.gender ?? 'Female';

  @override
  void dispose() {
    _name.dispose();
    _age.dispose();
    _phone.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _save() {
    if (!_key.currentState!.validate()) return;
    final base = widget.patient;
    Navigator.pop(
      context,
      Patient(
        id: base?.id,
        name: _name.text.trim(),
        age: int.parse(_age.text),
        gender: _gender,
        phone: _phone.text.trim(),
        notes: _notes.text.trim(),
        createdAt: base?.createdAt ?? DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.patient == null ? 'New patient' : 'Edit patient'),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Full name'),
              validator: (v) =>
                  (v == null || v.trim().length < 2) ? 'Enter a name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _age,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Age'),
              validator: (v) {
                final n = int.tryParse(v ?? '');
                return (n == null || n < 0 || n > 120) ? 'Enter a valid age' : null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _gender,
              decoration: const InputDecoration(labelText: 'Gender'),
              items: const ['Female', 'Male', 'Other']
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (v) => setState(() => _gender = v!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone'),
              validator: (v) => RegExp(r'^\d{10}$').hasMatch(v ?? '')
                  ? null
                  : 'Enter a 10-digit number',
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notes,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Notes (optional)'),
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _save, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
