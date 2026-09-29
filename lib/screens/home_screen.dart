import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/patient_store.dart';
import '../models/patient.dart';
import '../services/pdf_export.dart';
import 'patient_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.store});
  final PatientStore store;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Patient> _patients = [];
  String _query = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await widget.store.all(query: _query);
    if (mounted) setState(() => _patients = list);
  }

  Future<void> _openForm([Patient? existing]) async {
    final result = await Navigator.push<Patient>(
      context,
      MaterialPageRoute(builder: (_) => PatientForm(patient: existing)),
    );
    if (result == null) return;
    if (existing == null) {
      await widget.store.add(result);
    } else {
      await widget.store.update(result);
    }
    _load();
  }

  Future<void> _delete(Patient p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Delete patient?'),
        content: Text('${p.name} will be removed from the register.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(c, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(c, true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (ok == true) {
      await widget.store.delete(p.id!);
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd MMM yyyy');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Register'),
        actions: [
          IconButton(
            tooltip: 'Export PDF',
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: _patients.isEmpty
                ? null
                : () => exportPatientsPdf(_patients),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: SearchBar(
              hintText: 'Search by name or phone',
              leading: const Icon(Icons.search),
              onChanged: (v) {
                _query = v;
                _load();
              },
            ),
          ),
          Expanded(
            child: _patients.isEmpty
                ? const Center(child: Text('No patients yet. Tap + to add.'))
                : ListView.separated(
                    itemCount: _patients.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final p = _patients[i];
                      return ListTile(
                        leading: CircleAvatar(child: Text(p.name[0])),
                        title: Text(p.name),
                        subtitle: Text(
                            '${p.age} yrs • ${p.gender} • ${p.phone}\n${fmt.format(p.createdAt)}'),
                        isThreeLine: true,
                        onTap: () => _openForm(p),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _delete(p),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Add patient'),
      ),
    );
  }
}
