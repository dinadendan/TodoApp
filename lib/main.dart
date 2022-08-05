import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/data/network/bloc_observer.dart';
import 'package:todo_app/presentation/home_layout.dart';
import 'data/network/Cache_helper.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await CacheHelper.init();

  Bloc.observer = MyBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
}

