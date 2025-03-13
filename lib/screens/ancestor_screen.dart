import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/ancestor_provider.dart';
import '../screens/add_ancestor_screen.dart';

class AncestorScreen extends StatelessWidget {
  const AncestorScreen({Key? key}) : super(key: key);

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
            // Hiển thị danh sách Ông Tổ
            if (ancestorProvider.isLoading)
              const Center(child: CupertinoActivityIndicator())
            else if (ancestorProvider.ancestors.isEmpty)
              const Center(
                child: Text(
                  "No ancestor data available.\nPress the + button to add a new ancestor.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              )
            else
              ListView.builder(
                itemCount: ancestorProvider.ancestors.length,
                itemBuilder: (context, index) {
                  final ancestor = ancestorProvider.ancestors[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: CupertinoListTile(
                      title: Text(ancestor.name),
                      subtitle: Text(
                        "Birth Year: ${ancestor.birthDate}\n"
                        "Death Year: ${ancestor.deathDate ?? 'N/A'}",
                      ),
                    ),
                  );
                },
              ),
            // Nút dấu cộng để thêm Ông Tổ
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
