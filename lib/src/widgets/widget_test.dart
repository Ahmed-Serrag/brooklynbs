import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OldRequestsWidget extends StatelessWidget {
  final List<Map<String, String>> requests;
  final VoidCallback onNewRequestTap;
  final VoidCallback onCheckOldRequestsTap;
  final String
      reqIcon; // Your custom icon key (can dynamically determine icons)

  const OldRequestsWidget({
    Key? key,
    required this.requests,
    required this.onNewRequestTap,
    required this.onCheckOldRequestsTap,
    required this.reqIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3, // 60% of screen height
      width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
      decoration: BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor, // Background color
        borderRadius: BorderRadius.circular(20), // Rounded corners
      ),
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Requests',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
            softWrap: true,
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1.0,
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 1.0),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300, // Light background for items
                      borderRadius: BorderRadius.circular(5), // Rounded corners
                    ),
                    child: ListTile(
                      title: Text(
                        requests[index]['description']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      trailing: IconButton(
                        icon: reqIcon == "dynamic"
                            ? requests[index]['status'] == "done"
                                ? const Icon(Icons.check_circle_outlined,
                                    color: Colors.green)
                                : const Icon(Icons.watch_later_outlined,
                                    color: Color.fromARGB(255, 207, 187, 4))
                            : Icon(
                                reqIcon == "done"
                                    ? Icons.check_circle_outlined
                                    : Icons.watch_later_outlined,
                                color: reqIcon == "done"
                                    ? Colors.green
                                    : Colors.yellow,
                              ),
                        onPressed: () {
                          // Handle trailing icon tap action
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1.0,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onNewRequestTap,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        // Rounded button
                      ),
                      side: BorderSide(
                        color: Theme.of(context).primaryColor, // Border color
                      ),
                      backgroundColor: Theme.of(context)
                          .secondaryHeaderColor, // Button color
                    ),
                    child: const Text('New Request'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCheckOldRequestsTap,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(
                        color: Theme.of(context).primaryColor, // Border color
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12), // Rounded button
                      ),
                    ),
                    child: const Text('Check All Requests'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
