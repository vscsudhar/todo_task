import 'package:firebase_auth/firebase_auth.dart';
import 'package:stacked/stacked.dart';
import 'package:todo_task/app/app.locator.dart';
import 'package:todo_task/core/navigation/navigation_mixin.dart';
import 'package:todo_task/services/auth_service.dart';

class SignUpViewModel extends BaseViewModel with NavigationMixin {
  SignUpViewModel() {}

  final AuthService _authService = locator<AuthService>();

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

  Future<void> registerCredentials() async {
    User? user = await _authService.registerWithEmailAndPassword(
        _email.toString(), _pass.toString());

    if (user != null) {
      goToLogin();
    }
    notifyListeners();
  }
}
