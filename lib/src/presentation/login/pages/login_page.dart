import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/presentation/login/bloc/auth_bloc.dart';
import 'package:zmare/src/presentation/widgets/khmertracks_text.dart';
import 'package:zmare/src/presentation/widgets/khmertracks_text_field.dart';
import 'package:zmare/src/service_locator.dart';
import 'package:logging/logging.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthBloc authBloc = locator.get<AuthBloc>();
  final _formLogin = GlobalKey<FormState>();
  bool _showPassword = true;
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: context.materialYouAppBar(
        context.loc.login,
      ),
      body: BlocProvider(
        create: (context) => authBloc,
        child: BlocListener(
          bloc: authBloc,
          listener: (context, state) {
            Logger.root.info(state);
            if (state is Loading) {
              context.show();
            }
            if (state is LoginWithUserNameAndPasswordState) {
              context.dismiss();
              context.go(homePagePath);
              authBloc.add(GetProfileEvent());
            }
            if (state is Failure) {
              context.dismiss();
              context.showMaterialSnackBar(state.message);
            }
          },
          child: Form(
            key: _formLogin,
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    context.loc.emailOrUsername,
                    style: context.titleMedium!
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                KhmertracksTextField(
                  outlineInputBorder: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  controller: userNameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return context.loc.requiredEmailOrUsername;
                    } else {
                      return null;
                    }
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    context.loc.password,
                    style: context.titleMedium!
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                KhmertracksTextField(
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
                    child: Icon(_showPassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        minimumSize: const Size(120, 50),
                      ),
                      onPressed: () {
                        if (_formLogin.currentState!.validate()) {
                          authBloc.add(SignInRequestedEvent(
                              userNameController.text,
                              passwordController.text));
                        }
                      },
                      child: KhmertracksText(
                        text: context.loc.login,
                        isBold: true,
                        isSmall: true,
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
