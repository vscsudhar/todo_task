import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  final String id;
  final String title;
  final String description;
  final bool completed;
  final Timestamp timeStamp;
  final String createdBy; // New field
  final List<String> sharedWith;

  TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.timeStamp,
    required this.createdBy,
    required this.sharedWith,
  });

  factory TodoModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    return TodoModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      completed: data['completed'] ?? false,
      timeStamp: data['createdAt'] ?? Timestamp.now(),
      createdBy: data['createdBy'] ?? '',
      sharedWith: List<String>.from(data['sharedWith'] ?? []),
    );
  }
}
