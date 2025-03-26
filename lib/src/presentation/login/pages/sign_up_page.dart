import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'package:hive_flutter/adapters.dart';
import 'package:zmare/src/app/routes.dart';
import 'package:zmare/src/core/enum/box_types.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/utils/ext/string_extensions.dart';
import 'package:zmare/src/presentation/login/bloc/auth_bloc.dart';
import 'package:zmare/src/presentation/widgets/zmare_text.dart';
import 'package:zmare/src/presentation/widgets/zmare_text_field.dart';
import 'package:zmare/src/service_locator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/resources/images.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final AuthBloc authBloc = locator.get<AuthBloc>();
  final _formLogin = GlobalKey<FormState>();
  bool _showPassword = true;
  bool _showConfirmPassword = true;
  bool acceptEULA = false;
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
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
      resizeToAvoidBottomInset: true,
      appBar: context.materialYouAppBar(
        // context.loc.createAccount,
        "",
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
              authBloc.add(SignUpRequestedEvent(
                  userNameController.text,
                  passwordController.text,
                  confirmPasswordController.text,
                  emailController.text));
            }
            if (state is RegisterNormalState) {
              context.dismiss();
              if (state.registerResponse.status == true) {
                authBloc.add(GetProfileEvent());
                context.go(verifyAccountPath, extra: emailController.text);
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
                SizedBox(
                  height: 40,
                ),
                ValueListenableBuilder<Box<dynamic>>(
                    valueListenable: locator
                        .get<Box<dynamic>>(instanceName: BoxType.settings.name)
                        .listenable(keys: [themeModeKey, dynamicThemeKey]),
                    builder: (context, value, child) {
                      final ThemeMode themeMode = ThemeMode.values[value.get(
                        themeModeKey,
                        defaultValue: 0,
                      )];
                      // int themeValue = value.get(themeModeKey, defaultValue: 0);
                      // final bool isDynamic = value.get(
                      //   dynamicThemeKey,
                      //   defaultValue: false,
                      // );
                      // final Brightness brightness =
                      //     MediaQuery.of(context).platformBrightness;
                      // bool isDarkMode = brightness == Brightness.dark;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: SvgPicture.asset(
                          // themeMode == ThemeMode.dark
                          //     ?
                          Images.zmareIconWhite,
                          // : themeMode == ThemeMode.light
                          //     ? Images.zmareIconBlack
                          //     : isDarkMode
                          //         ? Images.zmareIconWhite
                          //         : Images.zmareIconBlack,
                          height: 80,
                        ),
                      );
                    }),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.loc.createAccount,
                      style: context.titleLarge!.copyWith(fontSize: 26),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  dense: true,
                  minTileHeight: 20,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    context.loc.username,
                    style: context.titleMedium!
                        .copyWith(fontWeight: FontWeight.w400, fontSize: 14),
                  ),
                ),
                ZmareTextField(
                  prefixIcon: Icon(
                    Icons.person,
                    size: 20,
                  ),
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
                  dense: true,
                  minTileHeight: 20,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    context.loc.ttlEmail,
                    style: context.titleMedium!
                        .copyWith(fontWeight: FontWeight.w400, fontSize: 14),
                  ),
                ),
                ZmareTextField(
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
                const SizedBox(height: 5),
                ListTile(
                  dense: true,
                  minTileHeight: 20,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    context.loc.password,
                    style: context.titleMedium!
                        .copyWith(fontWeight: FontWeight.w400, fontSize: 14),
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
                      _showPassword ? Icons.visibility_off : Icons.visibility,
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
                    style: context.titleMedium!
                        .copyWith(fontWeight: FontWeight.w400, fontSize: 14),
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
                ListTile(
                  dense: true,
                  minTileHeight: 20,
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
                        fontSize: 12,
                        color: context.bodySmall?.color,
                      ),
                      children: [
                        TextSpan(
                          text: context.loc.agreement,
                        ),
                        TextSpan(
                          style:
                              TextStyle(color: context.primary, fontSize: 12),
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
                  height: 43,
                ),
                Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () => authBloc.add(ValidateFieldsEvent(
                          _formLogin,
                          acceptEula: acceptEULA)),
                      child: ZmareText(
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
