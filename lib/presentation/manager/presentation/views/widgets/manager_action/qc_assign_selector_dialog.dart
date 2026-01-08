import 'package:flutter/material.dart';

class QCAssignSelectorDialog {
  static Future<Map<String, String>?> show(
    BuildContext context,
    List<Map<String, dynamic>> qcUsers,
  ) async {
    final searchCtrl = TextEditingController();
    List<Map<String, dynamic>> filtered = List.from(qcUsers);

    return showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            void filter(String query) {
              final q = query.toLowerCase().trim();
              setState(() {
                filtered = qcUsers.where((u) {
                  final name = (u["name"] ?? "").toString().toLowerCase();
                  return name.contains(q);
                }).toList();
              });
            }

            return AlertDialog(
              title: const Text("Assign QC 👤"),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: searchCtrl,
                      decoration: const InputDecoration(
                        hintText: "Search QC name...",
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: filter,
                    ),
                    const SizedBox(height: 12),
                    if (filtered.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Text("No QC users found"),
                      )
                    else
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final user = filtered[index];
                            final uid = (user["uid"] ?? "").toString();
                            final name = (user["name"] ?? "Unknown").toString();

                            return ListTile(
                              leading: const CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                              title: Text(
                                name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text("ID: $uid"),
                              onTap: () {
                                Navigator.pop(ctx, {
                                  "qcId": uid,
                                  "qcName": name,
                                });
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Cancel"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
