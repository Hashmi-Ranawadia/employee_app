import 'package:assignment_employee_app/model/employee_model.dart';

abstract class AppState {}

class InitialState extends AppState {}

class GridState extends AppState {
  bool isGrid;
  GridState(this.isGrid);
}

class LoadingState extends AppState {}

class ErrorState extends AppState {
  String errorMessage;
  ErrorState(this.errorMessage);
}

class SuccessState extends AppState {
  String successMessage;
  SuccessState(this.successMessage);
}

class ResponseState extends AppState {
  List<EmployeeModel> data  = [];
  ResponseState(this.data);
}

