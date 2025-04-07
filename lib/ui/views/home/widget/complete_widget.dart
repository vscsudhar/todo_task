  import 'package:flutter/material.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter_slidable/flutter_slidable.dart';
  import 'package:stacked/stacked.dart';
  import 'package:todo_task/core/models/todo_model.dart';
  import 'package:todo_task/ui/common/shared/styles.dart';
  import 'package:todo_task/ui/common/shared/text_style_helpers.dart';
  import 'package:todo_task/ui/views/home/home_viewmodel.dart';
  import 'package:intl/intl.dart';

  class CompleteWidget extends StatelessWidget {
    const CompleteWidget({super.key});

    @override
    Widget build(BuildContext context) {
      return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(),
        builder: (context, viewModel, child) {
          return StreamBuilder<List<TodoModel>>(
            stream: viewModel.getTodosComplete(),
            builder: (context, snapshot) {//
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Column(
                  children: [
                    verticalSpacing60,
                    verticalSpacing60,
                    Center(
                      child: Text(
                        'No completed tasks',
                        style: fontFamilyMedium.size16.appwhite,
                      ),
                    ),
                  ],
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
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Slidable(
                      key: ValueKey(todo.id),
                      endActionPane: ActionPane(motion: DrawerMotion(), children: [
                        SlidableAction(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                          onPressed: (context) {
                            if (todo.createdBy == FirebaseAuth.instance.currentUser!.uid) {
                              viewModel.datebaseService.deleteTodoTask(todo.id);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('You can only delete your own tasks!')),
                              );
                            }
                          },
                        )
                      ]),
                      child: ListTile(
                        title: Text(
                          todo.title,
                          style: fontFamilyMedium.size16.copyWith(decoration: TextDecoration.lineThrough),
                        ),
                        subtitle: Text(
                          todo.description,
                          style: fontFamilyMedium.size16,
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (todo.createdBy == FirebaseAuth.instance.currentUser!.uid) ? Colors.white : Colors.red
                              ),
                            ),
                            Text('${DateFormat('dd/MM/yyyy').format(todo.timeStamp.toDate())}', style: fontFamilyMedium.size14),
                          ],
                        ),
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
                  }
                },
                child: Text(viewModel.todoModel == null ? "Add" : "Update"),
              ),
            ],
          );
        },
      );
    }
  }
