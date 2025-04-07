  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:todo_task/app/app.bottomsheets.dart';
  import 'package:todo_task/app/app.locator.dart';
  import 'package:todo_task/core/models/todo_model.dart';
  import 'package:todo_task/core/navigation/navigation_mixin.dart';
  import 'package:todo_task/services/auth_service.dart';
  import 'package:todo_task/services/database_service.dart';
  import 'package:todo_task/ui/common/app_strings.dart';
  import 'package:stacked/stacked.dart';
  import 'package:stacked_services/stacked_services.dart';

  import '../../../core/enum/dialog_type.dart';

  class HomeViewModel extends BaseViewModel with NavigationMixin {
    HomeViewModel() {
      uid = FirebaseAuth.instance.currentUser!.uid;
    }
    final _dialogService = locator<DialogService>();
    final _bottomSheetService = locator<BottomSheetService>();
    final _authService = locator<AuthService>();
    final _dataBaseService = locator<DatabaseService>();

    TodoModel? _todoModel;
    TodoModel? get todoModel => _todoModel;
    DatabaseService get datebaseService => _dataBaseService;

    String get counterLabel => 'Counter is: $_counter';
    String? _titleText;
    String? _descText;
    late String uid;

    int _counter = 0;
    int _buttonIndex = 0;

    int get buttonIndex => _buttonIndex;

    Stream<List<TodoModel>> getTodos() {
      return _dataBaseService.todos;
    }

    Stream<List<TodoModel>> getTodosComplete() {
      return _dataBaseService.completedTodos;
    }

    void indexIntPending() {
      _buttonIndex = 0;
      notifyListeners();
    }

    void indexIntComplete() {
      _buttonIndex = 1;
      notifyListeners();
    }

    void addOrUpdateTitle(String title) {
      _titleText = title;
      notifyListeners();
    }

    void addOrUpdateDesc(String desc) {
      _descText = desc;
      notifyListeners();
    }

    Future<void> addOrUpdateFun(todo) async {
      if (todo == null) {
        await _dataBaseService.addTodoTask(_titleText.toString(), _descText.toString());
        indexIntPending();
      } else {
        await _dataBaseService.updateTodoTask(todo.id, _titleText.toString(), _descText.toString());
      }
    }

    void incrementCounter() {
      _counter++;
      rebuildUi();
    }

    void showDialog() {
      _dialogService.showCustomDialog(
        variant: DialogType.infoAlert,
        title: 'Stacked Rocks!',
        description: 'Give stacked $_counter stars on Github',
      );
    }

    void showBottomSheet() {
      _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.notice,
        title: ksHomeBottomSheetTitle,
        description: ksHomeBottomSheetDescription,
      );
    }

    void logOut() async {
      await _authService.signOut();
      goToLogin();
    }

    void setTodoModel(TodoModel todo) {
      _todoModel = todo;
      notifyListeners();
    }

    void showDialogmessage(String message) {
      _dialogService.showCustomDialog(title: "Message", description: message);
    }
  }
