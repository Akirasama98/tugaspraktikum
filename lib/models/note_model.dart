class Note {
  String? id;
  String title;
  String content;
  DateTime createdAt;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  // Convert Note object to a Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  // Create a Note object from a Map
  factory Note.fromMap(Map<String, dynamic> map, String documentId) {
    return Note(
      id: documentId,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }
}
