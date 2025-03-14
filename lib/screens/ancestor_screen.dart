import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ancestor_provider.dart';
import '../screens/add_ancestor_screen.dart';

class AncestorScreen extends StatelessWidget {
  const AncestorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ancestorProvider = Provider.of<AncestorProvider>(context);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Ancestor Management"),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            // Hiển thị danh sách ancestor
            if (ancestorProvider.isLoading)
              const Center(child: CupertinoActivityIndicator())
            else if (ancestorProvider.ancestors.isEmpty)
              const Center(
                child: Text(
                  "No ancestor data available.\nPress the + button to add a new ancestor.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              )
            else
              ListView.builder(
                itemCount: ancestorProvider.ancestors.length,
                itemBuilder: (context, index) {
                  final ancestor = ancestorProvider.ancestors[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey5,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.systemGrey2.withOpacity(0.5),
                            blurRadius: 4.0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            // Avatar hoặc Icon
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: CupertinoColors.systemGrey4,
                              child: const Icon(
                                CupertinoIcons.person_fill,
                                color: CupertinoColors.white,
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Thông tin tổ tiên
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ancestor.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Birth Year: ${ancestor.birthDate}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: CupertinoColors.systemGrey,
                                    ),
                                  ),
                                  Text(
                                    "Death Year: ${ancestor.deathDate ?? 'N/A'}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: CupertinoColors.systemGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            // Nút "+" thêm ancestor
            Positioned(
              bottom: 20,
              right: 20,
              child: CupertinoButton(
                color: CupertinoColors.activeBlue,
                padding: const EdgeInsets.all(16.0),
                borderRadius: BorderRadius.circular(30),
                child: const Icon(CupertinoIcons.add, color: CupertinoColors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => const AddAncestorScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
