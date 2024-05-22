import 'package:hive/hive.dart';
import 'package:to_do_app/persistent/hive_constant.dart';

class HiveDAO {
  HiveDAO._();

  static final HiveDAO _singleton = HiveDAO._();

  factory HiveDAO() => _singleton;

  Box<List<String>> getTasksBox () => Hive.box<List<String>>(kTasksBox);


  //save data
  void saveTaskList (List<String> tasks) {
    getTasksBox().put(kTasksKey, tasks);
  }

  //get data

  List<String> get getTasksList => getTasksBox().get(kTasksKey) ?? []; 
}
