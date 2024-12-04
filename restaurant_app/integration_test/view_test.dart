import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gif_view/gif_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/config/routes/app_routes.dart';
import 'package:restaurant_app/core/common/widgets/text_field/text_field.dart';
import 'package:restaurant_app/core/failure/failure.dart';
import 'package:restaurant_app/features/auth/login/domain/usecase/login_usecase.dart';
import 'package:restaurant_app/features/auth/login/presentation/view/login_view.dart';
import 'package:restaurant_app/features/auth/register/domain/usecases/register_usecase.dart';
import 'package:restaurant_app/features/offers/offers_view.dart';
import 'package:restaurant_app/features/profile/presentation/view/profile_view.dart';

import '../test/auth_test.mocks.dart';

void main() {

  testWidgets('SplashView renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          initialRoute: AppRoutes.splashRoute,
          routes: AppRoutes.getApplicationRoute(),
        ),
      ),
    );

    expect(find.byType(GifView), findsOneWidget);
  });

  testWidgets('LoginView UI Test', (WidgetTester tester) async {
    var mockLoginUseCase = MockLoginUseCase();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          loginUseCaseProvider.overrideWith(
            (ref) => mockLoginUseCase,
          ),
        ],
        child: const MaterialApp(
          home: LoginView(),
        ),
      ),
    );

    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(find.text('Login to your account'), findsOneWidget);
    expect(find.text('Phone'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Remember Me'), findsOneWidget);
    expect(find.text('Recover Password'), findsOneWidget);
    expect(find.text('LOGIN'), findsOneWidget);

    when(mockLoginUseCase.login(any, any)).thenAnswer((_) async {
      return Left(Failure(error: "Test"));
    });

    await tester.enterText(find.byWidgetPredicate((widget) => widget is TextFormField).at(0), '9860267909');
    await tester.enterText(find.byWidgetPredicate((widget) => widget is TextFormField).at(1), 'Adhikari1!');
    await tester.tap(find.text('LOGIN'));
    await tester.pump();

    verify(mockLoginUseCase.login('9860267909', 'Adhikari1!')).called(1);
  });

  testWidgets('SignupView UI Test', (WidgetTester tester) async {
    var mockRegisterUseCase = MockRegisterUseCase();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          registerUseCaseProvider.overrideWith(
                (ref) => mockRegisterUseCase,
          ),
        ],
        child: MaterialApp(
          initialRoute: AppRoutes.signupRoute,
          routes: AppRoutes.getApplicationRoute(),
        ),
      ),
    );

    expect(find.text('Create an Account!'), findsOneWidget);
    expect(find.text('A different dining experience awaits'), findsOneWidget);
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Phone'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);
    expect(find.text('SIGN UP'), findsOneWidget);

    await tester.enterText(find.byWidgetPredicate((widget) => widget is TextFormField).at(0), 'Abhyas');
    await tester.enterText(find.byWidgetPredicate((widget) => widget is TextFormField).at(1), 'Adhikari');
    await tester.enterText(find.byWidgetPredicate((widget) => widget is TextFormField).at(2), '9841428095');
    await tester.enterText(find.byWidgetPredicate((widget) => widget is TextFormField).at(3), 'Adhikari1!');
    await tester.enterText(find.byWidgetPredicate((widget) => widget is TextFormField).at(4), 'Adhikari1!');
  });

  testWidgets('Offers UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: OffersView(),
        ),
      ),
    );
    expect(find.text('Sorry! We currently have no offers.'), findsOneWidget);
  });

  testWidgets('Find List of Text Form Fields Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ProfileView(),
        ),
      ),
    );

    final textFieldsFinder = find.byType(CustomTextField);
    final textFields = textFieldsFinder.evaluate().map((element) => element.widget).toList();

    for (var textField in textFields) {
      expect(textField, isInstanceOf<CustomTextField>());
    }
  });
}
