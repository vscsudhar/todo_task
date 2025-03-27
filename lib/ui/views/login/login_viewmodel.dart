import 'package:firebase_auth/firebase_auth.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:todo_task/app/app.locator.dart';
import 'package:todo_task/core/navigation/navigation_mixin.dart';
import 'package:todo_task/services/auth_service.dart';

class LoginViewModel extends BaseViewModel with NavigationMixin {
  LoginViewModel() {}

  final AuthService _authService = locator<AuthService>();
  final _dialogService = locator<DialogService>();

  String? _email;
  String? _pass;

  void emailSave(String email) {
    _email = email;
    notifyListeners();
  }

  void passSave(String pass) {
    _pass = pass;
    notifyListeners();
  }

  Future<void> loginCredentials() async {
    User? user = await _authService.signInWithEmailAndPassword(_email.toString(), _pass.toString());

    if (user != null) {
      goToHome();
      showDialogmessage('Login success....!');
    }
    notifyListeners();
  }

  void showDialogmessage(String message) {
    _dialogService.showCustomDialog(title: "Message", description: message);
  }
}
