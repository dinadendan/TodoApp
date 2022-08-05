import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/data/network/App_states.dart';
import 'package:todo_app/data/network/component.dart';
import '../data/network/App_cubit.dart';

class DoTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder:(context,state){
        var tasks = AppCubit.get(context).doneTasks;
        return tasksBuilder(
            tasks : tasks,
        );
      },
    );
  }
}
