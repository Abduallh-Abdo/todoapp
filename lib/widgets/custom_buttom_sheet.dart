import 'package:flutter/material.dart';
import 'package:todoapp/cubit/cubit.dart';
import 'package:todoapp/widgets/texr_form_custom.dart';

Widget CustomBottomSheet(BuildContext context) {
  var cubit = ToDoCubit.get(context);

  return SizedBox(
    height: 400,
    child: Form(
      key: cubit.formKey,
      child: ListView(
        children: [
          CustomFormFiled(
            label: 'Task Title',
            hintText: 'Task Title',
            controller: cubit.titleController,
            prefixIcon: const Icon(Icons.title),
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'Title is required';
              }
              return null;
            },
          ),
          CustomFormFiled(
            label: 'Task Title',
            // hintText: ' 00:00 Am',
            controller: cubit.timeController,
            prefixIcon: const Icon(Icons.watch_later_outlined),
            readOnly: true,
            onTap: () => cubit.selectTime(context),
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'Date is required';
              }
              return null;
            },
          ),
          CustomFormFiled(
            label: 'Task date',
            // hintText: 'Dec 22, 2002',
            prefixIcon: const Icon(Icons.date_range),
            onTap: () => cubit.selectDate(context),
            readOnly: true,
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'Time is required';
              }
              return null;
            },
            controller: cubit.dateController,
          ),
        ],
      ),
    ),
  );
}


          // ElevatedButton(
          //   child: const Text(
          //     'Save',
          //     style: TextStyle(
          //       color: Colors.black,
          //       fontSize: 25,
          //     ),
          //   ),
          //   onPressed: () {
          //     cubit.insertDB(
          //         //to save date in database must be DateFormat('yyyy-MM-dd').format(date)
          //         //to save in time database must be cubit.time.format(date)
          //         title: titleController.text,
          //         date: DateFormat('yyyy-MM-dd').format(cubit.date),
          //         time: cubit.time.format(context));
          //     Navigator.pop(context);
          //   },
          // ),