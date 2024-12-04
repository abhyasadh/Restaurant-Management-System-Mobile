import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/core/common/widgets/text_field/text_field.dart';
import 'package:restaurant_app/config/routes/app_routes.dart';
import 'package:flutter/material.dart';

import 'package:restaurant_app/features/auth/otp/presentation/viewmodel/otp_view_model.dart';

import '../../../register/presentation/viewmodel/register_view_model.dart';

class OTPView extends ConsumerStatefulWidget {
  const OTPView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OTPViewState();
}

class _OTPViewState extends ConsumerState<OTPView> {
  final otpKey = GlobalKey<FormState>();
  final otpController = TextEditingController();
  final otpNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final otpState = ref.watch(otpViewModelProvider);

    final Map<String, dynamic> args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Stack(
                children: [
                  Positioned(
                    left: 18,
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 20,
                          color: Theme.of(context).primaryColor,
                        )),
                  ),
                  Column(
                    children: [
                      Text(
                        'Enter the OTP!',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(
                        height: 4,
                        width: MediaQuery.of(context).size.width,
                      ),
                      Text(
                        args['nextRoute'] == AppRoutes.loginRoute
                            ? 'OTP was sent to ${args['user'].phone}'
                            : 'OTP was sent to ${args['phone']}',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 34,
                    ),
                    Form(
                      key: otpKey,
                      child: CustomTextField(
                          label: 'OTP',
                          hintText: 'Enter the OTP...',
                          icon: Icons.phone_android_outlined,
                          controller: otpController,
                          node: otpNode,
                          keyBoardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Invalid OTP!';
                            }
                            return null;
                          }),
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    InkWell(
                      onTap: () {
                        otpState.copyWith(isLoading: true);
                        if (otpKey.currentState!.validate()) {
                          if (args['nextRoute'] == AppRoutes.loginRoute) {
                            ref.read(otpViewModelProvider.notifier).verifyOTP(
                                otp: otpController.text,
                                context: context,
                                args: args,
                                addUser: () => {
                                      ref
                                          .read(registerViewModelProvider
                                              .notifier)
                                          .register(args['user'], context)
                                    });
                          } else {
                            ref.read(otpViewModelProvider.notifier).verifyOTP(
                                  otp: otpController.text,
                                  context: context,
                                  args: args,
                                  number:
                                      args['nextRoute'] == AppRoutes.loginRoute
                                          ? args['user'].phone
                                          : args['phone'],
                                );
                          }
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x66ff6c44),
                              spreadRadius: 8,
                              blurRadius: 14,
                            ),
                          ],
                        ),
                        child: otpState.isLoading
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 4),
                                child: CircularProgressIndicator())
                            : const Text(
                                'CONFIRM',
                                style: TextStyle(
                                  fontFamily: 'Blinker',
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Didn\'t receive an OTP?',
                            style: TextStyle(
                              fontFamily: 'Blinker',
                            ),
                          ),
                          TextButton(
                            onPressed: otpState.isResendButtonDisabled!
                                ? null
                                : () {
                                    ref
                                        .read(otpViewModelProvider.notifier)
                                        .resetTimer();
                                    ref
                                        .read(otpViewModelProvider.notifier)
                                        .startCountdownTimer();
                                  },
                            style: ButtonStyle(
                              minimumSize:
                                  WidgetStateProperty.all(const Size(1, 1)),
                            ),
                            child: Text(
                              otpState.isResendButtonDisabled!
                                  ? 'Resend in ${otpState.timerCountDown} s'
                                  : 'Resend',
                              style: TextStyle(
                                fontFamily: 'Blinker',
                                color: otpState.isResendButtonDisabled!
                                    ? Colors.grey
                                    : const Color(0xff37B5DF),
                                decoration: otpState.isResendButtonDisabled!
                                    ? TextDecoration.none
                                    : TextDecoration.underline,
                                fontWeight: FontWeight.w600,
                                decorationColor: const Color(0xff37B5DF),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
