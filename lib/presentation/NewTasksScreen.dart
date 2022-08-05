import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/data/network/App_states.dart';
import 'package:todo_app/data/network/component.dart';

import '../data/network/App_cubit.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder:(context,state){
        var tasks = AppCubit.get(context).newTasks;
        return tasksBuilder(
          tasks : tasks,
        );
      },
    );
  }
}
