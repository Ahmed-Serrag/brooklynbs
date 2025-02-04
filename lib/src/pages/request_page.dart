import 'package:brooklynbs/src/constants/end_points.dart';
import 'package:flutter/material.dart';
import 'package:brooklynbs/src/model/user_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OldRequestsPage extends StatefulWidget {
  final UserModel user;
  OldRequestsPage({required this.user});

  @override
  _OldRequestsPageState createState() => _OldRequestsPageState();
}

class _OldRequestsPageState extends State<OldRequestsPage> {
  List<Map<String, dynamic>> userRequests = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
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

        // Filter requests where student_num matches the user.stID
        setState(() {
          userRequests = List<Map<String, dynamic>>.from(data['data'])
              .where(
                  (req) => req['attributes']['student_num'] == widget.user.stID)
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load requests');
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
      print('Error fetching requests: $e');
    }
  }

  void _showRequestDialog(BuildContext context, Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
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
              onPressed: () {
                // Handle edit action
              },
              child: Text('Edit',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close', style: TextStyle(color: Colors.redAccent)),
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
        title:
            Text('Old Requests', style: Theme.of(context).textTheme.bodyLarge),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: Theme.of(context).iconTheme,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : hasError
                ? Center(
                    child: Text('Failed to load requests',
                        style: TextStyle(color: Colors.red)))
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
                              margin: EdgeInsets.only(bottom: 12),
                              padding: EdgeInsets.all(16),
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
                                        request['attributes']['type'] ??
                                            'Request',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.color,
                                        ),
                                      ),
                                      SizedBox(height: 4),
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
                                    color:
                                        request['attributes']['type'] == 'done'
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
    );
  }
}
