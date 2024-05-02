import 'package:flutter/material.dart';
import 'package:todoapp/cubit/cubit.dart';
import 'package:todoapp/widgets/custom_buttom_sheet.dart';

Widget CustomFloatingButton(BuildContext context) {
  var cubit = ToDoCubit.get(context);

  return FloatingActionButton(
    onPressed: () {
      if (cubit.isBottomSheetShown) {
        if (cubit.formKey.currentState!.validate()) {
          cubit.insertDB(
            title: cubit.titleController.text,
            time: cubit.dateController.text,
            date: cubit.timeController.text,
          );
          // Navigator.pop(context);
        }
      } else {
        cubit.scaffoldKey.currentState!
            .showBottomSheet(
              (context) => CustomBottomSheet(context),
              elevation: 20.0,
            )
            .closed
            .then(
          (value) {
            cubit.changeBottomSheetState(
              isShown: false,
              fabIcon2: Icons.edit,
            );
          },
        );
        cubit.changeBottomSheetState(
          isShown: true,
          fabIcon2: Icons.add,
        );
      }
    },
    child: Icon(
      cubit.changeIcon,
    ),
  );
}
