import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:game_shelf/routing/router.dart';
import 'package:game_shelf/ui/core/database/app_database.dart';
import 'package:game_shelf/ui/core/theme/app_theme.dart';
import 'package:game_shelf/ui/core/widgets/navigation_bar.dart';
import 'package:game_shelf/utils/api_client.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  ApiClient();
  final db = AppDatabase();

  await db.customSelect('SELECT 1').get();
  debugPrint('Drift database opened');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}

class MainScaffold extends StatelessWidget {
  final Widget child;
  final int selectedIndex;

  const MainScaffold({
    super.key,
    required this.child,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: child,
        bottomNavigationBar: CustomNavigationBar(selectedIndex: selectedIndex),
      ),
    );
  }
}
