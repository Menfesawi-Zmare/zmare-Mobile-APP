import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/presentation/login/bloc/auth_bloc.dart';
import 'package:zmare/src/presentation/widgets/zmare_text.dart';
import 'package:zmare/src/presentation/widgets/zmare_text_field.dart';
import 'package:zmare/src/service_locator.dart';
import 'package:go_router/go_router.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  bool _obscureCurrentPassword = false;
  final currentPasswordController = TextEditingController();
  final AuthBloc authBloc = locator.get<AuthBloc>();
  final _deleteForm = GlobalKey<FormState>();
  @override
  void dispose() {
    currentPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => authBloc,
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is DeleteAccountState) {
            if (state.result == true) {
              context.go(homePagePath);
              context.showMaterialSnackBar(context.loc.deleteProfile);
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
              context.loc.user_menu_delete,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _deleteForm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ZmareText(
                        text: context.loc.delete_acc_desc,
                        isSmall: true,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 16),
                        child: Divider(),
                      ),
                      ZmareTextField(
                        controller: currentPasswordController,
                        labelText: context.loc.ttlCurrentPassword,
                        hintText: context.loc.subCurrentPassword,
                        obscureText: !_obscureCurrentPassword,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureCurrentPassword =
                                  !_obscureCurrentPassword;
                            });
                          },
                          child: Icon(_obscureCurrentPassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
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
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 16),
                        child: Divider(),
                      ),
                    ],
                  ),
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
                    if (_deleteForm.currentState!.validate()) {
                      authBloc.add(
                          DeleteAccountEvent(currentPasswordController.text));
                    }
                  },
                  child: ZmareText(
                    text: context.loc.delete,
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
