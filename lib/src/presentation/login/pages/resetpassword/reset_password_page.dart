import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zmare/src/presentation/login/bloc/auth_bloc.dart';
import 'package:zmare/src/presentation/widgets/zmare_text.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/utils/ext/string_extensions.dart';

import '../../../../service_locator.dart';
import '../../../widgets/zmare_text_field.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController emailController = TextEditingController();
  final _formReset = GlobalKey<FormState>();
  final AuthBloc authBloc = locator.get<AuthBloc>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: BlocProvider(
        create: (context) => authBloc,
        child: BlocListener(
          bloc: authBloc,
          listener: (context, state) {
            if (state is RequestResetPasswordLoading) {
              context.show();
            } else if (state is RequestResetPasswordSuccess) {
              context.dismiss();
              context
                  .pushNamed(otpPath, extra: {"email": emailController.text});
              context.showMaterialSnackBar(state.requestEmailResponse.message!);
            } else if (state is Failure) {
              context.dismiss();
              context.showMaterialSnackBar(state.message);
            }
          },
          child: Center(
            child: Form(
              key: _formReset,
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
                      Icons.lock_outline_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    "Reset Your Password",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      textAlign: TextAlign.center,
                      "Forgot your password? please enter your email and we will send you a 4-digit code.",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color.fromARGB(143, 255, 255, 255)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ZmareTextField(
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        size: 20,
                      ),
                      outlineInputBorder: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      controller: emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return context.loc.requiredEmail;
                        } else if (value.isValidEmail == false) {
                          return context.loc.enterValidEmail;
                        } else {
                          return null;
                        }
                      },
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
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          onPressed: () {
                            if (_formReset.currentState!.validate()) {
                              authBloc.add(RequestResetPassworEvent(
                                  emailController.text));
                            }
                          },
                          child: ZmareText(
                            text: "Get 4-digit code",
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
    );
  }
}
