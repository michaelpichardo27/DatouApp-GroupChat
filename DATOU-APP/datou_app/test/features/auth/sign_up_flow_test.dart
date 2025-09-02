import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:datou_app/features/auth/ui/login_screen.dart';
import 'package:datou_app/features/auth/ui/sign_up_screen.dart';

void main() {
  group('Auth UI Tests', () {
    testWidgets('Login screen shows all required elements', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify login screen elements
      expect(find.text('Log In'), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.text('Continue as Guest'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Forgot Password'), findsOneWidget);
    });

    testWidgets('Sign up screen shows all required elements', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SignUpScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify sign up screen elements
      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.text('Log In'), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);
    });

    testWidgets('Login form has proper field types', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check for form fields
      expect(find.byType(TextField), findsAtLeastNWidgets(2));
      
      // Check for buttons (using Material widgets since they're custom buttons)
      expect(find.byType(Material), findsAtLeastNWidgets(3));
    });
  });
}