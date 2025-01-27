import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_music_pro/src/app/routes.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/utils/ext/string_extensions.dart';
import 'package:flutter_music_pro/src/presentation/login/bloc/auth_bloc.dart';
import 'package:flutter_music_pro/src/presentation/widgets/khmertracks_text.dart';
import 'package:flutter_music_pro/src/presentation/widgets/khmertracks_text_field.dart';
import 'package:flutter_music_pro/src/service_locator.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final AuthBloc authBloc = locator.get<AuthBloc>();
  final _formLogin = GlobalKey<FormState>();
  bool _showPassword = true;
  bool acceptEULA = false;
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  String? tos = settings.get(tosUrl, defaultValue: '');
  @override
  void initState() {
    if (tos == null) {
      authBloc.add(AppSettingsEvent());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: context.materialYouAppBar(
        context.loc.createAccount,
      ),
      body: BlocProvider(
        create: (context) => authBloc,
        child: BlocListener(
          bloc: authBloc,
          listener: (context, state) {
            if (state is Loading) {
              context.show();
            }
            if (state is ValidFields) {
              authBloc.add(SignUpRequestedEvent(userNameController.text,
                  passwordController.text, emailController.text));
            }
            if (state is RegisterNormalState) {
              context.dismiss();
              if (state.registerResponse.status == true) {
                authBloc.add(GetProfileEvent());
                context.go(homePagePath);
              }
            }
            if (state is Failure) {
              context.dismiss();
              context.showMaterialSnackBar(state.message);
            }
          },
          child: Form(
            key: _formLogin,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    context.loc.username,
                    style: context.titleMedium!
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                KhmertracksTextField(
                  outlineInputBorder: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  controller: userNameController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                  ],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return context.loc.requiredUsername;
                    } else if (value.length < 6) {
                      return context.loc.requiredUsernameLength6;
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
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    context.loc.ttlEmail,
                    style: context.titleMedium!
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                KhmertracksTextField(
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
                const SizedBox(height: 24),
                ListTile(
                  trailing: BlocBuilder(
                    bloc: authBloc,
                    buildWhen: (old, current) =>
                        current is EulaToggleState && old != current,
                    builder: (context, state) {
                      if (state is EulaToggleState) {
                        acceptEULA = state.eulaAccepted;
                      }
                      return Checkbox(
                        onChanged: (value) => authBloc.add(
                          ToggleEulaCheckboxEvent(
                            eulaAccepted: value!,
                          ),
                        ),
                        activeColor: Theme.of(context).colorScheme.primary,
                        value: acceptEULA,
                      );
                    },
                  ),
                  title: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      style: context.bodyMedium?.copyWith(
                        color: context.bodySmall?.color,
                      ),
                      children: [
                        TextSpan(
                          text: context.loc.agreement,
                        ),
                        TextSpan(
                          style: const TextStyle(color: Colors.blueAccent),
                          text: context.loc.tos,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              // ignore: deprecated_member_use
                              if (await canLaunch(tos!)) {
                                // ignore: deprecated_member_use
                                await launch(
                                  tos!,
                                  forceSafariVC: false,
                                );
                              }
                            },
                        ),
                      ],
                    ),
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
                      onPressed: () => authBloc.add(ValidateFieldsEvent(
                          _formLogin,
                          acceptEula: acceptEULA)),
                      child: KhmertracksText(
                        text: context.loc.createAccount,
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
