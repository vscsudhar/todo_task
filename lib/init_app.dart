  import 'package:flutter/material.dart';
  import 'package:todo_task/app/app.bottomsheets.dart';
  import 'package:todo_task/app/app.locator.dart';

  import 'ui/setup_dialog_ui.dart';

  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await setupLocator();
    setupDialogUi();
    setupBottomSheetUi();
  }
