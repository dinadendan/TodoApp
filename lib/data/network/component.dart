import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/data/network/App_cubit.dart';

Widget defaultButton(
{
  Color background =Colors.blue ,
  double width = double.infinity,
  bool isUpperCase = true,
  double radius = 5 ,
  @required Function function,
  @required String text ,

}) => Container(
      width: width,
      height: 40,
      child: MaterialButton(
    onPressed: function,
    child: Text(
     isUpperCase ? text.toUpperCase() : text ,
      style: TextStyle(
      color: Colors.white,
    ),
    ),
  ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,

      ),
);
Widget defaultTextButton({
  @required Function function,
  @required String text,
}) => TextButton(
    onPressed: function,
    child: Text(
      text.toUpperCase(),
    ),

);

Widget defaultFormField ({
  cursorColor,
  @required TextEditingController controller,
  @required TextInputType type,
  Function onSubmit ,
  Function onChange ,
  Function onTap ,
  Function suffixPressed,
  bool isPassword = false ,
  bool isClickable = true,
  @required Function validate ,
  @required String label ,
  @required IconData prefix ,
  IconData suffix ,
}) =>
    TextFormField(
      controller: controller,
  keyboardType: type ,
  enabled: isClickable,
  onFieldSubmitted: onSubmit ,
  onChanged: onChange,
  onTap: onTap ,
  validator: validate,
  obscureText: isPassword ,
  decoration: InputDecoration(
    labelText: label,
  prefixIcon: Icon(prefix),
  suffixIcon: suffix != null
      ? IconButton(
    onPressed: suffixPressed,
    icon: Icon(
      suffix,
    ),
  )
      : null,
  border: OutlineInputBorder(),
  ),

);

Widget buildTaskItem(Map model,context) => Dismissible(
  key: Key(model['id'].toString()),
  child: Padding(padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 40,
          child: Text(
            '${model['time']}',
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${model['title']}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,

                ),
              ),
              Text('${model['date']}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,

                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 20,
        ),
        IconButton(
            onPressed:()
            {
              AppCubit.get(context).updateData(
                  status: 'done',
                  id: model['id'],
              );
              },
            icon: Icon(
              Icons.playlist_add_check,
              size: 40,
              color: Colors.blue,
            ),
        ),
        IconButton(
          onPressed:()
          {
              AppCubit.get(context).updateData(
                status: 'archived',
                id: model['id'],
              );
          },
          icon: Icon(
            Icons.archive,
            color: Colors.black45,
            size: 30,
          ),
        ),

      ],
  ),
),
  onDismissed: (direction)
  {
    AppCubit.get(context).deleteData(id:model['id']);
  },
);

Widget tasksBuilder({
  @required List<Map> tasks,
})=>ConditionalBuilder(
  condition: tasks.length > 0,
  builder: (context)=> ListView.separated(
    itemBuilder:(context,index) => buildTaskItem(tasks[index] ,context),
    separatorBuilder: (context,index) => myDriver(),
    itemCount: tasks.length,
  ),
  fallback: (context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
          size: 100,
          color: Colors.grey,
        ),
        Text(
          'No Tasks Yet ,Please Add Some Tasks ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  ),
);

Widget myDriver() =>  Padding(
  padding: const EdgeInsetsDirectional.only(
    start: 20,
  ),
  child: Container(
    width: double.infinity,
    height: 1,
    color: Colors.grey[300],
  ),
);



void navigateTo(context ,widget) => Navigator.push(
  context,
  MaterialPageRoute(
  builder:(context )=> widget,
  ),
);

void navigateAndFinish(context ,widget) => Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder:(context )=> widget,
  ),
    (Route<dynamic> route) => false,
);




