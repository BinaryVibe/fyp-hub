import 'package:flutter/material.dart';

class MarketplaceFeed extends StatelessWidget {
  const MarketplaceFeed({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. DefaultTabController controls the 3 tabs automatically
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        // 2. We put the TabBar inside an AppBar (or just a Column)
        appBar: AppBar(
          title: const Text('Marketplace'),
          automaticallyImplyLeading: false, // Removes the back button
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Ideas'),
              Tab(text: 'Teammates'),
              Tab(text: 'Supervisors'),
            ],
          ),
        ),
        // 3. The TabBarView holds the content for each tab
        body: const TabBarView(
          children: [
            Center(child: Text("Feed for Project Ideas (Coming Soon)")),
            Center(child: Text("Feed for Finding Teammates (Coming Soon)")),
            Center(child: Text("List of Supervisors (Coming Soon)")),
          ],
        ),
        // 4. Your "Create Post" button floats here
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO: Navigate to CreatePostScreen
            print("Create Post Clicked");
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
