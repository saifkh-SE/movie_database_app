import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:movie_database_app/cubit/loading_cubit.dart';
import 'package:movie_database_app/cubit/page_number_cubit.dart';
import 'package:movie_database_app/views/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PageNumberCubit>(
          create: (context) => PageNumberCubit(),
        ),
        BlocProvider<LoadingCubit>(
          create: (context) => LoadingCubit(),
        ),
      ],
      // create: (_) => PageNumberCubit(),
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return GetMaterialApp(
            home: SplashScreen(),
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: currentMode,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
