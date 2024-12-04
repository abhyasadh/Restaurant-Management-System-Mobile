import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/config/routes/app_routes.dart';
import 'package:restaurant_app/core/common/widgets/text_field/text_field.dart';
import 'package:restaurant_app/core/common/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import '../viewmodel/reset_view_model.dart';

class RecoverPasswordView extends ConsumerStatefulWidget {
  const RecoverPasswordView({super.key});

  @override
  ConsumerState createState() => _RecoverPasswordViewState();
}

class _RecoverPasswordViewState extends ConsumerState<RecoverPasswordView> {
  final passwordKey = GlobalKey<FormState>();
  final passwordController = TextEditingController(text: 'Reset123!');
  final passwordFocusNode = FocusNode();

  final confirmPasswordKey = GlobalKey<FormState>();
  final confirmPasswordController = TextEditingController(text: 'Reset123!');
  final confirmPasswordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
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
                          Navigator.of(context).pushNamed(AppRoutes.loginRoute);
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
                        'New Password!',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(
                        height: 4,
                        width: MediaQuery.of(context).size.width,
                      ),
                      Text(
                        'Enter new password for your account',
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
                      key: passwordKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          const requiredLength = 8;
                          final missingRequirements = <String>[];

                          if (value.length < requiredLength) {
                            final missingLength = requiredLength - value.length;
                            missingRequirements
                                .add('At least $missingLength more characters');
                          }

                          if (!RegExp(r'[A-Z]').hasMatch(value)) {
                            missingRequirements.add('An uppercase letter');
                          }
                          if (!RegExp(r'[a-z]').hasMatch(value)) {
                            missingRequirements.add('A lowercase letter');
                          }
                          if (!RegExp(r'[0-9]').hasMatch(value)) {
                            missingRequirements.add('A number');
                          }
                          if (!RegExp(r'[@$!%*?&]').hasMatch(value)) {
                            missingRequirements.add('A special character');
                          }

                          if (missingRequirements.isEmpty) {
                            return null;
                          } else {
                            return 'The password is missing:\n${missingRequirements.join(',\n')}';
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Form(
                      key: confirmPasswordKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: CustomTextField(
                        label: 'Confirm Password',
                        hintText: 'Confirm Password...',
                        icon: Icons.lock_outline_rounded,
                        controller: confirmPasswordController,
                        obscureText: true,
                        node: confirmPasswordFocusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password can\'t be empty!';
                          } else if (value != passwordController.text) {
                            return 'Passwords don\'t match!';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    CustomButton(
                        onPressed: () {
                          bool validated = true;
                          if (!passwordKey.currentState!.validate()) {
                            validated = false;
                          }
                          if (!confirmPasswordKey.currentState!.validate()) {
                            validated = false;
                          }
                          if (validated) {
                            ref
                                .read(resetViewModelProvider.notifier)
                                .updatePassword(passwordController.text,
                                    args['phone'], context);
                          }
                        },
                        child: const Text(
                          'CONFIRM',
                          style: TextStyle(
                            fontFamily: 'Blinker',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )),
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
