import 'package:assignment_employee_app/bloc/app_cubit.dart';
import 'package:assignment_employee_app/responsive/responsive_layout.dart';
import 'package:assignment_employee_app/screens/mobile_screen_layout/view_employees.dart';
import 'package:assignment_employee_app/screens/web_screen_layout/web_view_employees.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ResponsiveLayout(mobileScreenLayout: ViewEmployees(), webScreenLayout: WebViewEmployees()),
      ),
    );
  }
}