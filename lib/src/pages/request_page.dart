import 'package:brooklynbs/src/constants/end_points.dart';
import 'package:brooklynbs/src/provider/loading_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brooklynbs/src/model/user_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
    final loader = ref.read(loadingStateProvider);
    loader.startLoader(context);

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? stToken = prefs.getString('st_token');

      final response = await http.get(
        Uri.parse(Endpoints.request),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $stToken',
        },
      );

      if (response.statusCode == 200) {
        loader.stopLoader(context);
        final data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            userRequests = List<Map<String, dynamic>>.from(data['data'])
                .where((request) =>
                    request['type'] != 'edit') // Filter "edit" requests
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
      loader.stopLoader(context);
    }
  }

  void _showRequestDialog(BuildContext context, Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            request['type'],
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow("About", request['field']),
              _buildInfoRow("Message", request['value']),
              _buildInfoRow("Status", request['status'],
                  defaultValue: "Pending"),
              _buildInfoRow(
                "Created At",
                _formatDate(request['created_at']),
                defaultValue: "Unknown",
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {}, // TODO: Implement Edit functionality
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
              child: const Text('Edit'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  /// Helper widget to build info rows in the dialog
  Widget _buildInfoRow(String label, dynamic value,
      {String defaultValue = "N/A"}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        "$label: ${value ?? defaultValue}",
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  /// Formats the date from "yyyy-MM-dd HH:mm:ss" to "dd MMM yyyy"
  String _formatDate(String? dateString) {
    if (dateString == null) return "N/A";
    try {
      final dateTime = DateTime.parse(dateString);
      return "${dateTime.day} ${_getMonthName(dateTime.month)} ${dateTime.year}";
    } catch (e) {
      return "Invalid Date";
    }
  }

  /// Helper function to get month name from month number
  String _getMonthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Old Requests',
              style: Theme.of(context).textTheme.bodyLarge),
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
                                onTap: () =>
                                    _showRequestDialog(context, request),
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
                                            "Request #${index + 1}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "Type: ${request['type']}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                          ),
                                          Text(
                                            "Status: ${request['status']}",
                                            style: TextStyle(
                                              color:
                                                  request['status'] == 'pending'
                                                      ? Colors.orange
                                                      : Colors.green,
                                            ),
                                          ),
                                          Text(
                                            "Created at: ${request['created_at'].split(' ')[0]}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        request['status'] == 'pending'
                                            ? Icons.hourglass_bottom
                                            : Icons.check_circle,
                                        color: request['status'] == 'pending'
                                            ? Colors.orange
                                            : Colors.green,
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
      ),
    );
  }
}
