import 'package:stacked_services/stacked_services.dart';
import 'package:todo_task/app/app.locator.dart';
import 'package:todo_task/app/app.router.dart';

mixin NavigationMixin {
  final NavigationService _navigationService = locator<NavigationService>();

  void goToSignUp() => _navigationService.clearStackAndShow(Routes.signUpView);
  void goToHome() => _navigationService.clearStackAndShow(Routes.homeView);
  void goToLogin() => _navigationService.clearStackAndShow(Routes.loginView);
}
