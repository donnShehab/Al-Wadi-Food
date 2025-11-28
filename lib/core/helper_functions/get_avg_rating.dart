// // import 'package:e_coomerce_fruit/core/models/review_model.dart';

// // num getAvgRating(List<dynamic>? reviews) {
// //   if (reviews == null || reviews.isEmpty) return 0;

// //   double sum = 0;
// //   for (var r in reviews) {
// //     // تحويل كل عنصر من Map إلى ReviewModel
// //     final review = ReviewModel.fromJson(r);
// //     sum += review.ratting.toDouble();
// //   }
// //   return sum / reviews.length;
// // }
// import '../models/review_model.dart';

// num getAvgRating(List<ReviewModel> reviews) {
//   if (reviews.isEmpty) return 0;
//   final sum = reviews.fold<double>(0, (prev, r) => prev + r.ratting.toDouble());
//   return sum / reviews.length;
// }
