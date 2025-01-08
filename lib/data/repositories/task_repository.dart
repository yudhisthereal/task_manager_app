import 'package:task_manager_app/data/local/database_helper.dart';
import 'package:task_manager_app/data/models/task.dart';

class TaskRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> addTask(Task task) => _databaseHelper.insertTask(task);
  
  Future<List<Task>> fetchUserTasks(int userId) => _databaseHelper.getTasksByUser(userId);

  Future<int> updateTask(Task task) => _databaseHelper.updateTask(task);

  Future<int> removeTask(int id, int userId) => _databaseHelper.deleteTask(id, userId);
}