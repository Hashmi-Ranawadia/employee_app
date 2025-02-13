// class EmployeeModel {
//   int? id;
//   String? name;
//   String? role;
//   String? fromDate;
//   String? toDate;

//   EmployeeModel({this.id, this.name, this.role, this.fromDate, this.toDate});

//   EmployeeModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     role = json['role'];
//     fromDate = json['fromDate'];
//     toDate = json['toDate'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['role'] = this.role;
//     data['fromDate'] = this.fromDate;
//     data['toDate'] = this.toDate;
//     return data;
//   }
// }


import 'dart:convert';

class EmployeeModel {
  int? id;
  String name;
  String role;
  String fromDate;
  String toDate;

  EmployeeModel({
    this.id,
    required this.name,
    required this.role,
    required this.fromDate,
    required this.toDate,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      fromDate: json['fromDate'],
      toDate: json['toDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'fromDate': fromDate,
      'toDate': toDate,
    };
  }

  factory EmployeeModel.fromJsonString(String jsonString) {
    return EmployeeModel.fromJson(jsonDecode(jsonString));
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }
}
