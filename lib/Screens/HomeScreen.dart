
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled5/Cubit/AppStates.dart';
import 'package:untitled5/Cubit/Cubit.dart';

import '../Widgets/dialog widget.dart';

class HomeScreen extends StatelessWidget {
  Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.indigo,
            title: Text('SQLite Demo',style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white
            ),),
          ),
          body: BlocConsumer<AppCubit,AppStates>(
    listener: (BuildContext context, AppStates state) {
      if (state is DeleteTaskState) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Task is Deleted",
            )));
      } else if (state is InsertToDatabaseState) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Task is Inserted",
            )));
      }
    },
    builder: (BuildContext context, AppStates state) {
      var items = AppCubit
          .get(context)
          .items;
      return ConditionalBuilder(
        condition: items.length > 0,
        fallback: (context) =>
            Center(
              child: CircularProgressIndicator(),
            ),
        builder: (context) =>
            ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(items[index]['id'].toString()),
                  direction: DismissDirection.horizontal,
                  onDismissed: (direction) {
                    AppCubit.get(context).deleteFromDatabase(
                        items[index]['id']);
                  },
                  child: Card(
                    elevation: 20,
                    color: Colors.indigo,
                    child: ListTile(
                      title: Text(items[index]['title'], style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),),
                      subtitle: Text(items[index]['description'],
                        style: TextStyle(
                          color: Colors.white,

                        ),),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.white,),
                        onPressed: () {
                          AppCubit.get(context).deleteFromDatabase(
                              items[index]['id']);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
      );
    }
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return BlocProvider.value(
                      value: AppCubit.get(context),
                      child: AddTaskDialog()
                  );
                },
              );
            },
            child: Icon(Icons.add),
          ),
        );
  }
}
