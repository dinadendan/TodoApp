import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/data/network/App_cubit.dart';
import 'package:todo_app/data/network/App_states.dart';

import '../data/network/component.dart';



class ArchivedTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder:(context,state){
        var tasks = AppCubit.get(context).archivedTasks;
        return tasksBuilder(

            tasks : tasks,
        );
      },
    );

  }
}
