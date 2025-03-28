import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:stacked/stacked.dart';
import 'package:todo_task/core/models/todo_model.dart';
import 'package:todo_task/ui/common/shared/styles.dart';
import 'package:todo_task/ui/common/shared/text_style_helpers.dart';
import 'package:todo_task/ui/views/home/home_viewmodel.dart';
import 'package:intl/intl.dart';

class PendingWidget extends StatelessWidget {
  const PendingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, viewModel, child) {
        return StreamBuilder<List<TodoModel>>(
          stream: viewModel.getTodos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No Pending tasks'),
              );
            }

            List<TodoModel> todos = snapshot.data!;

            return ListView.builder(
              itemCount: todos.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                TodoModel todo = todos[index];

                return Container(
                  margin: defaultPadding10,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Slidable(
                    key: ValueKey(todo.id),
                    endActionPane: ActionPane(motion: DrawerMotion(), children: [
                      SlidableAction(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        icon: Icons.share,
                        label: 'Share',
                        onPressed: (context) {
                          showShareDialog(context, viewModel, todo);
                        },
                      ),
                      SlidableAction(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        icon: Icons.done,
                        label: 'Complete',
                        onPressed: (context) {
                          viewModel.datebaseService.updateTodoStatus(todo.id, true);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Updated status')),
                          );
                        },
                      )
                    ]),
                    startActionPane: ActionPane(motion: DrawerMotion(), children: [
                      SlidableAction(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Edit',
                        onPressed: (context) async {
                          viewModel.setTodoModel(todo);
                          showTaskDialog(context, viewModel);
                        },
                      ),
                      SlidableAction(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                        onPressed: (context) {
                          if (todo.createdBy == FirebaseAuth.instance.currentUser!.uid) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirm Delete'),
                                  content: const Text('Are you sure you want to delete?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        await viewModel.datebaseService.deleteTodoTask(todo.id);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Logged out successfully'),
                                          ),
                                        );
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('You can only delete your own tasks!')),
                            );
                          }
                        },
                      ),
                    ]),
                    child: ListTile(
                      title: Text(
                        todo.title,
                        style: fontFamilyMedium.size16,
                      ),
                      subtitle: Text(
                        todo.description,
                        style: fontFamilyMedium.size16,
                      ),
                      trailing: Text('${DateFormat('dd/MM/yyyy').format(todo.timeStamp.toDate())}', style: fontFamilyMedium.size14),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void showTaskDialog(BuildContext context, HomeViewModel viewModel) {
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            viewModel.todoModel == null ? "Add Task" : "Edit Task",
            style: fontFamilyBold,
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    key: const ValueKey('title'),
                    initialValue: viewModel.todoModel?.title ?? '',
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (newValue) => viewModel.addOrUpdateTitle(newValue ?? ''),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Title cannot be empty';
                      }
                      return null;
                    },
                  ),
                  verticalSpacing10,
                  TextFormField(
                    key: const ValueKey('description'),
                    initialValue: viewModel.todoModel?.description ?? '',
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (newValue) => viewModel.addOrUpdateDesc(newValue ?? ''),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  await viewModel.addOrUpdateFun(viewModel.todoModel);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Updated successfully')),
                  );
                }
              },
              child: Text(viewModel.todoModel == null ? "Add" : "Update"),
            ),
          ],
        );
      },
    );
  }

  void showShareDialog(BuildContext context, HomeViewModel viewModel, TodoModel todo) {
    TextEditingController emailController = TextEditingController();
    User? user;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Share Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Task: ${todo.title}",
                style: fontFamilyMedium.size16,
              ),
              Text(
                "Description: ${todo.description}",
                style: fontFamilyMedium.size14,
              ),
              verticalSpacing10,
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Enter register recipient email',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (emailController.text.isNotEmpty) {
                  await viewModel.datebaseService.shareTask(todo.id, emailController.text);
                  Navigator.pop(context);
                }
              },
              child: Text('Share'),
            ),
          ],
        );
      },
    );
  }
}
