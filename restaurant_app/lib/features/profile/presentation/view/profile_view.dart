import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/core/common/messages/snackbar.dart';
import 'package:restaurant_app/core/common/provider/get_biometric_setting.dart';
import 'package:restaurant_app/core/common/provider/get_sensor_setting.dart';
import 'package:restaurant_app/core/common/provider/get_theme.dart';
import 'package:restaurant_app/features/auth/login/domain/usecase/login_usecase.dart';
import 'package:restaurant_app/features/auth/reset_password/data/data_source/reset_remote_data_source.dart';
import 'package:restaurant_app/features/home/home_view_model.dart';
import 'package:restaurant_app/features/profile/presentation/viewmodel/profile_view_model.dart';

import '../../../../core/common/widgets/text_field/text_field.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  late bool isDark;
  late bool isSensorUsed;
  late bool isBiometricUsed;

  @override
  void initState() {
    isDark = ref.read(getThemeProvider);
    isSensorUsed = ref.read(getSensorSettingProvider);
    isBiometricUsed = ref.read(getBiometricSettingProvider);
    super.initState();
  }

  _gap(double height) => SizedBox(
        height: height,
      );

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'App Preferences',
                  style: TextStyle(
                      fontFamily: 'Blinker',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor),
                ),
              ),
              _gap(10),
              ListTile(
                title: const Text(
                  'Dark Theme',
                  style: TextStyle(
                    fontFamily: 'Blinker',
                    fontSize: 18,
                  ),
                ),
                contentPadding: const EdgeInsets.only(
                    top: 4, bottom: 4, left: 18, right: 14),
                tileColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(18.0), // Adjust the value as needed
                ),
                trailing: Switch(
                  activeColor: Theme.of(context).primaryColor,
                  value: isDark,
                  onChanged: (value) {
                    setState(() {
                      isDark = value;
                      ref.read(getThemeProvider.notifier).updateTheme(value);
                    });
                  },
                ),
              ),
              _gap(20),
              ListTile(
                title: const Text(
                  'Shake to Clear Orders',
                  style: TextStyle(
                    fontFamily: 'Blinker',
                    fontSize: 18,
                  ),
                ),
                contentPadding: const EdgeInsets.only(
                    top: 4, bottom: 4, left: 18, right: 14),
                tileColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(18.0), // Adjust the value as needed
                ),
                trailing: Switch(
                  activeColor: Theme.of(context).primaryColor,
                  value: isSensorUsed,
                  onChanged: (value) {
                    setState(() {
                      isSensorUsed = value;
                      ref
                          .read(getSensorSettingProvider.notifier)
                          .updateSensorSetting(value);
                    });
                  },
                ),
              ),
              _gap(20),
              ListTile(
                title: const Text(
                  'Biometric Login',
                  style: TextStyle(
                    fontFamily: 'Blinker',
                    fontSize: 18,
                  ),
                ),
                contentPadding: const EdgeInsets.only(
                    top: 4, bottom: 4, left: 18, right: 14),
                tileColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(18.0), // Adjust the value as needed
                ),
                trailing: Switch(
                  activeColor: Theme.of(context).primaryColor,
                  value: isBiometricUsed,
                  onChanged: (value) {
                    if (value && state.canCheckBiometrics) {
                      final phoneKey = GlobalKey<FormState>();
                      final phoneController =
                          TextEditingController(text: "9860267909");
                      final phoneFocusNode = FocusNode();

                      final passwordKey = GlobalKey<FormState>();
                      final passwordController =
                          TextEditingController(text: "Adhikari1!");
                      final passwordFocusNode = FocusNode();

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              titlePadding: EdgeInsets.zero,
                              actionsPadding: const EdgeInsets.only(bottom: 14),
                              actionsAlignment: MainAxisAlignment.spaceEvenly,
                              clipBehavior: Clip.hardEdge,
                              shadowColor:
                                  Theme.of(context).colorScheme.tertiary,
                              title: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                ),
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 18),
                                child: Text(
                                  'Confirmation',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontFamily: 'Blinker',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 14,
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
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                        fontFamily: 'Blinker',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    final result = await ref
                                        .read(loginUseCaseProvider)
                                        .login(phoneController.text,
                                            passwordController.text);
                                    result.fold((l) {
                                      setState(() {
                                        isBiometricUsed = false;
                                        showSnackBar(
                                            message: 'Biometric Setup Failed!',
                                            context: context,
                                            error: true);
                                      });
                                      Navigator.of(context).pop();
                                    }, (r) {
                                      setState(() {
                                        isBiometricUsed = true;
                                        ref
                                            .read(getBiometricSettingProvider
                                                .notifier)
                                            .updateBiometricSetting([
                                          'true',
                                          phoneController.text,
                                          passwordController.text
                                        ]);
                                      });
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  child: Text(
                                    'Proceed',
                                    style: TextStyle(
                                      fontFamily: 'Blinker',
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ]
                          );
                        },
                      );
                    } else if (!state.canCheckBiometrics) {
                      showSnackBar(
                          message: 'An error occurred!',
                          context: context,
                          error: true);
                    } else {
                      setState(() {
                        isBiometricUsed = false;
                      });
                      ref
                          .read(getBiometricSettingProvider.notifier)
                          .updateBiometricSetting(['false']);
                    }
                  },
                ),
              ),
              _gap(20),
              const Divider(
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Account Settings',
                  style: TextStyle(
                      fontFamily: 'Blinker',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor),
                ),
              ),
              _gap(10),
              ListTile(
                  title: const Text(
                    'Change Password',
                    style: TextStyle(
                      fontFamily: 'Blinker',
                      fontSize: 18,
                    ),
                  ),
                  contentPadding: const EdgeInsets.only(
                      top: 4, bottom: 4, left: 18, right: 14),
                  tileColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        18.0), // Adjust the value as needed
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  onTap: () {
                    final oldPasswordKey = GlobalKey<FormState>();
                    final oldPasswordController =
                        TextEditingController(text: "12345678");
                    final oldPasswordFocusNode = FocusNode();

                    final newPasswordKey = GlobalKey<FormState>();
                    final newPasswordController =
                        TextEditingController(text: "Adhikari1!");
                    final newPasswordFocusNode = FocusNode();

                    final confirmPasswordKey = GlobalKey<FormState>();
                    final confirmPasswordController =
                        TextEditingController(text: "Adhikari1!");
                    final confirmPasswordFocusNode = FocusNode();

                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              titlePadding: EdgeInsets.zero,
                              actionsPadding: const EdgeInsets.only(bottom: 14),
                              actionsAlignment: MainAxisAlignment.spaceEvenly,
                              clipBehavior: Clip.hardEdge,
                              shadowColor:
                                  Theme.of(context).colorScheme.tertiary,
                              title: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                ),
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 18),
                                child: Text(
                                  'Change Password',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontFamily: 'Blinker',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 14,
                                    ),
                                    Form(
                                      key: oldPasswordKey,
                                      child: CustomTextField(
                                        label: 'Current Password',
                                        hintText: 'Enter Current Password...',
                                        icon: Icons.lock_outline_rounded,
                                        controller: oldPasswordController,
                                        obscureText: true,
                                        node: oldPasswordFocusNode,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Old password can\'t be empty!';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Form(
                                      key: newPasswordKey,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      child: CustomTextField(
                                        label: 'New Password',
                                        hintText: 'Enter New Password...',
                                        icon: Icons.lock_outline_rounded,
                                        controller: newPasswordController,
                                        obscureText: true,
                                        node: newPasswordFocusNode,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Password can\'t be empty!';
                                          }
                                          const requiredLength = 8;
                                          final missingRequirements =
                                              <String>[];

                                          if (value.length < requiredLength) {
                                            final missingLength =
                                                requiredLength - value.length;
                                            missingRequirements.add(
                                                'At least $missingLength more characters');
                                          }

                                          if (!RegExp(r'[A-Z]')
                                              .hasMatch(value)) {
                                            missingRequirements
                                                .add('An uppercase letter');
                                          }
                                          if (!RegExp(r'[a-z]')
                                              .hasMatch(value)) {
                                            missingRequirements
                                                .add('A lowercase letter');
                                          }
                                          if (!RegExp(r'[0-9]')
                                              .hasMatch(value)) {
                                            missingRequirements.add('A number');
                                          }
                                          if (!RegExp(r'[@$!%*?&]')
                                              .hasMatch(value)) {
                                            missingRequirements
                                                .add('A special character');
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
                                          } else if (value !=
                                              newPasswordController.text) {
                                            return 'Passwords don\'t match!';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                        fontFamily: 'Blinker',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    final result = await ref
                                        .read(loginUseCaseProvider)
                                        .login(
                                            ref
                                                .read(homeViewModelProvider)
                                                .userData[3]!,
                                            oldPasswordController.text);
                                    result.fold((l) {
                                      showSnackBar(
                                          message: 'Invalid Password!',
                                          context: context,
                                          error: true);
                                      Navigator.of(context).pop();
                                    }, (r) {
                                      ref
                                          .read(resetRemoteDataSourceProvider)
                                          .resetPassword(
                                              ref
                                                  .read(homeViewModelProvider)
                                                  .userData[3]!,
                                              newPasswordController.text)
                                          .then(
                                            (value) => value.fold(
                                              (l) {
                                                showSnackBar(
                                                    message:
                                                        "Something went wrong!",
                                                    context: context);
                                                Navigator.of(context).pop();
                                              },
                                              (r) {
                                                showSnackBar(
                                                    message:
                                                        "Password changed successfully!",
                                                    context: context);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          );
                                    });
                                  },
                                  child: Text(
                                    'Proceed',
                                    style: TextStyle(
                                      fontFamily: 'Blinker',
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ]);
                        });
                  }),
              _gap(20),
              ListTile(
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    fontFamily: 'Blinker',
                    fontSize: 18,
                  ),
                ),
                contentPadding: const EdgeInsets.only(
                    top: 4, bottom: 4, left: 18, right: 14),
                tileColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(18.0), // Adjust the value as needed
                ),
                trailing: const Icon(Icons.logout_rounded),
                onTap: () {
                  ref.read(profileViewModelProvider.notifier).logout(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
