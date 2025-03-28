import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:todo_task/ui/common/shared/styles.dart';
import 'package:todo_task/ui/common/shared/text_style_helpers.dart';

import 'sign_up_viewmodel.dart';

class SignUpView extends StackedView<SignUpViewModel> {
  const SignUpView({Key? key}) : super(key: key);

  static final formKey = GlobalKey<FormState>();

  @override
  Widget builder(
    BuildContext context,
    SignUpViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Color(0xff1d2630),
      appBar: AppBar(
        backgroundColor: Color(0xff1d2630),
        foregroundColor: Colors.white,
        title: Text('Register'),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: defaultPadding14.r,
        child: Form(
          key: formKey,
          child: Column(
            children: [
              verticalSpacing40,
              Text('Welcome', style: fontFamilyBold.size30.copyWith(color: Colors.white)),
              Text('Register Here', style: fontFamilyMedium.size16.copyWith(color: Colors.white)),
              verticalSpacing20,
              verticalSpacing20,
              TextFormField(
                key: ValueKey('email'),
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
                validator: (value) => value == null ? 'Enter valid email' : null,
              ),
              verticalSpacing20,
              TextFormField(
                obscureText: true,
                key: ValueKey('pass'),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a password";
                  } else if (value.length < 6) {
                    return "Password must be at least 6 characters long";
                  }
                  return null;
                },
              ),
              verticalSpacing20,
              TextFormField(
                obscureText: true,
                key: ValueKey('pass1'),
                style: fontFamilyMedium.size16.copyWith(color: Colors.white),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.white60)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText: 'Confirm Password',
                  labelStyle: fontFamilyMedium.size16.copyWith(color: Colors.white60),
                ),
                onSaved: (pass) => viewModel.passSave(pass.toString()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please confirm your password";
                  } else if (value != viewModel.pass) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),
              verticalSpacing40,
              verticalSpacing10,
              SizedBox(
                height: 55.h,
                width: MediaQuery.of(context).size.width / 1.5.sp,
                child: ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState?.save();
                        viewModel.registerCredentials();
                        formKey.currentState?.reset();
                      }
                    },
                    child: Text(
                      'Register',
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
                  viewModel.goToLogin();
                },
                child: Text(
                  'Login',
                  style: fontFamilyMedium.size18,
                ),
              )
            ],
          ),
        ),
      )),
    );
  }

  @override
  SignUpViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SignUpViewModel();
}
