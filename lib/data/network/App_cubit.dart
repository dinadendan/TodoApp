import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/data/network/App_states.dart';
import 'package:todo_app/presentation/ArchivedTasksScreen.dart';

import 'Cache_helper.dart';
import '../../presentation/DoTasksScreen.dart';
import '../../presentation/NewTasksScreen.dart';

class AppCubit  extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialState()) ;
  static AppCubit get(context) => BlocProvider.of(context) ;
  int currentIndex = 0;

  List<Widget> screens = [
    const NewTasksScreen(),
    DoTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  void changeIndex(int index)
  {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  Database database;

  List<Map> newTasks =[];
  List<Map> doneTasks =[];
  List<Map> archivedTasks =[];

/// Create dataBase
  void createDatabase()
  {
    openDatabase(
      'Todo.db',
      version: 1,
      onCreate: (database,version) async
      {
        print('database create');
        await database.execute('CREATE TABLE tasks( id INTEGER PRIMARY KEY , title TEXT , date TEXT ,time TEXT ,status TEXT)');
        print('table create');
      },
      onOpen:(database)
      {
        getDataFromDataBase(database);
        print('database opened');
      },
    ).then((value)
  {
    database = value ;
    emit(AppCreateDatabaseState());
  });
  }
   insertDatabase({
    @required String title,
    @required String time,
    @required String date,
  }) async
  {
    await database.transaction((txn)
    {
      txn.rawInsert('INSERT INTO tasks(title ,date,time,status) VALUES ("$title" ,"$date","$time","new")',
      ).then((value){
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());
        getDataFromDataBase(database);
      }).catchError((error){
        print('error where insert new record ${error.toString()}');
      });
      return null;
    });
  }


  void getDataFromDataBase(database)
  {
    newTasks =[];
    doneTasks =[];
    archivedTasks =[];

    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value)
    {
      value.forEach((element) 
      {
        if(element['status']== 'new')
          newTasks.add(element);
        else if (element['status'] == 'done')
          doneTasks.add(element);
        else archivedTasks.add(element);
      });
      emit(AppGetDatabaseState());
    });
  }



  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

 void updateData ({
  @required String status ,
  @required int id ,
}) async
  {
    database.rawUpdate(
        'UPDATE Tasks SET status = ? WHERE id = ?',
        ['$status', '$id']
   ).then((value)
    {
      getDataFromDataBase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData ({
    @required int id ,
  }) async
  {
    database.rawDelete(
        'DELETE FROM tasks WHERE id = ?', ['id'],
    ).then((value)
    {
      getDataFromDataBase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  void changeBottomSheetState({
  @required bool isShow ,
  @required IconData icon,
})
  {
    isBottomSheetShown = isShow ;
    fabIcon = icon ;
    emit(AppChangeBottomNavBarState());
  }

  bool isDark =false ;
 void changeAppMode({bool fromShared })
 {
   if(fromShared != null)
   {
     isDark = fromShared;
     emit(AppChangeModeState());
   } else
     {
     isDark = !isDark ;
     CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value)
     {
     emit(AppChangeModeState());
     });
     }

 }
}