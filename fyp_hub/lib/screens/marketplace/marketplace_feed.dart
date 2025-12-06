import 'package:flutter/material.dart';
import '../../services/marketplace_service.dart';
import '../../models/supervisor.dart';

class MarketplaceFeed extends StatelessWidget {
  const MarketplaceFeed({super.key});

  @override
  Widget build(BuildContext context) {
    final MarketplaceService _marketplaceService = MarketplaceService();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Marketplace'),
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Ideas'),
              Tab(text: 'Teammates'),
              Tab(text: 'Supervisors'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const Center(child: Text("Feed for Project Ideas (Coming Soon)")),
            const Center(
              child: Text("Feed for Finding Teammates (Coming Soon)"),
            ),

            // --- TAB 3: SUPERVISORS LIST ---
            StreamBuilder<List<Supervisor>>(
              stream: _marketplaceService.getAllSupervisors(),
              builder: (context, snapshot) {
                // 1. Loading State
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // 2. Error State
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                // 3. Empty State
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No supervisors found yet."));
                }

                // 4. Success State (Show the List)
                final supervisors = snapshot.data!;
                return ListView.builder(
                  itemCount: supervisors.length,
                  itemBuilder: (context, index) {
                    final supervisor = supervisors[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.purple.shade100,
                          child: Text(
                            supervisor.name[0],
                          ), // First letter of name
                        ),
                        title: Text(supervisor.name),
                        subtitle: Text(
                          supervisor.interests.join(", "),
                        ), // Show interests
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // TODO: Open Supervisor Details (or Request Form)
                        },
                      ),
                    );
                  },
                );
              },
            ),
            // -------------------------------
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO: Navigate to CreatePostScreen
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
