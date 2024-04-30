import 'package:firebase_core/firebase_core.dart';
import 'package:flashcards/app/app_routes.dart';
import 'package:flashcards/app/locator.dart';
import 'package:flashcards/app/set_up_dialog_ui.dart';
import 'package:flashcards/app/set_up_snackbar_ui.dart';
import 'package:flashcards/firebase_options.dart';
import 'package:flashcards/shared/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked_services/stacked_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupLocator();
  setupSnackbarUi();
  setupDialogUi();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: StackedService.navigatorKey,
      debugShowCheckedModeBanner: false,
      routes: AppRouter.routes,
      initialRoute: AppRoutes.splash,
      theme: ThemeData(fontFamily: AppTextStyle.fontFamily),
    );
  }
}
