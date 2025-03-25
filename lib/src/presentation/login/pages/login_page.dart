import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hive_flutter/adapters.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/presentation/login/bloc/auth_bloc.dart';
import 'package:zmare/src/presentation/widgets/zmare_text.dart';
import 'package:zmare/src/presentation/widgets/zmare_text_field.dart';
import 'package:zmare/src/service_locator.dart';
import 'package:logging/logging.dart';

import '../../../core/enum/box_types.dart';
import '../../../core/resources/images.dart';

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
        // context.loc.login,
        "",
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
                SizedBox(
                  height: 50,
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
                      context.loc.login,
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
                    context.loc.emailOrUsername,
                    style: context.titleMedium!
                        .copyWith(fontWeight: FontWeight.w400, fontSize: 14),
                  ),
                ),
                ZmareTextField(
                  prefixIcon: Icon(
                    FluentIcons.person_12_filled,
                    size: 20,
                  ),
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
                    FluentIcons.lock_closed_12_filled,
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
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: RichText(
                      // Use RichText for styled text
                      textAlign: TextAlign.right,
                      text: TextSpan(
                        style: context.bodyMedium?.copyWith(
                          // Apply your base text style
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: "Forgot Password?",
                              style: TextStyle(fontSize: 14)),
                          TextSpan(
                            text: " Reset",
                            style: TextStyle(
                                fontSize: 14,
                                color: context.primary,
                                fontWeight: FontWeight.w900),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
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
                      onPressed: () {
                        if (_formLogin.currentState!.validate()) {
                          authBloc.add(SignInRequestedEvent(
                              userNameController.text,
                              passwordController.text));
                        }
                      },
                      child: ZmareText(
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
