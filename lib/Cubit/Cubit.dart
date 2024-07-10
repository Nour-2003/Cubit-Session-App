import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled5/Cubit/AppStates.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit(): super(InitialState());
  Database? db;
  List<Map> items = [];
  static AppCubit get(context) => BlocProvider.of(context);


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

  void insertToDatabase({required String title, required String description}) async {
    await db?.transaction((txn) async {
      try {
        await txn.rawInsert(
            'INSERT INTO tasks(title, description) VALUES(?, ?)',
            [title, description]);
        emit(InsertToDatabaseState());
        getDataFromDatabase(db);
        print('Inserted Successfully');
      } catch (error) {
        print('Error inserting into database: $error');
      }
    });
  }

  void getDataFromDatabase(database)  {
    emit(LoadingDataState());
    database?.rawQuery('SELECT * FROM tasks').then((value){
      items = value;
      emit(GetDataState());
    });
  }

   void deleteFromDatabase(int id) async {
    try {
      await db?.rawDelete('DELETE FROM tasks WHERE id = ?', [id]);
      getDataFromDatabase(db);
      emit(DeleteTaskState());
      print('Deleted Successfully');
    } catch (error) {
      print('Error deleting item: $error');
    }
  }
}