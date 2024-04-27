import 'package:flashcards/shared/app_button.dart';
import 'package:flashcards/shared/app_colors.dart';
import 'package:flashcards/shared/app_icons.dart';
import 'package:flashcards/shared/app_input.dart';
import 'package:flashcards/shared/app_spacing.dart';
import 'package:flashcards/shared/app_text_style.dart';
import 'package:flashcards/shared/validators.dart';
import 'package:flashcards/ui/auth/user_view_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SignUpView extends StatelessWidget {
  SignUpView({
    super.key,
  });

  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserViewModel>.reactive(
        viewModelBuilder: () => UserViewModel(),
        builder: (context, controller, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Form(
                  key: signUpFormKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 20.0),
                        Text(
                          'Sign Up',
                          style: AppTextStyle.semibold24.copyWith(
                            color: AppColors.grey900,
                          ),
                        ),
                        const AppSpacing(v: 16),
                        AppButton.outlined(
                          title: 'Continue with Google',
                          prefix: const AppIcons(
                            icon: AppIconData.google,
                          ),
                          isLoading: controller.isGoogleBusy,
                          onPressed: controller.logInWithGoogle,
                        ),
                        const Divider(
                          color: AppColors.grey300,
                          height: 60,
                          thickness: 1,
                        ),
                        AppInput(
                          hintText: 'First name',
                          initialValue: controller.firstName,
                          onChanged: controller.updateFirstName,
                          validator: AppValidators.validateName,
                        ),
                        const AppSpacing(v: 12),
                        AppInput(
                          hintText: 'Last name',
                          initialValue: controller.lastName,
                          onChanged: controller.updateLastName,
                          validator: AppValidators.validateName,
                        ),
                        const AppSpacing(v: 12),
                        AppInput(
                          hintText: 'Email address',
                          initialValue: controller.email,
                          onChanged: controller.updateEmail,
                          validator: AppValidators.validateEmail,
                        ),
                        const AppSpacing(v: 12),
                        AppInput(
                          hintText: 'Enter a password',
                          initialValue: controller.password,
                          onChanged: controller.updatePassword,
                          keyboardType: TextInputType.visiblePassword,
                          validator: AppValidators.validatePassword,
                        ),
                        const AppSpacing(v: 12),
                        AppInput(
                          hintText: 'Enter a password',
                          initialValue: controller.confirmPassword,
                          onChanged: controller.updateConfirmPassword,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) =>
                              AppValidators.validateConfirmPassword(
                                  controller.password, value),
                        ),
                        const SizedBox(height: 16.0),
                        AppButton(
                          title: 'Sign up',
                          textColor: Colors.white,
                          isLoading: controller.isBusy,
                          onPressed: () {
                            if (signUpFormKey.currentState == null) {
                              return;
                            }
                            if (signUpFormKey.currentState!.validate()) {
                              controller.createAccount();
                            }
                          },
                        ),
                        const SizedBox(height: 16.0),
                        Center(
                          child: RichText(
                              text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Have an account? ',
                                style: AppTextStyle.light14,
                              ),
                              TextSpan(
                                text: 'Log in',
                                style: AppTextStyle.light14.copyWith(
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = controller.navigateToSignin,
                              ),
                            ],
                          )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
