import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:todo_task/ui/common/shared/styles.dart';
import 'package:todo_task/ui/common/shared/text_style_helpers.dart';
import 'package:todo_task/ui/views/home/widget/complete_widget.dart';
import 'package:todo_task/ui/views/home/widget/pending_widget.dart';

import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    final _widgets = [
      PendingWidget(),
      Container(),
    ];
    return Scaffold(
      backgroundColor: Color(0xff1d2630),
      appBar: AppBar(
        backgroundColor: Color(0xff1d2630),
        foregroundColor: Colors.white,
        title: Text('Todo'),
        actions: [
          IconButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Logout'),
                    content: const Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close dialog
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          viewModel.logOut();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Logged out successfully'),
                            ),
                          );
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpacing20,
              Padding(
                padding: leftPadding10 + leftPadding8 + bottomPadding8,
                child: Text(
                  FirebaseAuth.instance.currentUser!.email.toString(),
                  style: fontFamilyBold.size18.appwhite,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      viewModel.indexIntPending();
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width / 2.2,
                      decoration: BoxDecoration(color: viewModel.buttonIndex == 0 ? Colors.indigo : Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: Center(
                        child: Text(
                          'Pending',
                          style: viewModel.buttonIndex == 0 ? fontFamilyMedium.size16.copyWith(color: Colors.white) : fontFamilyMedium.size14.copyWith(color: Colors.black38),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      viewModel.indexIntComplete();
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width / 2.2,
                      decoration: BoxDecoration(color: viewModel.buttonIndex == 1 ? Colors.indigo : Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: Center(
                        child: Text(
                          'Completed',
                          style: viewModel.buttonIndex == 1 ? fontFamilyMedium.size16.copyWith(color: Colors.white) : fontFamilyMedium.size14.copyWith(color: Colors.black38),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              if (viewModel.buttonIndex == 0)
                Padding(
                  padding: defaultPadding10,
                  child: PendingWidget(),
                ),
              if (viewModel.buttonIndex == 1)
                Padding(
                  padding: defaultPadding10,
                  child: CompleteWidget(),
                ),
              verticalSpacing20,
              verticalSpacing10,
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          _showTaskDialog(context, viewModel);
        },
      ),
    );
  }

  void _showTaskDialog(BuildContext context, HomeViewModel viewModel) {
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
                mainAxisSize: MainAxisSize.min, // Prevent unnecessary expansion
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

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
}
