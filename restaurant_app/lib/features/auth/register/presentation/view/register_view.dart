import 'package:restaurant_app/core/common/widgets/custom_button.dart';
import 'package:restaurant_app/config/routes/app_routes.dart';
import 'package:restaurant_app/core/common/widgets/text_field/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/features/auth/register/domain/entity/register_entity.dart';

import '../viewmodel/register_view_model.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupViewState();
}

class _SignupViewState extends ConsumerState<RegisterView> {
  final nameKey = GlobalKey<FormState>();
  final nameController = TextEditingController(text: "Abhyas");
  final nameFocusNode = FocusNode();

  final surnameKey = GlobalKey<FormState>();
  final surnameController = TextEditingController(text: "Adhikari");
  final surnameFocusNode = FocusNode();

  final phoneKey = GlobalKey<FormState>();
  final phoneController = TextEditingController(text: "9812345678");
  final phoneFocusNode = FocusNode();

  final passwordKey = GlobalKey<FormState>();
  final passwordController = TextEditingController(text: "Phone123!");
  final passwordFocusNode = FocusNode();

  final confirmPasswordKey = GlobalKey<FormState>();
  final confirmPasswordController = TextEditingController(text: "Phone123!");
  final confirmPasswordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(registerViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Text(
                'Create an Account!',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                'A different dining experience awaits',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 34,
                    ),
                    Row(
                      children: [
                        Form(
                          key: nameKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Expanded(
                            child: CustomTextField(
                                label: 'Name',
                                hintText: 'First Name...',
                                icon: Icons.person_2_outlined,
                                controller: nameController,
                                node: nameFocusNode,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Name can\'t be empty!';
                                  }
                                  return null;
                                }),
                          ),
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        Form(
                          key: surnameKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Expanded(
                            child: CustomTextField(
                                label: ' ',
                                hintText: 'Last Name...',
                                icon: Icons.person_2_outlined,
                                controller: surnameController,
                                node: surnameFocusNode,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Name can\'t be empty!';
                                  }
                                  return null;
                                }),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Form(
                      key: phoneKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: CustomTextField(
                        label: 'Phone',
                        hintText: 'Enter Your Phone Number...',
                        icon: Icons.local_phone_outlined,
                        controller: phoneController,
                        keyBoardType: TextInputType.phone,
                        node: phoneFocusNode,
                        obscureText: false,
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
                        if (!nameKey.currentState!.validate()) {
                          validated = false;
                        }
                        if (!surnameKey.currentState!.validate()) {
                          validated = false;
                        }
                        if (!phoneKey.currentState!.validate()) {
                          validated = false;
                        }
                        if (!passwordKey.currentState!.validate()) {
                          validated = false;
                        }
                        if (!confirmPasswordKey.currentState!.validate()) {
                          validated = false;
                        }
                        if (validated) {
                          RegisterEntity user = RegisterEntity(
                            firstName: nameController.text,
                            lastName: surnameController.text,
                            phone: phoneController.text,
                            password: passwordController.text,
                          );

                          ref
                              .read(registerViewModelProvider.notifier)
                              .sendOTP(phoneController.text, context, user);
                        }
                      },
                      child: !authState.isLoading
                          ? const Text(
                              'SIGN UP',
                              style: TextStyle(
                                fontFamily: 'Blinker',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          : const Padding(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              child: CircularProgressIndicator()),
                    ),
                    const NavigatorTextButton(
                        text: 'Already have an account?',
                        buttonText: 'Login',
                        route: AppRoutes.loginRoute)
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              )
            ],
          ),
        ),
      ),
    );
  }
}
