import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mountain/app/constants/theme.dart';
import 'package:mountain/app/controllers/auth_controller.dart';
import 'package:mountain/app/widgets/loading.dart';
import 'package:mountain/firebase_options.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(
      AuthController(),
      permanent: true,
    );
    return StreamBuilder(
      stream: authController.streamAuthStatus,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Mountain App",
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: MaterialColor(
                  AppTheme.primaryColor.value,
                  <int, Color>{
                    50: Color(AppTheme.primaryColor.value),
                    100: Color(AppTheme.primaryColor.value),
                    200: Color(AppTheme.primaryColor.value),
                    300: Color(AppTheme.primaryColor.value),
                    400: Color(AppTheme.primaryColor.value),
                    500: Color(AppTheme.primaryColor.value),
                    600: Color(AppTheme.primaryColor.value),
                    700: Color(AppTheme.primaryColor.value),
                    800: Color(AppTheme.primaryColor.value),
                    900: Color(AppTheme.primaryColor.value),
                  },
                ),
              ),
            ),
          );
        }
        return LoadingView();
      },
    );
  }
}
