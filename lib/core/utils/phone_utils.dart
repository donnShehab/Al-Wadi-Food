// /// 🔹 Helper function to ensure all phone numbers are saved and searched
// /// in the same format, e.g. +962798138512 (no spaces or symbols)
// String formatPhoneForFirebase(String phone) {
//   String digits = phone.replaceAll(RegExp(r'\D'), ''); // remove all non-digits

//   // Assume Jordan country code +962
//   if (digits.startsWith('962'))
//     digits = '+$digits';
//   else if (digits.startsWith('0'))
//     digits = '+962${digits.substring(1)}';
//   else if (!digits.startsWith('+962'))
//     digits = '+962$digits';

//   // Insert spaces like Firebase: +962 7 9813 8512
//   // +962 7 XXX XXXX
//   final reg = RegExp(r'(\+\d{3})(\d)(\d{3})(\d{4})');
//   final match = reg.firstMatch(digits);
//   if (match != null) {
//     return '${match.group(1)} ${match.group(2)} ${match.group(3)} ${match.group(4)}';
//   }
//   return digits; // fallback
// }
