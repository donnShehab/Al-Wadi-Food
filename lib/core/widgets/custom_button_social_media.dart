// import 'package:alwadi_food/core/utils/app_text_styles.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_svg/svg.dart';

// // class CustomButtonSocialMedia extends StatelessWidget {
// //   const CustomButtonSocialMedia({
// //     super.key,
// //     required this.image,
// //     required this.title,
// //     required this.onPressed,
// //   });

// //   final String image;
// //   final String title;
// //   final VoidCallback onPressed;
// //   @override
// //   Widget build(BuildContext context) {
// //     return SizedBox(
// //       width: double.infinity,
// //       height: 56,
// //       child: TextButton(
// //         style: TextButton.styleFrom(
// //           shape: RoundedRectangleBorder(
// //             side: const BorderSide(color: Color(0xFFDCDEDE), width: 1),
// //             borderRadius: BorderRadius.circular(16),
// //           ),
// //         ),
// //         onPressed: onPressed,
// //         child: ListTile(
// //           visualDensity: const VisualDensity(
// //             vertical: VisualDensity.minimumDensity,
// //           ),
// //           leading: SvgPicture.asset(image),
// //           title: Text(
// //             title,
// //             textAlign: TextAlign.center,
// //             style: TextStyles.semiBold16,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// class CustomButtonSocialMediaa extends StatelessWidget {
//   const CustomButtonSocialMediaa({
//     super.key,
//     required this.imageSocial,
//     required this.title,
//     this.onPressed,
//     this.titleColor,
//     this.color,
//   });
//   final SvgPicture imageSocial;
//   final String title;
//   final Function()? onPressed;
//   final Color? titleColor;
//   final Color? color;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 54,
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Color(0xffDDDFDF), width: 1),
//       ),
//       child: TextButton(
//         onPressed: onPressed,
//         //  style: TextButton.styleFrom(
//         //   shape: RoundedRectangleBorder(
//         //     borderRadius: BorderRadius.circular(16),
//         //   ),
//         // ),
//         child: Row(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: imageSocial,
//             ),
//             SizedBox(width: 60),
//             Stack(
//               children: [
//                 Align(
//                   alignment: Alignment.center,
//                   child: Text(
//                     title,
//                     style: TextStyles.bold19.copyWith(color: titleColor),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
