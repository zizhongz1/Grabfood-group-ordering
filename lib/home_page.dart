import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = Supabase.instance.client;
  List<dynamic> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    setState(() => isLoading = true);
    final response = await supabase.from('Order_State').select();
    setState(() {
      orders = response;
      isLoading = false;
    });
  }

  Future<void> joinGroup(String orderId) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    final response = await supabase.from('Order_State').select().eq('order_id', orderId).single();
    List<dynamic> currentUsers = response['current_users'] ?? [];
    if (!currentUsers.contains(userId)) {
      currentUsers.add(userId);
      await supabase.from('Order_State').update({'current_users': currentUsers}).eq('order_id', orderId);
      fetchOrders();
    }
  }

  Widget buildOrderCard(dynamic order) {
    final userId = supabase.auth.currentUser?.id;
    final List<dynamic> users = order['current_users'] ?? [];
    final bool joined = users.contains(userId);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(order['group_name'] ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('${order['current_size']}/${order['target_size']} joined'),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16),
                const SizedBox(width: 4),
                Text('${order['distance'] ?? '300 m'}'),
                const SizedBox(width: 16),
                const Icon(Icons.access_time, size: 16),
                const SizedBox(width: 4),
                Text('${order['time'] ?? '10 min'}'),
                const SizedBox(width: 16),
                Text('Est. savings: \$${order['saving'] ?? 5}')
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: joined ? null : () => joinGroup(order['order_id']),
                style: ElevatedButton.styleFrom(
                  backgroundColor: joined ? Colors.grey[300] : Colors.green,
                ),
                child: Text(joined ? 'Joined' : 'Join Group', style: TextStyle(color: joined ? Colors.black : Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Group Orders')),
      body: RefreshIndicator(
        onRefresh: fetchOrders,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search by restaurant, cuisine, dish',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Text('Sort by'),
                        Text('Group size'),
                        Text('Time left', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Distance'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...orders.map(buildOrderCard),
                ],
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          // TODO: Add navigation logic if needed later
        },
      ),
    );
  }
}