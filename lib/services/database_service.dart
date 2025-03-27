import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_task/core/models/todo_model.dart';

class DatabaseService {
  final CollectionReference todoCollection =
      FirebaseFirestore.instance.collection('todos');

  User? user = FirebaseAuth.instance.currentUser;

  //Add todo task
 Future<DocumentReference> addTodoTask(String title, String description) async {
  return await todoCollection.add({
    'uid': user!.uid,
    'title': title,
    'description': description,
    'completed': false,
    'createdAt': FieldValue.serverTimestamp(),
    'createdBy': FirebaseAuth.instance.currentUser!.email, // Store the email of the creator
    'sharedWith': [], // Initialize empty shared list
  });
}


  //update todo task
 Future<void> updateTodoTask(String id, String title, String description) async {
  DocumentSnapshot taskSnapshot = await todoCollection.doc(id).get();

  if (taskSnapshot.exists) {
    Map<String, dynamic> taskData = taskSnapshot.data() as Map<String, dynamic>;

    if (taskData['uid'] == user!.uid || (taskData['sharedWith'] ?? []).contains(user!.email)) {
      // Allow update if user is the owner or a shared recipient
      await todoCollection.doc(id).update({
        'title': title,
        'description': description,
      });
    } else {
      throw Exception("You don't have permission to edit this task.");
    }
  }
}


  //update todo status
  Future<void> updateTodoStatus(String id, bool completed) async {
    return await todoCollection.doc(id).update({
      'completed': completed,
    });
  }

  //delete todo task
  Future<void> deleteTodoTask(String id) async {
    return await todoCollection.doc(id).delete();
  }

  // get completed task
  // Stream<List<TodoModel>> get todos {
  //   return todoCollection
  //       .where('uid', isEqualTo: user!.uid)
  //       .where('completed', isEqualTo: false)
  //       .snapshots()
  //       .map(_todoListFromSnapshot);
  // }
  Stream<List<TodoModel>> get todos {
  return todoCollection
      .where(Filter.or(
        Filter("uid", isEqualTo: user!.uid), // Created by user
        Filter("sharedWith", arrayContains: user!.email), // Shared with user
      ))
      .where('completed', isEqualTo: false)
      .snapshots()
      .map(_todoListFromSnapshot);
}



  // get completed task
 Stream<List<TodoModel>> get completedTodos {
  return todoCollection
      .where(Filter.or(
        Filter("uid", isEqualTo: user!.uid), // Created by user
        Filter("sharedWith", arrayContains: user!.email), // Shared with user
      ))
      .where('completed', isEqualTo: true)
      .snapshots()
      .map(_todoListFromSnapshot);
}

List<TodoModel> _todoListFromSnapshot(QuerySnapshot snapshots) {
  return snapshots.docs.map((doc) {
    final data = doc.data() as Map<String, dynamic>;

    return TodoModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      completed: data['completed'] ?? false,
      timeStamp: data['createdAt'] ?? Timestamp.now(),
      createdBy: data['uid'] ?? '', // Ensure 'uid' exists
      sharedWith: data.containsKey('sharedWith') 
          ? List<String>.from(data['sharedWith']) 
          : [], // Handle missing 'sharedWith' field
    );
  }).toList();
}



  //share
   Future<void> shareTask(String taskId, String recipientEmail) async {
  DocumentSnapshot taskSnapshot = await todoCollection.doc(taskId).get();

  if (taskSnapshot.exists) {
    Map<String, dynamic> taskData = taskSnapshot.data() as Map<String, dynamic>;

    // Only the creator of the task can share it
    if (taskData['uid'] == user!.uid) {  
      await todoCollection.doc(taskId).update({
        'sharedWith': FieldValue.arrayUnion([recipientEmail]), // Add shared user
      });
    } else {
      throw Exception("Only the task creator can share this task.");
    }
  }
}


Stream<List<TodoModel>> get sharedTodos {
  return todoCollection
      .where('sharedWith', arrayContains: user!.email) 
      .snapshots()
      .map(_todoListFromSnapshot);
}


}
