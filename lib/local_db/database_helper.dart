import 'package:assignment_employee_app/model/employee_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class DatabaseHelper {
//   Database? _db;

//   Future<Database?> get db async {
//     if (_db != null) {
//       return _db;
//     }
//     return await initDb();
//   }

//   initDb() async {
//     io.Directory directory = await getApplicationDocumentsDirectory();
//     final path = join(directory.path, "employee.db");
//     final db = await openDatabase(path, version: 1, onCreate: _create);
//     return db;
//   }

//   _create(Database db, int version) async {
//     await db.execute(
//         'CREATE TABLE AddEmployee (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, role TEXT NOT NULL, fromDate TEXT NOT NULL, toDate TEXT NOT NULL)');
//   }

//   Future<EmployeeModel> insertData(EmployeeModel employeeModel) async {
//     var dbClient = await db;
//     await dbClient!.insert("AddEmployee", employeeModel.toJson());
//     return employeeModel;
//   }

//   Future<List<EmployeeModel>> readData() async {
//     var dbClient = await db;
//     List<EmployeeModel> employeeModel = [];
//     var data = await dbClient!.query("AddEmployee", orderBy: "id DESC");
//     for(var allData in data){
//       employeeModel.add(EmployeeModel.fromJson(allData));
//     }
//     return employeeModel;
//   }

//   Future updateData(EmployeeModel employeeModel) async {
//     var dbClient = await db;
//     await dbClient!.update("AddEmployee", employeeModel.toJson(),
//         where: "id=?", whereArgs: [employeeModel.id]);
//   }

//   Future<int> deleteData(int id) async {
//     var dbClient = await db;
//     return await dbClient!.delete("AddEmployee", where: "id=?", whereArgs: [id]);
//   }
// }


class DatabaseHelper {
  static const String _storageKey = "employees";

  /// Insert Employee Data
  Future<EmployeeModel> insertData(EmployeeModel employeeModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> employees = prefs.getStringList(_storageKey) ?? [];

    // Assign ID (Auto-Increment)
    employeeModel.id = employees.length + 1;

    employees.add(employeeModel.toJsonString());
    await prefs.setStringList(_storageKey, employees);
    return employeeModel;
  }

  /// Read All Employee Data
  Future<List<EmployeeModel>> readData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> employees = prefs.getStringList(_storageKey) ?? [];

    return employees.map((e) => EmployeeModel.fromJsonString(e)).toList();
  }

  /// Update Employee Data
  Future<void> updateData(EmployeeModel employeeModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> employees = prefs.getStringList(_storageKey) ?? [];

    for (int i = 0; i < employees.length; i++) {
      EmployeeModel emp = EmployeeModel.fromJsonString(employees[i]);
      if (emp.id == employeeModel.id) {
        employees[i] = employeeModel.toJsonString(); // Update record
        break;
      }
    }

    await prefs.setStringList(_storageKey, employees);
  }

  /// Delete Employee Data
  Future<int> deleteData(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> employees = prefs.getStringList(_storageKey) ?? [];

    employees.removeWhere((e) => EmployeeModel.fromJsonString(e).id == id);

    await prefs.setStringList(_storageKey, employees);
    return 1; // Return success
  }
}