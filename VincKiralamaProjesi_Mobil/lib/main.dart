import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vinc_kiralama/core/theme/app_theme.dart';
import 'package:vinc_kiralama/presentation/router/app_router.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  try {
    print("🚀 STARTING APP...");
    WidgetsFlutterBinding.ensureInitialized();
    print("✅ WidgetsFlutterBinding Initialized");
    
    await dotenv.load(fileName: ".env");
    print("✅ DotEnv Loaded: ${dotenv.env['API_URL']}");
    
    runApp(const ProviderScope(child: MyApp()));
    print("✅ runApp called");
  } catch (e, stack) {
    print("🔥 FATAL ERROR IN MAIN: $e");
    print(stack);
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'VincKiralama',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
