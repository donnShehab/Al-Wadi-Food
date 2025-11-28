// // import 'package:e_coomerce_fruit/core/utils/app_text_styles.dart';
// // import 'package:e_coomerce_fruit/core/widgets/custom_notification.dart';
// // import 'package:flutter/material.dart';

// // import 'custom_notification.dart';

// // AppBar buildAppBar(context, {required String title}) {
// //   return AppBar(
// //     backgroundColor: Colors.white,
// //     leading: GestureDetector(
// //       onTap: () {
// //         Navigator.pop(context);
// //       },
// //       child: Icon(Icons.arrow_back_ios_new),
// //     ),

// //     title: Text(title, style: TextStyles.bold19),
// //     centerTitle: true,

// //   );
// // }

import 'package:alwadi_food/core/utils/app_colors.dart';
import 'package:alwadi_food/core/utils/app_text_styles.dart';
import 'package:alwadi_food/core/widgets/custom_notification.dart';
import 'package:flutter/material.dart';

AppBar buildAppBar(
  context, {
  required String title,
  required Color? color,
   Color ?titleColor,
  bool showBackButton = true,
  bool showNotification = true,
  Icon? iconBackButton,
}) {
  return AppBar(
    backgroundColor: color,
    actions: [
      Visibility(
        visible: showNotification,
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 3),
          child: CustomNofitication(),
        ),
      ),
    ],
    leading: Visibility(
      visible: showBackButton,
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child:iconBackButton,
      ),
    ),
    centerTitle: true,
    title: Text(title, textAlign: TextAlign.center, style: TextStyles.bold19.copyWith(color: titleColor)),
  );
}
