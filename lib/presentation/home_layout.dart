import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/data/network/App_states.dart';
import 'package:todo_app/data/network/component.dart';

import '../data/network/App_cubit.dart';

class HomeLayout extends StatelessWidget
  {
  var scaffoldkey =GlobalKey<ScaffoldState>();
  var formkey =GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  HomeLayout({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  return BlocProvider(
    create: (BuildContext context) => AppCubit()..createDatabase(),
    child: BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context ,AppStates state ){
        if (state is AppInsertDatabaseState)
        {
          Navigator.pop(context);
        }
      },
      builder: (BuildContext context , AppStates state)
      {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          key: scaffoldkey,
          appBar: AppBar(
            title: Text(
             cubit.titles[cubit.currentIndex],
            ),
          ),
          body: ConditionalBuilder(
            condition: state is! AppGetDatabaseLoadingState,
            builder: (context) => cubit.screens[cubit.currentIndex],
            fallback: (context) => const Center(child: CircularProgressIndicator()),
            ),
          floatingActionButton:FloatingActionButton(
            onPressed: () async
            {
              if (cubit.isBottomSheetShown)
              {
                if(formkey.currentState.validate()){
                cubit.insertDatabase(
                    title: titleController.text,
                    time: timeController.text,
                    date: dateController.text,
                );
                }
              } else
              {
                scaffoldkey.currentState.showBottomSheet(
                      (context) =>Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: formkey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                          defaultFormField(
                            controller: titleController ,
                            type: TextInputType.text,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'Title must not be empty';
                              }
                              return null;
                            },
                            label: 'Task Title',
                            prefix: Icons.title ,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          defaultFormField(
                            controller: timeController ,
                            type: TextInputType.datetime,
                            onTap:(){
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((value)
                              {
                                timeController.text = value.format(context).toString();
                                print(value.format(context));
                              });
                            },
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'Time must not be empty';
                              }
                              return null;
                            },
                            label: 'Task Time',
                            prefix: Icons.watch_later_outlined ,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          defaultFormField(
                            controller: dateController ,
                            type: TextInputType.datetime,
                            onTap:(){
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.parse(''),
                              ).then((value)
                              {
                                dateController.text = DateFormat.yMMMd().format(value);
                                print(DateFormat.yMMMd().format(value));
                              });
                            },
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'Date must not be empty';
                              }
                              return null;
                            },
                            label: 'Task Date',
                            prefix: Icons.calendar_today ,
                          ),
                        ],
                      ),
                        ),
                      ),
                  elevation: 20,
                ).closed.then((value){
                  cubit.changeBottomSheetState(
                    isShow: false,
                    icon:Icons.edit,
                  );
                });
                cubit.changeBottomSheetState(
                    isShow: true,
                    icon: Icons.add,
                );
              }
            },
            child: Icon(
              cubit.fabIcon,
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex:cubit.currentIndex,
            onTap: (index)
            {
              cubit.changeIndex(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon : Icon(Icons.menu,),
                label: 'Tasks',
              ),
              BottomNavigationBarItem(
                icon : Icon(Icons.check_circle_outline,),
                label: 'Done',
              ),
              BottomNavigationBarItem(
                icon : Icon(Icons.archive_outlined,),
                label: 'Archived',
              ),
            ],
          ),
        );
      },
    ),
  );
  }
}