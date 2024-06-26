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

class SignInView extends StatelessWidget {
  SignInView({
    super.key,
  });

  final GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
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
                child: SingleChildScrollView(
                  child: Form(
                    key: signInFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40.0),
                        Text(
                          'Sign in',
                          style: AppTextStyle.extraBold24,
                        ),
                        const AppSpacing(v: 107),
                        AppButton.outlined(
                          title: 'Continue with Google',
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          textStyle: AppTextStyle.medium14,
                          prefix: const AppIcons(
                            icon: AppIconData.google,
                            size: 24,
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
                          hintText: 'Enter your email address',
                          initialValue: controller.email,
                          onChanged: controller.updateEmail,
                          validator: AppValidators.validateEmail,
                        ),
                        const AppSpacing(v: 15),
                        AppInput(
                          hintText: 'Password',
                          initialValue: controller.password,
                          onChanged: controller.updatePassword,
                          keyboardType: TextInputType.visiblePassword,
                          validator: AppValidators.validatePassword,
                        ),
                        const AppSpacing(v: 21),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              controller.navigateForgotPassword();
                            },
                            child: Text(
                              'Forgot password?',
                              style: AppTextStyle.regular12.copyWith(
                                decoration: TextDecoration.underline,
                                color: AppColors.black50,
                              ),
                            ),
                          ),
                        ),
                        const AppSpacing(v: 33),
                        AppButton(
                          title: 'Sign In',
                          isLoading: controller.isBusy,
                          textColor: Colors.white,
                          onPressed: () {
                            if (signInFormKey.currentState == null) return;
                            if (signInFormKey.currentState!.validate()) {
                              controller.onSignIn();
                            }
                          },
                        ),
                        const AppSpacing(v: 30),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              controller.navigateForgotPassword();
                            },
                            child: RichText(
                                text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Don\'t have an account? ',
                                  style: AppTextStyle.medium14,
                                ),
                                TextSpan(
                                  text: 'Sign Up',
                                  style: AppTextStyle.medium14.copyWith(
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = controller.navigateToSignUp,
                                ),
                              ],
                            )),
                          ),
                        ),
                        const AppSpacing(v: 16),
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
