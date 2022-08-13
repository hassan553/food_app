import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'view_model.dart/home/home_cubit.dart';
import 'widgets/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit()
            ..getPizzaData()
            ..getDessertData()
            ..getDrinkData()
            ..getPastaData()
            ..getSaladsData()
            ..getSaucesData()
            ..getSidesData()
            ..getTheme()
          ,
        ),
      ],
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: HomeCubit.get(context).isDark
                ? ThemeMode.dark
                : ThemeMode.light,
            darkTheme: AppTheme.darkTheme(),
            theme: AppTheme.lightTheme(),
            title: 'Yam Yam',
            home: OfflineBuilder(
              connectivityBuilder: (
                BuildContext context,
                ConnectivityResult connectivity,
                Widget child,
              ) {
                bool connected = connectivity != ConnectivityResult.none;

                if (connected) {
                  return const SplashView();
                } else {
                  return Scaffold(
                    body: SafeArea(
                      child: Image.asset(
                        'assets/no.jpeg',
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                }
              },
              child: const CircularProgressIndicator(color: Colors.red),
            ),
          );
        },
      ),
    );
  }
}
