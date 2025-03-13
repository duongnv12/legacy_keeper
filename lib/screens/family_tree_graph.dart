import 'package:flutter/cupertino.dart';
import 'package:graphview/GraphView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_family_member_screen.dart'; // To navigate to the "Add Member" screen

class FamilyTreeGraph extends StatefulWidget {
  const FamilyTreeGraph({Key? key}) : super(key: key);

  @override
  _FamilyTreeGraphState createState() => _FamilyTreeGraphState();
}

class _FamilyTreeGraphState extends State<FamilyTreeGraph> {
  final Graph graph = Graph()..isTree = true; // Define the tree graph
  final BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();
  bool isLoading = true; // Add a loading state
  bool hasError = false; // Add an error state

  @override
  void initState() {
    super.initState();
    _configureTree(); // Configure the tree layout
    _buildTree(); // Build the family tree
  }

  void _configureTree() {
    builder
      ..siblingSeparation = (100)
      ..levelSeparation = (150)
      ..subtreeSeparation = (150)
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;
  }

  Future<void> _buildTree() async {
    try {
      print("Fetching ancestor...");
      final ancestorSnapshot = await FirebaseFirestore.instance
          .collection('ancestors')
          .orderBy('createdAt', descending: false)
          .limit(1)
          .get();

      if (ancestorSnapshot.docs.isNotEmpty) {
        final ancestorData = ancestorSnapshot.docs.first.data();
        final ancestorId = ancestorSnapshot.docs.first.id;

        print("Ancestor found: ${ancestorData['name']}");

        // Create the ancestor's root node
        final Node rootNode = Node.Id(ancestorData['name']);
        graph.addNode(rootNode);

        // Recursively build the subtree starting from the ancestor
        await _buildSubTree(rootNode, ancestorId);

        setState(() {
          isLoading = false; // Data loading complete
          hasError = false; // No errors
        });
      } else {
        print("No ancestor found in Firestore.");
        setState(() {
          isLoading = false;
          hasError = true; // Trigger error state
        });
      }
    } catch (e) {
      print("Error building tree: $e");
      setState(() {
        isLoading = false;
        hasError = true; // Trigger error state
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
        print("Child found: ${childData['name']}");

        final Node childNode = Node.Id(childData['name']);
        graph.addNode(childNode);
        graph.addEdge(parentNode, childNode); // Connect child to parent

        // Recursively build subtree for each child
        await _buildSubTree(childNode, child.id);
      }
    } catch (e) {
      print("Error building subtree: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Family Tree"),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            if (isLoading)
              const Center(
                child: CupertinoActivityIndicator(), // Show a loading spinner
              )
            else if (hasError)
              const Center(
                child: Text(
                  "An error occurred while fetching data. Please try again.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: CupertinoColors.systemRed),
                ),
              )
            else
              InteractiveViewer(
                constrained: false,
                boundaryMargin: const EdgeInsets.all(100),
                minScale: 0.1,
                maxScale: 1.5,
                child: GraphView(
                  graph: graph,
                  algorithm: BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder)),
                  builder: (Node node) {
                    return nodeWidget(node.key!.value); // Display each node
                  },
                ),
              ),
            // Floating "add member" button
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
                    CupertinoPageRoute(builder: (context) => const AddFamilyMemberScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget nodeWidget(String name) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        name,
        style: const TextStyle(color: CupertinoColors.white),
      ),
    );
  }
}
