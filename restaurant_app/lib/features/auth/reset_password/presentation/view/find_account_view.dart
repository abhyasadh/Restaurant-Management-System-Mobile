import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/core/common/widgets/text_field/text_field.dart';
import 'package:restaurant_app/core/common/widgets/custom_button.dart';
import 'package:restaurant_app/config/routes/app_routes.dart';
import 'package:flutter/material.dart';

import '../viewmodel/reset_view_model.dart';

class FindAccountView extends ConsumerStatefulWidget {
  const FindAccountView({super.key});

  @override
  ConsumerState createState() => _FindAccountViewState();
}

class _FindAccountViewState extends ConsumerState<FindAccountView> {
  final phoneKey = GlobalKey<FormState>();
  final phoneController = TextEditingController(text: '9812345678');
  final phoneFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final resetState = ref.watch(resetViewModelProvider);

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
                        'Forgot Password?',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(
                        height: 4,
                        width: MediaQuery.of(context).size.width,
                      ),
                      Text(
                        'OTP will be sent to your phone!',
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
                      height: 36,
                    ),
                    CustomButton(
                        onPressed: () {
                          if (phoneKey.currentState!.validate()) {
                            ref
                                .read(resetViewModelProvider.notifier)
                                .sendOTP(phoneController.text, context);
                          }
                        },
                        child: resetState.isLoading
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 4),
                                child: CircularProgressIndicator())
                            : const Text(
                                'SEND OTP',
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
