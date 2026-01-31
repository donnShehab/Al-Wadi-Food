import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:alwadi_food/core/constants/app_constants.dart';

class QcResultsMigration {
  final FirebaseFirestore firestore;

  QcResultsMigration(this.firestore);

  Future<void> runMigrationSafe() async {
    // ✅ لا تشغل migration بدون user
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      debugPrint("⚠️ Migration skipped: user not authenticated yet.");
      return;
    }

    try {
      await runMigration();
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        debugPrint(
          "⚠️ Migration skipped: permission denied (rules/role not ready).",
        );
        return;
      }
      rethrow;
    } catch (e) {
      debugPrint("❌ Migration failed unexpectedly: $e");
      // لا نرمي exception حتى ما ينهار التطبيق
    }
  }

  /// ✅ Run once to update old qc_results documents with product info
  Future<void> runMigration() async {
    debugPrint("🚀 Starting QC Results Migration...");

    final qcSnap = await firestore
        .collection(AppConstants.qcResultsCollection)
        .get();

    debugPrint("✅ Found ${qcSnap.docs.length} QC results");

    int updated = 0;
    int skipped = 0;

    for (final qcDoc in qcSnap.docs) {
      final data = qcDoc.data();

      final batchId = data["batchId"]?.toString();
      if (batchId == null || batchId.trim().isEmpty) {
        skipped++;
        continue;
      }

      if (data.containsKey("productType") && data["productType"] != null) {
        skipped++;
        continue;
      }

      try {
        final batchDoc = await firestore
            .collection(AppConstants.batchesCollection)
            .doc(batchId)
            .get();

        if (!batchDoc.exists) {
          skipped++;
          continue;
        }

        final batchData = batchDoc.data() as Map<String, dynamic>;

        final productType = batchData["productType"];
        final line = batchData["line"];
        final quantity = batchData["quantity"];
        final batchImages = (batchData["images"] is List)
            ? List<String>.from(batchData["images"])
            : <String>[];

        await firestore
            .collection(AppConstants.qcResultsCollection)
            .doc(qcDoc.id)
            .update({
              "productType": productType,
              "line": line,
              "quantity": quantity,
              "batchImages": batchImages,
            });

        updated++;
      } catch (e) {
        debugPrint("❌ Failed updating ${qcDoc.id}: $e");
        skipped++;
      }
    }

    debugPrint(
      "🎉 Migration Finished! ✅ Updated: $updated ⏭️ Skipped: $skipped",
    );
  }
}
