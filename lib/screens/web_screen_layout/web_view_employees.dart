import 'dart:math';

import 'package:assignment_employee_app/bloc/app_cubit.dart';
import 'package:assignment_employee_app/bloc/app_state.dart';
import 'package:assignment_employee_app/model/employee_model.dart';
import 'package:assignment_employee_app/screens/mobile_screen_layout/add_employee.dart';
import 'package:assignment_employee_app/screens/web_screen_layout/web_add_employee.dart';
import 'package:assignment_employee_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WebViewEmployees extends StatefulWidget {
  const WebViewEmployees({super.key});

  @override
  State<WebViewEmployees> createState() => _WebViewEmployeesState();
}

class _WebViewEmployeesState extends State<WebViewEmployees> {
  @override
  void initState() {
    final appCubit = BlocProvider.of<AppCubit>(context);
    appCubit.getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appCubit = BlocProvider.of<AppCubit>(context);
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.whiteColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.primaryColor,
            title: Text(
              "Employee List",
              style: TextStyle(
                color: AppColors.whiteColor,
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.primaryColor,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebAddEmployee(),
                  ));
            },
            child: Icon(
              Icons.add,
              color: AppColors.whiteColor,
              size: 30,
            ),
          ),
          body: state is LoadingState
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                )
              : appCubit.employeeModel.isEmpty
                  ? Center(
                      child: Image.asset(
                      "assets/images/no_data.png",
                      width: MediaQuery.of(context).size.width * 0.50,
                    ))
                  : Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 10),
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        itemCount: appCubit.employeeModel.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: Key(appCubit.employeeModel[index].id
                                .toString()), // A unique key for each item
                            direction: DismissDirection
                                .endToStart, // Swiping direction: right to left
                            onDismissed: (direction) {
                              EmployeeModel myEmployeeModel =
                                  appCubit.employeeModel[index];
                              appCubit.removeNotes(index);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.black,
                                      content: Text(
                                          "Employee data has been deleted"),
                                      action: SnackBarAction(
                                        textColor: AppColors.primaryColor,
                                        label: "Undo",
                                        onPressed: () {
                                          appCubit.undoNotes(index);
                                        },
                                      ),
                                    ),
                                  )
                                  .closed
                                  .then((value) {
                                if (value == SnackBarClosedReason.timeout) {
                                  appCubit.deletData(myEmployeeModel.id!);
                                }
                              });
                            },
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              color: Colors.red,
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            child: InkWell(
                              // onLongPress: () {
                              //   popUp(appCubit.noteModel[index].id!, appCubit,
                              //       index);
                              // },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "${appCubit.employeeModel[index].name}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: AppColors.blackColor,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddEmployee(
                                                          employeeModel: appCubit
                                                                  .employeeModel[
                                                              index]),
                                                ));
                                          },
                                          child: Icon(
                                            Icons.edit_note,
                                            color: AppColors.blackColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      "${appCubit.employeeModel[index].role}",
                                      style: TextStyle(
                                        color: AppColors.greyColor
                                            .withOpacity(0.8),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "${appCubit.employeeModel[index].fromDate} - ${appCubit.employeeModel[index].toDate}",
                                      style: TextStyle(
                                          color: AppColors.greyColor,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                      ),
                    ),
        );
      },
    );
  }
}
