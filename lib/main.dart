import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'package:flutter/material.dart';

import "package:get_storage/get_storage.dart";
import 'package:todo_notify/db/db_helper.dart';
import 'package:todo_notify/services/notification_services.dart';
import 'package:todo_notify/services/theme_services.dart';
import 'package:todo_notify/ui/home_page.dart';
import 'package:todo_notify/ui/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  await GetStorage.init();
  NotifyHelper().initializeNotification();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale("pt", "BR")],
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,
      home: const HomePage(),
    );
  }
}
