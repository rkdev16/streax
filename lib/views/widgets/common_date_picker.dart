// import 'package:flutter/material.dart';
// import 'package:streax/config/app_colors.dart';
//
// // class CommonDatePicker{
// // static showPicker(BuildContext context, {DateTime? initialDate, required Function(DateTime value) onSelect})
// // {
// //   showDatePicker(context: context, initialDate: initialDate?? DateTime.now(), firstDate:  DateTime.now(),
// //       lastDate:(initialDate ?? DateTime.now()).add(const Duration(days: 500)),builder: (context,child){
// //     return Theme(
// //         data: ThemeData.dark().copyWith(
// //             colorScheme: const ColorScheme.light(
// //               onPrimary:Colors.white,
// //                 onSurface:  AppColors.kPrimaryColor,
// //                 primary:  AppColors.kPrimaryColor,
// //              background: AppColors.kPrimaryColor,
// //             ),
// //             dialogBackgroundColor: Colors.white,
// //             textButtonTheme: TextButtonThemeData(
// //                 style: TextButton.styleFrom(
// //                     foregroundColor: Colors.white, textStyle: const TextStyle(
// //                         color:  Colors.white,
// //                         fontWeight: FontWeight.w700,
// //                         fontSize: 12),
// //                     backgroundColor: AppColors.kPrimaryColor, // Background color
// //                     shape: RoundedRectangleBorder(
// //
// //                         side: const BorderSide(
// //                             color: AppColors.kPrimaryColor,
// //                             width: 1,
// //                             style: BorderStyle.solid),
// //                         borderRadius: BorderRadius.circular(8.0))))),
// //         child: child!);
// //       }
// //   );
// // }
// //
// //
// // }
//
//
//
//
// class DatePickerExample extends StatefulWidget {
//   const DatePickerExample({super.key, this.restorationId});
//
//   final String? restorationId;
//
//   @override
//   State<DatePickerExample> createState() => _DatePickerExampleState();
// }
//
//
// class _DatePickerExampleState extends State<DatePickerExample>
//     with RestorationMixin {
//
//   @override
//   String? get restorationId => widget.restorationId;
//
//   final RestorableDateTime _selectedDate =
//   RestorableDateTime(DateTime(2021, 7, 25));
//   late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
//   RestorableRouteFuture<DateTime?>(
//     onComplete: _selectDate,
//     onPresent: (NavigatorState navigator, Object? arguments) {
//       return navigator.restorablePush(
//         _datePickerRoute,
//         arguments: _selectedDate.value.millisecondsSinceEpoch,
//       );
//     },
//   );
//
//
//   static Route<DateTime> _datePickerRoute(
//       BuildContext context,
//       Object? arguments,
//       ) {
//     return DialogRoute<DateTime>(
//       context: context,
//       builder: (BuildContext context) {
//         return DatePickerDialog(
//           restorationId: 'date_picker_dialog',
//           initialEntryMode: DatePickerEntryMode.calendarOnly,
//           initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
//           firstDate: DateTime(2021),
//           lastDate: DateTime(2022),
//         );
//       },
//     );
//   }
//
//   @override
//   void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
//     registerForRestoration(_selectedDate, 'selected_date');
//     registerForRestoration(
//         _restorableDatePickerRouteFuture, 'date_picker_route_future');
//   }
//
//   void _selectDate(DateTime? newSelectedDate) {
//     if (newSelectedDate != null) {
//       setState(() {
//         _selectedDate.value = newSelectedDate;
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text(
//               'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
//         ));
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: OutlinedButton(
//           onPressed: () {
//             _restorableDatePickerRouteFuture.present();
//           },
//           child: const Text('Open Date Picker'),
//         ),
//       ),
//     );
//   }
// }
