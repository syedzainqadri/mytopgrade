
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:topgrade/routes/app_routes.dart';
import 'package:get/get.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.initial,
      getPages: AppRoutes.routes,
    );
  }
}

// class App extends StatelessWidget {
//   const App({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: Init.instance.initialize(),
//       builder: (context, AsyncSnapshot snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const SplashScreen();
//         } else {
//           //initScreen == 0 || initScreen == null ? "first" : isLogged != null ? "home" :  "/"
//           return const OnboardingScreen();
//         }
//       },
//     );
//   }
// }
