import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zmare/src/utils/ext/common.dart';

import '../../../../service_locator.dart';
import '../../../widgets/zmare_text.dart';
import '../../../widgets/zmare_text_field.dart';
import '../../bloc/auth_bloc.dart';

class ResetPasswordInputPage extends StatefulWidget {
  const ResetPasswordInputPage({super.key, required this.email});
  final String email;

  @override
  State<ResetPasswordInputPage> createState() => _ResetPasswordInputPageState();
}

class _ResetPasswordInputPageState extends State<ResetPasswordInputPage> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final _formChangePassword = GlobalKey<FormState>();
  final AuthBloc authBloc = locator.get<AuthBloc>();
  bool _showPassword = true;
  bool _showConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        context.go(homePagePath);

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(
                Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios),
            onPressed: () {
              context.go(homePagePath);
            },
          ),
        ),
        body: BlocProvider(
          create: (context) => authBloc,
          child: BlocListener(
            bloc: authBloc,
            listener: (context, state) {
              if (state is ResetPasswordSuccess) {
                context.dismiss();
                _showUpdateDialog(context);
              } else if (state is ResetPasswordLoading) {
                context.show();
              } else if (state is Failure) {
                context.dismiss();
                context.showMaterialSnackBar(state.message);
              }
            },
            child: Center(
              child: Form(
                key: _formChangePassword,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceBright,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Icon(
                        FluentIcons.password_48_regular,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      "Create a new password",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Please choose a password that hasn't been used before.Must be atleast 8 characters.",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color.fromARGB(143, 255, 255, 255)),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          ListTile(
                            dense: true,
                            minTileHeight: 20,
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              context.loc.password,
                              style: context.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w400, fontSize: 14),
                            ),
                          ),
                          ZmareTextField(
                            prefixIcon: Icon(
                              FluentIcons.password_20_regular,
                              size: 20,
                            ),
                            outlineInputBorder: true,
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            enableSuggestions: false,
                            autocorrect: false,
                            controller: passwordController,
                            obscureText: _showPassword,
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return context.loc.requiredPassword;
                              } else if (value.length < 6) {
                                return context.loc.requiredPasswordLength6;
                              } else if (value.length > 15) {
                                return context.loc.requiredPasswordLength15;
                              } else {
                                return null;
                              }
                            },
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                              child: Icon(
                                _showPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 15,
                              ),
                            ),
                          ),
                          ListTile(
                            dense: true,
                            minTileHeight: 20,
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              context.loc.confirmPassword,
                              style: context.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w400, fontSize: 14),
                            ),
                          ),
                          ZmareTextField(
                            prefixIcon: Icon(
                              FluentIcons.password_20_regular,
                              size: 20,
                            ),
                            outlineInputBorder: true,
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            enableSuggestions: false,
                            autocorrect: false,
                            controller: confirmPasswordController,
                            obscureText: _showConfirmPassword,
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return context.loc.requiredPassword;
                              } else if (value.length < 6) {
                                return context.loc.requiredPasswordLength6;
                              } else if (value.length > 15) {
                                return context.loc.requiredPasswordLength15;
                              } else {
                                return null;
                              }
                            },
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showConfirmPassword = !_showConfirmPassword;
                                });
                              },
                              child: Icon(
                                _showConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            onPressed: () {
                              if (_formChangePassword.currentState!
                                  .validate()) {
                                authBloc.add(ResetPasswordEvent(
                                    widget.email,
                                    passwordController.text,
                                    confirmPasswordController.text));
                              }
                              // context.pushNamed(otpPath);
                            },
                            child: ZmareText(
                              text: "Reset Password",
                              isBold: true,
                              isSmall: true,
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showUpdateDialog(BuildContext contex) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          onPopInvokedWithResult: (didPop, result) {
            // if (isMandatory == 1) SystemNavigator.pop();
          },
          child: AlertDialog(
            content: SizedBox(
              height: 250, // Set the desired height
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.verified_user_outlined,
                    size: 70,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    'Password Reset Successful!',
                    style: context.headlineLarge?.copyWith(fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'You can now log in with your new password.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  OutlinedButton(
                    child: Text('Back to Login'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.go(signInPath);
                    },
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
