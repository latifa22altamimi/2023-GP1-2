import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DatePicker2 extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  getDate(
      {TextEditingController? controller, String title = "تاريخ الحجز"}) async {
    DateTime? pickedDate = await showDatePicker(
      context: c,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      // initialDatePickerMode: DatePickerMode.year,
      // initialEntryMode: DatePickerEntryMode.input,
      cancelText: "الغاء",
      confirmText: "موفق",
      fieldHintText: "Date/Month/Year",
      errorFormatText: "Enter valid date",
      errorInvalidText: "Enter valid date or range",
      helpText: title.tr,
    );
    if (pickedDate != null) {
      var date;
      date = DateFormat('yyyy/MM/dd').format(pickedDate);
      controller!.text = date.toString();
    }
  }
}
