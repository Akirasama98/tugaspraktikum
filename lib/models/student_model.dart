class BlueArchiveStudent {
  String? id;
  String name;
  String school;
  String club;
  int age;
  String rarity; // e.g., 1★, 2★, 3★
  String combatType; // e.g., Striker, Special
  String weaponType; // e.g., AR, SMG, Shotgun
  String imageUrl;

  BlueArchiveStudent({
    this.id,
    required this.name,
    required this.school,
    required this.club,
    required this.age,
    required this.rarity,
    required this.combatType,
    required this.weaponType,
    this.imageUrl = '',
  });

  // Convert BlueArchiveStudent object to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'school': school,
      'club': club,
      'age': age,
      'rarity': rarity,
      'combatType': combatType,
      'weaponType': weaponType,
      'imageUrl': imageUrl,
    };
  }

  // Create a BlueArchiveStudent object from a Map
  factory BlueArchiveStudent.fromMap(Map<String, dynamic> map, String documentId) {
    return BlueArchiveStudent(
      id: documentId,
      name: map['name'] ?? '',
      school: map['school'] ?? '',
      club: map['club'] ?? '',
      age: map['age'] ?? 0,
      rarity: map['rarity'] ?? '',
      combatType: map['combatType'] ?? '',
      weaponType: map['weaponType'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}
