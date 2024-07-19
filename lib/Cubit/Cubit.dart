import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled5/Cubit/AppStates.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit():super(InitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  Database? db;
  List<Map> items = [];
  void createDatabase()  {
    openDatabase(
      'todo.db',
      onCreate: (db, version) {
        print("Database is created");
        db
            .execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, description TEXT)')
            .then((value) {
          print("Table is created");
        }).catchError((error) {
          print("Error when creating table: $error");
        });
      },
      onOpen: (db) {
        getDataFromDatabase(db);
        print("Database is opened");
      },
      version: 1,
    ).then((value){
      db = value;
      emit(CreateDatabaseState());
    });
  }

  void insertToDatabase({required String title, required String description}) {
    db?.rawInsert(
        'INSERT INTO tasks(title, description) VALUES(?, ?)',
        [title, description]).then((value){
      print('Inserted Successfully');
      emit(InsertToDatabaseState());
      getDataFromDatabase(db);
    }).catchError((error){
      print('Error inserting item: $error');
    });
  }

  void getDataFromDatabase(database)  {
    emit(LoadingDataState());
    database?.rawQuery('SELECT * FROM tasks').then((value){
      items = value;
      emit(GetDataState());
    }).catchError((error){
      print('Error getting data: $error');
    });
  }

  void deleteFromDatabase(int id)  {
    db?.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value){
      emit(DeleteTaskState());
      getDataFromDatabase(db);
      print('Deleted Successfully');
    }
    ).catchError((error){
      print("Error deleting item: $error ");
    });
  }
}