import 'dart:math';

import 'package:assignment_employee_app/bloc/app_state.dart';
import 'package:assignment_employee_app/local_db/database_helper.dart';
import 'package:assignment_employee_app/model/employee_model.dart';
import 'package:assignment_employee_app/screens/mobile_screen_layout/view_employees.dart';
import 'package:assignment_employee_app/screens/web_screen_layout/web_view_employees.dart';
import 'package:assignment_employee_app/utils/app_colors.dart';
import 'package:assignment_employee_app/widgets/datepicker_option_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(InitialState());

  bool isGrid = true;
  TextEditingController nameC = TextEditingController();
  TextEditingController selectRoleC = TextEditingController();
  TextEditingController toDateC = TextEditingController();
  TextEditingController fromDateC = TextEditingController();

  final key = GlobalKey<FormState>();
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<EmployeeModel> employeeModel = [];

  // final List<Color> colorIndexList = [];
  var deletedIndex;

  List<String> roleList = [
    "Product Designer",
    "Flutter Developer",
    "QA Tester",
    "Product Owner"
  ];

  late DateTime selectedDate;
  DateTime? selectedNoDate;

  late DateTime focusedDay;
  String selectedButton = "Today";
  String selectedNoDateButton = "No Date";
  bool toDate = false, fromDate = false;

  void _setDate(DateTime date, String buttonName) {
    selectedDate = date;
    selectedButton = buttonName;
    emit(SuccessState(selectedDate.toString()));
  }

  void _setNoDate(DateTime? date, String buttonName) {
    if (date == null) {
      selectedNoDate = null;
      toDateC.text = "No Date";
      selectedNoDateButton = buttonName;
    } else {
      selectedNoDate = date;
      selectedNoDateButton = buttonName;
    }
    emit(SuccessState(selectedNoDate.toString()));
  }

  DateTime getNextMonday() {
    int daysUntilMonday = DateTime.monday - selectedDate.weekday;
    return selectedDate.add(Duration(
        days: daysUntilMonday <= 0 ? daysUntilMonday + 7 : daysUntilMonday));
  }

  DateTime getNextTuesday() {
    int daysUntilTuesday = DateTime.tuesday - selectedDate.weekday;
    return selectedDate.add(Duration(
        days: daysUntilTuesday <= 0 ? daysUntilTuesday + 7 : daysUntilTuesday));
  }

  void showDatePicker(BuildContext context) {
    toDate = true;
    fromDate = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 0),
          backgroundColor: AppColors.whiteColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            padding: EdgeInsets.only(left: 10, right: 10),
            child: StatefulBuilder(builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            buildButton(
                              "Today",
                              () {
                                setState(
                                  () {
                                    _setDate(DateTime.now(), "Today");
                                  },
                                );
                              },
                              selectedButton,
                              selectedNoDateButton,
                              toDate,
                              fromDate,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            buildButton(
                              "Next Monday",
                              () {
                                setState(
                                  () {
                                    _setDate(getNextMonday(), "Next Monday");
                                  },
                                );
                              },
                              selectedButton,
                              selectedNoDateButton,
                              toDate,
                              fromDate,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            buildButton(
                              "Next Tuesday",
                              () {
                                setState(
                                  () {
                                    _setDate(getNextTuesday(), "Next Tuesday");
                                  },
                                );
                              },
                              selectedButton,
                              selectedNoDateButton,
                              toDate,
                              fromDate,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            buildButton(
                              "After 1 week",
                              () {
                                setState(
                                  () {
                                    _setDate(
                                        selectedDate.add(Duration(days: 7)),
                                        "After 1 week");
                                  },
                                );
                              },
                              selectedButton,
                              selectedNoDateButton,
                              toDate,
                              fromDate,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  TableCalendar(
                    focusedDay: focusedDay,
                    firstDay: DateTime(2000),
                    lastDay: DateTime(2100),
                    selectedDayPredicate: (day) => isSameDay(selectedDate, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(
                        () {
                          selectedDate = selectedDay;
                          focusedDay = focusedDay;
                        },
                      );
                    },
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                    calendarStyle: CalendarStyle(
                      selectedDecoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primaryColor)),
                      selectedTextStyle: TextStyle(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                      todayTextStyle: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 10, bottom: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: AppColors.primaryColor,
                                size: 20,
                              ),
                              SizedBox(width: 10),
                              Text(
                                DateFormat("d MMM y").format(selectedDate),
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 70,
                                padding: EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                    color: AppColors.secondaryColor,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                    child: Text("Cancel",
                                        style: TextStyle(
                                            color: AppColors.primaryColor))),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                // print(_selectedDate);
                                fromDateC.text =
                                    DateFormat("d MMM y").format(selectedDate);
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 70,
                                padding: EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                    child: Text("Save",
                                        style: TextStyle(
                                            color: AppColors.whiteColor))),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }

  void showNoDatePicker(BuildContext context) {
    toDate = false;
    fromDate = true;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 0),
          backgroundColor: AppColors.whiteColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            padding: EdgeInsets.only(left: 10, right: 10),
            child: StatefulBuilder(builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            buildButton(
                              "No Date",
                              () {
                                setState(
                                  () {
                                    _setNoDate(null, "No Date");
                                  },
                                );
                              },
                              selectedButton,
                              selectedNoDateButton,
                              toDate,
                              fromDate,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            buildButton(
                              "Today",
                              () {
                                setState(
                                  () {
                                    _setNoDate(DateTime.now(), "Today");
                                  },
                                );
                              },
                              selectedButton,
                              selectedNoDateButton,
                              toDate,
                              fromDate,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  TableCalendar(
                    focusedDay: focusedDay,
                    firstDay: DateTime(2000),
                    lastDay: DateTime(2100),
                    selectedDayPredicate: (day) =>
                        isSameDay(selectedNoDate, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(
                        () {
                          selectedNoDate = selectedDay;
                          focusedDay = focusedDay;
                        },
                      );
                    },
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                    calendarStyle: CalendarStyle(
                      selectedDecoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primaryColor)),
                      selectedTextStyle: TextStyle(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                      todayTextStyle: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 10, bottom: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: AppColors.primaryColor,
                                size: 20,
                              ),
                              SizedBox(width: 10),
                              Text(
                                selectedNoDate != null
                                    ? DateFormat("d MMM y")
                                        .format(selectedNoDate!)
                                    : "No Date",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 70,
                                padding: EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                    color: AppColors.secondaryColor,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                    child: Text("Cancel",
                                        style: TextStyle(
                                            color: AppColors.primaryColor))),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                // print(_selectedDate);

                                toDateC.text = selectedNoDate != null
                                    ? DateFormat("d MMM y")
                                        .format(selectedNoDate!)
                                    : "No Date";
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 70,
                                padding: EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                    child: Text("Save",
                                        style: TextStyle(
                                            color: AppColors.whiteColor))),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }

  void selectRole(BuildContext context, index) {
    selectRoleC.text = roleList[index].toString();
    Navigator.pop(context, index);
  }

  String? validator(value) {
    if (value!.isEmpty) {
      return "Field is empty!";
    }
    return null;
  }

  void removeNotes(int index) {
    deletedIndex = employeeModel.removeAt(index);
    emit(ResponseState(employeeModel));
  }

  void undoNotes(int index) {
    employeeModel.insert(index, deletedIndex);
    emit(ResponseState(employeeModel));
  }

  void onSubmit(BuildContext context) {
    if (key.currentState!.validate()) {
      emit(LoadingState());
      Future.delayed(
        Duration(seconds: 2),
        () {
          databaseHelper
              .insertData(
            EmployeeModel(
              name: nameC.text,
              role: selectRoleC.text,
              fromDate: fromDateC.text,
              toDate: toDateC.text,
            ),
          )
              .then((value) {
            emit(SuccessState("Success"));

            double screenWidth = MediaQuery.of(context).size.width;

            if (screenWidth > 900) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebViewEmployees(),
                  ),
                  (route) => false);
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewEmployees(),
                  ),
                  (route) => false);
            }
            print("Success");
          }).onError((error, stackTrace) {
            emit(ErrorState("Fail $error"));
            print("Fail $error");
          });
        },
      );
    }
  }

  void getData() {
    try {
      emit(LoadingState());
      Future.delayed(
        Duration(seconds: 2),
        () async {
          employeeModel = await databaseHelper.readData();

          emit(ResponseState(employeeModel));
        },
      );
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  void deletData(int id) {
    try {
      databaseHelper.deleteData(id);
      emit(SuccessState("Notes Deleted Successfully"));
      // getData();
      print("Deleted");
    } catch (e) {
      emit(ErrorState(e.toString()));
      print("Fail");
    }
  }

  void updateData(int id, BuildContext context) {
    emit(LoadingState());
    Future.delayed(
      Duration(seconds: 2),
      () {
        databaseHelper
            .updateData(EmployeeModel(
          id: id,
          name: nameC.text,
          role: selectRoleC.text,
          fromDate: fromDateC.text,
          toDate: toDateC.text,
        ))
            .then((value) {
          emit(SuccessState("Notes Updated Successfully"));

          double screenWidth = MediaQuery.of(context).size.width;

          if (screenWidth > 900) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => WebViewEmployees(),
                ),
                (route) => false);
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewEmployees(),
                ),
                (route) => false);
          }
          print("Notes Updated Successfully");
        }).onError((error, stackTrace) {
          emit(ErrorState("Notes Updatation Failed"));
        });
      },
    );
  }
}
