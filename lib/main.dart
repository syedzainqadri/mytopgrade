import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:topgrade/controllers/assignment_byID_controller.dart';
import 'package:topgrade/controllers/course_byId_controller.dart';
import 'package:topgrade/controllers/courses_controller.dart';
import 'package:topgrade/controllers/lesson_byId_controller.dart';
import 'package:topgrade/controllers/quiz_byID_controller.dart';
import 'package:topgrade/routes/app_routes.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(CoursesController());
  Get.put(CourseByIDController());
  Get.put(QuizByIDController());
  Get.put(AssignmentByIDController());
  Get.put(LessonByIDController());
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
