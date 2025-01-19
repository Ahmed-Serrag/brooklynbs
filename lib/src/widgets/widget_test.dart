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
      // height: MediaQuery.of(context).size.height * 0.3, // 30% of screen height
      // width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
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
            color: const Color(0xFF012868),
            thickness: 1.0,
          ),
          Text(
            'Got a Request? ',
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Theme.of(context).primaryColor,
            ),
            // softWrap: true,
          ),
          // Expanded(
          //   child: Container(
          //     padding: EdgeInsets.all(5),
          //     decoration: BoxDecoration(
          //       color: Colors.grey[500], // Background color for the box
          //       borderRadius: BorderRadius.circular(10), // Rounded corners
          //       // border: Border.all(
          //       //   color: const Color(0xFF012868), // Border color
          //       //   width: 1, // Border thickness
          //       // ),
          //     ),
          //     child: ListView.builder(
          //       padding: const EdgeInsets.symmetric(vertical: 1.0),
          //       itemCount: requests.length,
          //       itemBuilder: (context, index) {
          //         return Padding(
          //           padding: const EdgeInsets.symmetric(vertical: 1.0),
          //           child: Container(
          //             decoration: BoxDecoration(
          //               color: Colors.white, // Light background for items
          //               borderRadius:
          //                   BorderRadius.circular(5), // Rounded corners
          //             ),
          //             child: ListTile(
          //               title: Text(
          //                 requests[index]['description']!,
          //                 style: const TextStyle(
          //                   fontWeight: FontWeight.w500,
          //                   fontSize: 16,
          //                 ),
          //               ),
          //               trailing: IconButton(
          //                 icon: reqIcon == "dynamic"
          //                     ? requests[index]['status'] == "done"
          //                         ? const Icon(Icons.check_circle_outlined,
          //                             color: Colors.green)
          //                         : const Icon(Icons.watch_later_outlined,
          //                             color: Color.fromARGB(255, 207, 187, 4))
          //                     : Icon(
          //                         reqIcon == "done"
          //                             ? Icons.check_circle_outlined
          //                             : Icons.watch_later_outlined,
          //                         color: reqIcon == "done"
          //                             ? Colors.green
          //                             : const Color.fromRGBO(255, 235, 59, 1),
          //                       ),
          //                 onPressed: () {
          //                   // Handle trailing icon tap action
          //                 },
          //               ),
          //             ),
          //           ),
          //         );
          //       },
          //     ),
          //   ),
          // ),
          // const Divider(
          //   color: Color.fromRGBO(153, 57, 66, 1),
          //   thickness: 1.0,
          // ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onNewRequestTap,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: const Color(0xFF012868), // Button color
                    ),
                    child: const Text(
                      'New Request',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCheckOldRequestsTap,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(
                        color: const Color(0xFF012868), // Border color
                      ),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Check All Requests',
                      style: TextStyle(
                        color: const Color(0xFF012868),
                      ),
                    ),
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
