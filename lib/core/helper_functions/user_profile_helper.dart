// import 'dart:convert';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:e_coomerce_fruit/core/services/shared_preferences_singleton.dart';
// import 'package:e_coomerce_fruit/constants.dart';

// Future<void> updateUserProfileImage(String imageUrl) async {
//   final user = FirebaseAuth.instance.currentUser;

//   if (user != null) {
//     await user.updatePhotoURL(imageUrl);

//     var currentUserData = Prefs.getString(kUserData);
//     if (currentUserData.isNotEmpty) {
//       var userMap = jsonDecode(currentUserData);
//       userMap['photoUrl'] = imageUrl;
//       await Prefs.setString(kUserData, jsonEncode(userMap));
//     }

//     print('✅ User profile image updated successfully.');
//   } else {
//     print('⚠️ No logged in user found.');
//   }
// }
