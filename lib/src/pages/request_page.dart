import 'package:brooklynbs/src/constants/end_points.dart';
import 'package:brooklynbs/src/provider/loading_state.dart'; // ✅ Import Global Loader Provider
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brooklynbs/src/model/user_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OldRequestsPage extends ConsumerStatefulWidget {
  final UserModel user;
  const OldRequestsPage({super.key, required this.user});

  @override
  _OldRequestsPageState createState() => _OldRequestsPageState();
}

class _OldRequestsPageState extends ConsumerState<OldRequestsPage> {
  List<Map<String, dynamic>> userRequests = [];
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchRequests());
  }

  Future<void> _fetchRequests() async {
    final loader = ref.read(loadingStateProvider); // ✅ Access loader state
    loader.startLoader(context); // ✅ Show loader

    try {
      final response = await http.get(
        Uri.parse(Endpoints.request), // API endpoint
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Endpoints.reqToken}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            userRequests = List<Map<String, dynamic>>.from(data['data'])
                .where((req) =>
                    req['attributes']['student_num'] == widget.user.stID)
                .toList();
            hasError = false;
          });
        }
      } else {
        throw Exception('Failed to load requests');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          hasError = true;
        });
      }
      print('Error fetching requests: $e');
    } finally {
      loader.stopLoader(context); // ✅ Hide loader
    }
  }

  void _showRequestDialog(BuildContext context, Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(request['attributes']['type'] ?? 'Request',
              style: Theme.of(context).textTheme.bodyLarge),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Student Number: ${request['attributes']['student_num']}",
                  style: Theme.of(context).textTheme.bodyMedium),
              Text("Name: ${request['attributes']['name']}",
                  style: Theme.of(context).textTheme.bodyMedium),
              Text(
                  "Message: ${request['attributes']['message'] ?? 'No Message'}",
                  style: Theme.of(context).textTheme.bodyMedium),
              Text("Group: ${request['attributes']['GroupID'] ?? 'N/A'}",
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: Text('Edit',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close',
                  style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Old Requests', style: Theme.of(context).textTheme.bodyLarge),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        iconTheme: Theme.of(context).iconTheme,
      ),
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _fetchRequests, // ✅ Calls function without `ref`
              child: const Text("Refresh Requests"),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: hasError
                  ? const Center(
                      child: Text('Failed to load requests',
                          style: TextStyle(color: Colors.red)),
                    )
                  : userRequests.isEmpty
                      ? Center(
                          child: Text('No requests found for this user',
                              style: Theme.of(context).textTheme.bodyLarge))
                      : ListView.builder(
                          itemCount: userRequests.length,
                          itemBuilder: (context, index) {
                            final request = userRequests[index];
                            return GestureDetector(
                              onTap: () => _showRequestDialog(context, request),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          request['attributes']['type'] ?? 'Request',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.color,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          request['attributes']['createdAt']
                                              .split('T')[0],
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.color),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      request['attributes']['type'] == 'done'
                                          ? Icons.check_circle
                                          : Icons.hourglass_bottom,
                                      color: request['attributes']['type'] == 'done'
                                          ? Colors.green
                                          : Colors.orange,
                                    ),
                                  ],
                                ),
                              ),
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
