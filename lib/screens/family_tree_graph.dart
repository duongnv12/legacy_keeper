import 'package:flutter/cupertino.dart';
import 'package:graphview/GraphView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'family_member_table_screen.dart'; // Import bảng thành viên
import 'add_family_member_screen.dart';
import '../models/family_member_model.dart';

class FamilyTreeGraph extends StatefulWidget {
  const FamilyTreeGraph({super.key});

  @override
  _FamilyTreeGraphState createState() => _FamilyTreeGraphState();
}

class _FamilyTreeGraphState extends State<FamilyTreeGraph> {
  final Graph graph = Graph()..isTree = true; // Tree graph structure
  final BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();
  bool isLoading = true;
  bool hasError = false;
  bool showTable = false; // Toggle to switch between Tree and Table views

  final List<FamilyMember> familyMembers = []; // Danh sách thành viên từ Firestore

  @override
  void initState() {
    super.initState();
    _configureTree(); // Cấu hình layout cây gia phả
    _buildTree(); // Tạo cây gia phả ban đầu
  }

  void _configureTree() {
    builder
      ..siblingSeparation = 100
      ..levelSeparation = 150
      ..subtreeSeparation = 150
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;
  }

  Future<void> _buildTree() async {
    try {
      // Fetch ancestor
      final ancestorSnapshot = await FirebaseFirestore.instance
          .collection('ancestors')
          .orderBy('createdAt', descending: false)
          .limit(1)
          .get();

      if (ancestorSnapshot.docs.isNotEmpty) {
        final ancestorData = ancestorSnapshot.docs.first.data();
        final ancestorId = ancestorSnapshot.docs.first.id;

        final Node rootNode = Node.Id(ancestorData['name']);
        graph.addNode(rootNode);

        // Add ancestor to the local member list
        familyMembers.add(FamilyMember.fromFirestore(
          ancestorData,
          ancestorId,
        ));

        // Recursively build subtree
        await _buildSubTree(rootNode, ancestorId);

        setState(() {
          isLoading = false;
          hasError = false;
        });
      } else {
        setState(() {
          isLoading = false;
          hasError = true;
        });
      }
    } catch (e) {
      print("Error building tree: $e");
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  Future<void> _buildSubTree(Node parentNode, String parentId) async {
    try {
      final childrenSnapshot = await FirebaseFirestore.instance
          .collection('family_members')
          .where('parentId', isEqualTo: parentId)
          .get();

      for (var child in childrenSnapshot.docs) {
        final childData = child.data();

        final Node childNode = Node.Id(childData['name']);
        graph.addNode(childNode);
        graph.addEdge(parentNode, childNode);

        // Add child to the local member list
        familyMembers.add(FamilyMember.fromFirestore(
          childData,
          child.id,
        ));

        // Recursively build subtree for each child
        await _buildSubTree(childNode, child.id);
      }
    } catch (e) {
      print("Error building subtree: $e");
    }
  }

  void _addMember(FamilyMember newMember) {
    setState(() {
      familyMembers.add(newMember); // Add member to the list

      final Node newNode = Node.Id(newMember.name);
      graph.addNode(newNode);

      if (newMember.parentId != null && newMember.parentId!.isNotEmpty) {
        final Node parentNode = graph.getNodeUsingKey(newMember.parentId! as ValueKey);
        graph.addEdge(parentNode, newNode);
            }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("Family Tree"),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text(showTable ? "Tree View" : "Table View"),
          onPressed: () {
            setState(() {
              showTable = !showTable; // Toggle between Tree and Table views
            });
          },
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            if (isLoading)
              const Center(
                child: CupertinoActivityIndicator(),
              )
            else if (hasError)
              const Center(
                child: Text(
                  "An error occurred while fetching data.\nPlease try again.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: CupertinoColors.systemRed),
                ),
              )
            else
              showTable
                  ? FamilyMemberTableScreen(familyMembers: familyMembers) // Table view
                  : InteractiveViewer(
                      constrained: false,
                      boundaryMargin: const EdgeInsets.all(100),
                      minScale: 0.5,
                      maxScale: 2.0,
                      child: GraphView(
                        graph: graph,
                        algorithm: BuchheimWalkerAlgorithm(
                          builder,
                          TreeEdgeRenderer(builder),
                        ),
                        builder: (Node node) {
                          return _nodeWidget(node.key!.value);
                        },
                      ),
                    ),
            Positioned(
              bottom: 20,
              right: 20,
              child: CupertinoButton(
                color: CupertinoColors.activeBlue,
                padding: const EdgeInsets.all(16.0),
                borderRadius: BorderRadius.circular(30),
                child: const Icon(CupertinoIcons.add, color: CupertinoColors.white),
                onPressed: () async {
                  final newMember = await Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const AddFamilyMemberScreen(),
                    ),
                  );

                  if (newMember != null && newMember is FamilyMember) {
                    _addMember(newMember); // Add member immediately to the tree
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nodeWidget(String name) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey4.withOpacity(0.5),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        name,
        style: const TextStyle(
          color: CupertinoColors.white,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
