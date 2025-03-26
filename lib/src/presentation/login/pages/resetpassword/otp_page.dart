import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:zmare/src/app/routes.dart';
import 'package:zmare/src/presentation/login/bloc/auth_bloc.dart';
import 'package:zmare/src/presentation/widgets/zmare_text.dart';

import '../../../../service_locator.dart';
import '../../../../utils/helper/constants.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key, required this.email});
  final String email;

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  TextEditingController otpController = TextEditingController();
  final AuthBloc authBloc = locator.get<AuthBloc>();
  bool isVerified = false;
  bool hasError = false;
  bool canResendOtp = false;
  int resendTimer = 120;
  late Timer _timer;
  @override
  void initState() {
    startResendTimer();
    authBloc.stream.listen((state) {
      if (state is OtpVerifySuccess) {
        setState(() {
          isVerified = true;
          hasError = false; // Reset error on success
        });
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted)
            context.pushNamed(resetPage, extra: {"email": widget.email});
        });
      }

      if (state is RequestResetPasswordSuccess) {
        setState(() {
          canResendOtp = false;
          resendTimer = 120;
        });
        startResendTimer();
      }
      if (state is Failure) {
        setState(() {
          hasError = true;
        });
      }
    });
    super.initState();
  }

  void startResendTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer > 0) {
        setState(() => resendTimer--);
      } else {
        setState(() => canResendOtp = true);
        _timer.cancel();
      }
    });
  }

  void resendOtp() {
    if (canResendOtp) {
      authBloc.add(RequestResetPassworEvent(widget.email));
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 22,
          color: const Color.fromARGB(204, 255, 255, 255),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.4),
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
    final verifiedPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 22,
          color: const Color.fromARGB(169, 255, 255, 255),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.green,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Center(
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
                Icons.password,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              textAlign: TextAlign.center,
              "Enter Confirmation Code",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                textAlign: TextAlign.center,
                "We sent a code to ${widget.email}",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: const Color.fromARGB(143, 255, 255, 255)),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Pinput(
                  isCursorAnimationEnabled: true,
                  pinAnimationType: isVerified
                      ? PinAnimationType.scale
                      : PinAnimationType.none,
                  animationCurve:
                      isVerified ? Curves.easeOutSine : Curves.bounceIn,
                  animationDuration: Duration(milliseconds: 300),
                  controller: otpController,
                  onCompleted: (value) {
                    authBloc.add(VerifyOtpEvent(widget.email, value));
                  },
                  defaultPinTheme: hasError
                      ? defaultPinTheme.copyDecorationWith(
                          border: Border.all(
                            color:
                                Colors.red, // Red border when focused and error
                            width: 1.5,
                          ),
                        )
                      : isVerified
                          ? verifiedPinTheme
                          : defaultPinTheme,
                  disabledPinTheme: defaultPinTheme.copyDecorationWith(
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withOpacity(0.2),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedPinTheme: defaultPinTheme.copyDecorationWith(
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                )),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Didn't receive code?",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color.fromARGB(143, 255, 255, 255),
                      ),
                ),
                const SizedBox(width: 3),
                if (!canResendOtp)
                  Text(
                    "Resend in",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color.fromARGB(143, 255, 255, 255),
                        ),
                  ),
                const SizedBox(width: 4),
                if (!canResendOtp)
                  Text(
                    "${resendTimer ~/ 60}:${(resendTimer % 60).toString().padLeft(2, '0')}",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                if (canResendOtp)
                  TextButton(
                    onPressed: resendOtp,
                    child: Text(
                      "Resend ",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            // Center(
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 20),
            //     child: ElevatedButton(
            //         style: ElevatedButton.styleFrom(
            //           shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(10)),
            //           backgroundColor:
            //               Theme.of(context).colorScheme.primaryContainer,
            //           minimumSize: const Size(double.infinity, 50),
            //         ),
            //         onPressed: () {
            //           // if (_formLogin.currentState!.validate()) {
            //           //   authBloc.add(SignInRequestedEvent(
            //           //       userNameController.text,
            //           //       passwordController.text));
            //           // }
            //           context.pushNamed(resetPage);
            //         },
            //         child: ZmareText(
            //           text: "Continue",
            //           isBold: true,
            //           isSmall: true,
            //         )),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
