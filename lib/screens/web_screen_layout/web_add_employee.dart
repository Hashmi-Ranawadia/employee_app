import 'package:assignment_employee_app/bloc/app_cubit.dart';
import 'package:assignment_employee_app/bloc/app_state.dart';
import 'package:assignment_employee_app/model/employee_model.dart';
import 'package:assignment_employee_app/utils/app_colors.dart';
import 'package:assignment_employee_app/widgets/custom_button.dart';
import 'package:assignment_employee_app/widgets/custom_textfield.dart';
import 'package:assignment_employee_app/widgets/datepicker_option_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class WebAddEmployee extends StatefulWidget {
  const WebAddEmployee({super.key, this.employeeModel});
  final EmployeeModel? employeeModel;

  @override
  State<WebAddEmployee> createState() => _WebAddEmployeeState();
}

class _WebAddEmployeeState extends State<WebAddEmployee> {
  AppCubit? appCubit;

  @override
  void initState() {
    appCubit = BlocProvider.of<AppCubit>(context);
    if (widget.employeeModel != null) {
      appCubit!.nameC.text = widget.employeeModel!.name!;
      appCubit!.selectRoleC.text = widget.employeeModel!.role!;
      appCubit!.fromDateC.text = widget.employeeModel!.fromDate!;
      appCubit!.toDateC.text = widget.employeeModel!.toDate!;
    } else {
      appCubit!.nameC.clear();
      appCubit!.selectRoleC.clear();
      appCubit!.fromDateC.clear();
      appCubit!.toDateC.clear();
    }

    appCubit!.selectedDate = DateTime.now();
    appCubit!.selectedNoDate = null;
    appCubit!.focusedDay = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appCubit = BlocProvider.of<AppCubit>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          title: Text(
            widget.employeeModel != null
                ? "Edit Employee Details"
                : "Add Employee Details",
            style: TextStyle(color: AppColors.whiteColor),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: AppColors.whiteColor,
              )),
        ),
        body: BlocBuilder<AppCubit, AppState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 20, top: 20),
                    child: Form(
                      key: appCubit.key,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextfield(
                                    controller: appCubit.nameC,
                                    hintText: "Employee Name",
                                    prefixIcon: Icon(
                                      Icons.person_outline_rounded,
                                      color: AppColors.primaryColor,
                                    ),
                                    validator: appCubit.validator,
                                  ),
                                ),
                                const SizedBox(
                                  width: 28,
                                ),
                                const SizedBox(),
                                const SizedBox(
                                  width: 28,
                                ),
                                Expanded(
                                  child: CustomTextfield(
                                    readOnly: true,
                                    onTap: showBottomSheet,
                                    controller: appCubit.selectRoleC,
                                    hintText: "Select Role",
                                    prefixIcon: Icon(
                                      Icons.card_travel_rounded,
                                      color: AppColors.primaryColor,
                                    ),
                                    suffixIcon: Icon(
                                      Icons.arrow_drop_down_rounded,
                                      size: 40,
                                      color: AppColors.primaryColor,
                                    ),
                                    validator: appCubit.validator,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextfield(
                                    readOnly: true,
                                    onTap: () {
                                      appCubit.showDatePicker(context);
                                    },
                                    controller: appCubit.fromDateC,
                                    hintText: "Today",
                                    prefixIcon: Icon(
                                      Icons.date_range_outlined,
                                      color: AppColors.primaryColor,
                                    ),
                                    validator: appCubit.validator,
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: AppColors.primaryColor,
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: CustomTextfield(
                                    readOnly: true,
                                    onTap: () {
                                      appCubit.showNoDatePicker(context);
                                    },
                                    controller: appCubit.toDateC,
                                    hintText: "No Date",
                                    prefixIcon: Icon(
                                      Icons.date_range_outlined,
                                      color: AppColors.primaryColor,
                                    ),
                                    validator: appCubit.validator,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 70,
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    right: 20,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppColors.greyColor, width: 0.8),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomButton(
                        buttonTxt: Text(
                          "Cancel",
                          style: TextStyle(color: AppColors.primaryColor),
                        ),
                        bgColor: AppColors.secondaryColor,
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CustomButton(
                        buttonTxt: state is LoadingState
                            ? Container(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                "Save",
                                style: TextStyle(color: AppColors.whiteColor),
                              ),
                        bgColor: AppColors.primaryColor,
                        onTap: state is LoadingState
                            ? () {}
                            : () {
                                widget.employeeModel != null
                                    ? appCubit.updateData(
                                        widget.employeeModel!.id!, context)
                                    : appCubit.onSubmit(context);
                              },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ));
  }

  void showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.whiteColor,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(appCubit!.roleList.length, (index) {
                  return InkWell(
                    onTap: () {
                      appCubit!.selectRole(context, index);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: Text("${appCubit!.roleList[index]}"),
                        ),
                        if (index < appCubit!.roleList.length - 1)
                          const Divider(),
                      ],
                    ),
                  );
                }),
              ),
            );
          },
        );
      },
    );
  }
}
