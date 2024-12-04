import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/features/auth/login/presentation/viewmodel/login_view_model.dart';

import '../../../../../config/routes/app_routes.dart';
import '../../../../../core/common/widgets/custom_button.dart';
import '../../../../../core/common/widgets/text_field/text_field.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final phoneKey = GlobalKey<FormState>();
  final phoneController = TextEditingController(text: "9860267909");
  final phoneFocusNode = FocusNode();

  final passwordKey = GlobalKey<FormState>();
  final passwordController = TextEditingController(text: "Adhikari1!");
  final passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    var authState = ref.watch(loginViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Text(
                'Welcome Back!',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                'Login to your account',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 34,
                    ),
                    Form(
                      key: phoneKey,
                      child: CustomTextField(
                        label: 'Phone',
                        hintText: 'Enter Your Phone Number...',
                        icon: Icons.local_phone_outlined,
                        controller: phoneController,
                        keyBoardType: TextInputType.phone,
                        node: phoneFocusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Phone number can\'t be empty!';
                          } else {
                            RegExp regex = RegExp(
                                r'^(\+\d{1,3}\s?)?1?-?\.?\s?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$');
                            if (!regex.hasMatch(value)) {
                              return 'Invalid phone number!';
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Form(
                      key: passwordKey,
                      child: CustomTextField(
                        label: 'Password',
                        hintText: 'Enter Your Password...',
                        icon: Icons.lock_outline_rounded,
                        controller: passwordController,
                        obscureText: true,
                        node: passwordFocusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password can\'t be empty!';
                          }
                          return null;
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 16,
                            ),
                            InkWell(
                              onTap: () {
                                ref
                                    .watch(loginViewModelProvider.notifier)
                                    .rememberMe();
                              },
                              child: Container(
                                width: 16.0,
                                height: 16.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.0),
                                  // Change the shape here
                                  border: Border.all(
                                    width: 2,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  color: authState.rememberMe!
                                      ? Theme.of(context).primaryColor
                                      : Colors.white.withOpacity(0),
                                ),
                                child: authState.rememberMe!
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 12.0,
                                      )
                                    : Container(),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Remember Me',
                              style: TextStyle(
                                fontFamily: 'Blinker',
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(AppRoutes.findAccountRoute);
                          },
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.all(16.0),
                            ),
                          ),
                          child: const Text(
                            'Recover Password',
                            style: TextStyle(
                              fontFamily: 'Blinker',
                              color: Color(0xff37B5DF),
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xff37B5DF),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            onPressed: () {
                              bool validated = true;
                              if (!phoneKey.currentState!.validate()) {
                                validated = false;
                              }
                              if (!passwordKey.currentState!.validate()) {
                                validated = false;
                              }
                              if (validated) {
                                ref.read(loginViewModelProvider.notifier).login(
                                    context,
                                    phoneController.text,
                                    passwordController.text);
                              }
                            },
                            child: authState.isLoading
                                ? const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 4),
                                    child: CircularProgressIndicator(),
                                  )
                                : const Text(
                                    'LOGIN',
                                    style: TextStyle(
                                      fontFamily: 'Blinker',
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        authState.biometric
                            ? const SizedBox(
                                width: 8,
                              )
                            : const SizedBox(),
                        authState.biometric
                            ? CustomButton(
                                onPressed: () {
                                    ref.read(loginViewModelProvider.notifier).authenticateWithBiometrics(context);
                                },
                                child: const Icon(
                                  Icons.fingerprint,
                                  size: 32,
                                  color: Colors.white,
                                ))
                            : const SizedBox(),
                      ],
                    ),
                    // const Row(
                    //   children: [
                    //     Expanded(
                    //       child: Divider(
                    //         thickness: 2,
                    //         color: Color(0xffcdcdcd),
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: EdgeInsets.symmetric(
                    //         horizontal: 20,
                    //         vertical: 30,
                    //       ),
                    //       child: Text(
                    //         'Or',
                    //         style: TextStyle(
                    //           fontFamily: 'Blinker',
                    //           fontSize: 16,
                    //           color: Color(0xffcdcdcd),
                    //         ),
                    //       ),
                    //     ),
                    //     Expanded(
                    //       child: Divider(
                    //         thickness: 2,
                    //         color: Color(0xffcdcdcd),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     SocialButton(
                    //         image: 'assets/images/google_icon.png',
                    //         onTap: () {}),
                    //     SocialButton(
                    //         image: 'assets/images/facebook_icon.png',
                    //         onTap: () {}),
                    //   ],
                    // ),
                    const NavigatorTextButton(
                      text: 'Don\'t have an account?',
                      buttonText: 'Sign Up',
                      route: AppRoutes.signupRoute,
                    )
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

class SocialButton extends StatelessWidget {
  const SocialButton({super.key, required this.image, required this.onTap});

  final String image;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            Theme.of(context).inputDecorationTheme.fillColor!),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        fixedSize: MaterialStateProperty.all(
            Size(MediaQuery.of(context).size.width / 2 - 38, 56)),
        elevation: MaterialStateProperty.all(0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Image.asset(image),
      ),
    );
  }
}
