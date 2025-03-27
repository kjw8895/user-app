import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/network/api_client.dart';
import 'features/auth/data/services/auth_service.dart';
import 'features/auth/data/services/terms_service.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/providers/sms_verification_provider.dart';
import 'features/auth/presentation/providers/terms_provider.dart';
import 'features/auth/presentation/screens/sign_in_screen.dart';
import 'features/auth/presentation/screens/sign_up_screen.dart';
import 'features/auth/presentation/screens/terms_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiClient>(
          create: (_) => ApiClient(),
        ),
        Provider<AuthService>(
          create: (context) => AuthService(
            apiClient: context.read<ApiClient>(),
          ),
        ),
        Provider<TermsService>(
          create: (context) => TermsService(
            apiClient: context.read<ApiClient>(),
          ),
        ),
        Provider<AuthRepository>(
          create: (context) => AuthRepository(
            context.read<AuthService>(),
          ),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(
            context.read<AuthRepository>(),
          ),
        ),
        ChangeNotifierProvider<SmsVerificationProvider>(
          create: (context) => SmsVerificationProvider(
            context.read<AuthRepository>(),
          ),
        ),
        ChangeNotifierProvider<TermsProvider>(
          create: (context) => TermsProvider(
            context.read<TermsService>(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Auth App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        home: const SignInScreen(),
        routes: {
          '/sign-up': (context) => const SignUpScreen(),
          '/terms': (context) => const TermsScreen(),
        },
      ),
    );
  }
}
