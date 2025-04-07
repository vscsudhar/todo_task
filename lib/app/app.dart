import 'package:todo_task/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:todo_task/ui/views/home/home_view.dart';
import 'package:todo_task/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:todo_task/services/auth_service.dart';
import 'package:todo_task/services/database_service.dart';
import 'package:todo_task/ui/views/sign_up/sign_up_view.dart';
import 'package:todo_task/ui/views/login/login_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: SignUpView),
    MaterialRoute(page: LoginView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: AuthService),
    LazySingleton(classType: DatabaseService),

// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  // dialogs: [
  //   StackedDialog(classType: InfoAlertDialog),
  //   // @stacked-dialog
  // ],
)
class App {}
