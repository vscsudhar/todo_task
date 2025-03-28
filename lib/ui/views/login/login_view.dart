import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:todo_task/ui/common/shared/styles.dart';
import 'package:todo_task/ui/common/shared/text_style_helpers.dart';

import 'login_viewmodel.dart';

class LoginView extends StackedView<LoginViewModel> {
  const LoginView({Key? key}) : super(key: key);
  static final _formKey = GlobalKey<FormState>();

  @override
  Widget builder(
    BuildContext context,
    LoginViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Color(0xff1d2630),
      appBar: AppBar(
        backgroundColor: Color(0xff1d2630),
        foregroundColor: Colors.white,
        title: Text('Sign In'),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: defaultPadding14,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              verticalSpacing40,
              Text('Welcome Back', style: fontFamilyBold.size30.copyWith(color: Colors.white)),
              Text('Login Here', style: fontFamilyMedium.size16.copyWith(color: Colors.white)),
              verticalSpacing20,
              verticalSpacing20,
              TextFormField(
                key: ValueKey('emaillogin'),
                style: fontFamilyMedium.size16.copyWith(color: Colors.white),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.white60)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText: 'Email',
                  labelStyle: fontFamilyMedium.size16.copyWith(color: Colors.white60),
                ),
                onSaved: (email) => viewModel.emailSave(email.toString()),
              ),
              verticalSpacing20,
              TextFormField(
                obscureText: true,
                key: ValueKey('passlogin'),
                style: fontFamilyMedium.size16.copyWith(color: Colors.white),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.white60)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText: 'Password',
                  labelStyle: fontFamilyMedium.size16.copyWith(color: Colors.white60),
                ),
                onSaved: (pass) => viewModel.passSave(pass.toString()),
              ),
              verticalSpacing40,
              verticalSpacing10,
              SizedBox(
                height: 55,
                width: MediaQuery.of(context).size.width / 1.5,
                child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState?.save();
                        viewModel.loginCredentials();
                        _formKey.currentState?.reset();
                      }
                    },
                    child: Text(
                      'Login  ',
                      style: fontFamilyMedium.size18.copyWith(color: Colors.indigo),
                    )),
              ),
              verticalSpacing20,
              Text(
                'Or',
                style: fontFamilyMedium.size16.copyWith(color: Colors.white),
              ),
              verticalSpacing20,
              TextButton(
                onPressed: () {
                  viewModel.goToSignUp();
                },
                child: Text('Register and Create Account', style: fontFamilyMedium.size16),
              )
            ],
          ),
        ),
      )),
    );
  }

  @override
  LoginViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      LoginViewModel();
}
