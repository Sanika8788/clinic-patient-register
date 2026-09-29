class Patient {
  final int? id;
  final String name;
  final int age;
  final String gender;
  final String phone;
  final String notes;
  final DateTime createdAt;

  const Patient({
    this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.phone,
    this.notes = '',
    required this.createdAt,
  });

  Patient copyWith({
    int? id,
    String? name,
    int? age,
    String? gender,
    String? phone,
    String? notes,
  }) {
    return Patient(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
      notes: notes ?? this.notes,
      createdAt: createdAt,
    );
  }

  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'age': age,
        'gender': gender,
        'phone': phone,
        'notes': notes,
        'created_at': createdAt.millisecondsSinceEpoch,
      };

  factory Patient.fromMap(Map<String, Object?> m) => Patient(
        id: m['id'] as int?,
        name: m['name'] as String,
        age: m['age'] as int,
        gender: m['gender'] as String,
        phone: m['phone'] as String,
        notes: (m['notes'] as String?) ?? '',
        createdAt:
            DateTime.fromMillisecondsSinceEpoch(m['created_at'] as int),
      );
}
