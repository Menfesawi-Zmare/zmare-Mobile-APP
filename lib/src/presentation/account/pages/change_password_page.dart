import 'package:flutter/material.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/presentation/login/bloc/auth_bloc.dart';
import 'package:zmare/src/presentation/widgets/zmare_text.dart';
import 'package:zmare/src/presentation/widgets/zmare_text_field.dart';
import 'package:zmare/src/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool _obscureCurrentPassword = false;
  bool _obscureNewPassword = false;
  bool _obscureRepeatPassword = false;
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final repeatPasswordController = TextEditingController();
  final AuthBloc authBloc = locator.get<AuthBloc>();

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => authBloc,
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UpdatePasswordState) {
            if (state.updateAccountResponse.status == true) {
              GoRouter.of(context).pop();
              context.showMaterialSnackBar(context.loc.settingsSaved);
            }
          }
          if (state is Failure) {
            context.showMaterialSnackBar(state.message);
          }
        },
        builder: (context, state) {
          return Scaffold(
            extendBody: true,
            appBar: context.materialYouAppBar(
              context.loc.userTtlSecurity,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ZmareTextField(
                      controller: currentPasswordController,
                      labelText: context.loc.ttlCurrentPassword,
                      hintText: context.loc.subCurrentPassword,
                      obscureText: !_obscureCurrentPassword,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureCurrentPassword = !_obscureCurrentPassword;
                          });
                        },
                        child: Icon(_obscureCurrentPassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 16),
                      child: Divider(),
                    ),
                    ZmareTextField(
                      controller: newPasswordController,
                      labelText: context.loc.ttlNewPassword,
                      hintText: context.loc.subNewPassword,
                      obscureText: !_obscureNewPassword,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureNewPassword = !_obscureNewPassword;
                          });
                        },
                        child: Icon(_obscureNewPassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ZmareTextField(
                      controller: repeatPasswordController,
                      labelText: context.loc.ttlRepeatPassword,
                      hintText: context.loc.subRepeatPassword,
                      obscureText: !_obscureRepeatPassword,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureRepeatPassword = !_obscureRepeatPassword;
                          });
                        },
                        child: Icon(_obscureRepeatPassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 30),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer),
                  onPressed: () {
                    authBloc.add(ChangePasswordEvent(
                        currentPasswordController.text,
                        newPasswordController.text,
                        repeatPasswordController.text));
                  },
                  child: ZmareText(
                    text: context.loc.saveChanges,
                    isBold: true,
                    isSmall: true,
                  )),
            ),
          );
        },
      ),
    );
  }
}
