import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:v_scada/models/ProductModel.dart';
import '../Networking/api_client.dart';
import '../Networking/api_service.dart';
import '../models/AlertModel.dart';

class ProductScreen extends StatefulWidget {
  final String userId;
  final VoidCallback? onBackToHome;

  const ProductScreen({
    Key? key,
    required this.userId,
    this.onBackToHome,
  }) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late Future<ProductModel> alertFuture;
  final ApiService apiService = ApiService(apiClient: ApiClient());

  @override
  void initState() {
    super.initState();
    alertFuture = apiService.ProductAPi(widget.userId); // Use widget.userId
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: FutureBuilder<ProductModel>(
          future: alertFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final alerts = snapshot.data?.data ?? [];

            return SingleChildScrollView(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // GestureDetector(
                  //   onTap: () => Navigator.pop(context),
                  //   child: Row(
                  //     children: const [
                  //       Icon(Icons.arrow_back, size: 30),
                  //       SizedBox(width: 10),
                  //       Text('Back',
                  //           style: TextStyle(fontSize: 15, color: Colors.black)),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 10),
                  // Center(
                  //   child: Image.asset('assets/logo2.png',
                  //       width: 280, height: 100),
                  // ),
                  // const SizedBox(height: 10),
                  // Card(
                  //   elevation: 10,
                  //   shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(10)),
                  //   child: ClipRRect(
                  //     borderRadius: BorderRadius.circular(10),
                  //     child: Image.asset(
                  //       'assets/contactusimage.png',
                  //       width: double.infinity,
                  //       height: 200,
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 20),
                  const Text(
                    'Products',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  // ListView.builder(
                  //   shrinkWrap: true,
                  //   physics: const NeverScrollableScrollPhysics(),
                  //   itemCount: alerts.length,
                  //   itemBuilder: (context, index) {
                  //     final alert = alerts[index];
                  //
                  //     if (alert.disable != 1) {
                  //       return const SizedBox.shrink(); // hide if disable != 1
                  //     }
                  //
                  //     return NotificationCard(
                  //       title: "Information",
                  //       message: alert.alert,
                  //       time: alert.createdAt,
                  //     );
                  //
                  //
                  //   },
                  // ),


                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.65,
                    ),

                    // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    //   crossAxisCount: 2,
                    //   crossAxisSpacing: 10,
                    //   mainAxisSpacing: 10,
                    //   childAspectRatio: 0.65, // more vertical space
                    // ),


                    itemCount: alerts.length,
                    itemBuilder: (context, index) {
                      final product = alerts[index];
                      return ProductCard(
                        imageUrl: 'http://visioncgwa.com/${product.image}',
                        productName: product.productName,
                        description: product.description,
                        url: product.url,
                      );
                      // return Scaffold(
                      //   body: Center(
                      //     child: CustomCardWidget(),
                      //   ),
                      // );

                    },
                  ),

                  // const SizedBox(height: 10),
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(5, 50, 5, 5),
                  //   child: Text(
                  //     '© 2025 Copyright Vision World Tech PVT.LTD. All Rights Reserved. Designed & Developed by Vision World Tech PVT.LTD.',
                  //     textAlign: TextAlign.center,
                  //     style: TextStyle(
                  //       fontSize: 12,
                  //       fontFamily: 'sans-serif',
                  //       color: Colors.black,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}





// class CustomCardWidget extends StatelessWidget {
//   const CustomCardWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(5),
//       width: 217,
//       // height: double.infinity, // Flutter layouts expand as needed
//       decoration: BoxDecoration(
//         // Replace with your bg_selected_item drawable as a decoration
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         // You can use BoxDecoration to add image or gradient as well
//         // image: DecorationImage(image: AssetImage('assets/bg_selected_item.png')),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             blurRadius: 4,
//             spreadRadius: 1,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           // ImageView
//           Container(
//             height: 150,
//             decoration: BoxDecoration(
//               // Replace with your barwell_drawable
//               color: Colors.grey[200],
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(10),
//                 topRight: Radius.circular(10),
//               ),
//               image: DecorationImage(
//                 image: AssetImage('assets/barwell_drawable.png'), // <-- Use your image asset
//                 fit: BoxFit.cover,
//               ),
//             ),
//             child: const Center(
//               // Icon simulates android:src="@android:drawable/ic_notification_clear_all"
//               child: Icon(Icons.clear_all, size: 40, color: Colors.black54),
//             ),
//           ),
//           // Title TextView
//           Container(
//             margin: const EdgeInsets.only(top: 10, right: 10),
//             child: const Text(
//               "Title",
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           // Description TextView
//           Container(
//             margin: const EdgeInsets.only(top: 10, right: 10),
//             child: const Text(
//               "jkhjhjkhjkhjkhj",
//               style: TextStyle(
//                 color: Color(0xFF888888), // Replace with your greycolor
//                 fontSize: 14,
//               ),
//             ),
//           ),
//           // View Button TextView
//           Container(
//             alignment: Alignment.centerRight,
//             margin: const EdgeInsets.only(
//               top: 50,
//               right: 10,
//               bottom: 10,
//             ),
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//               decoration: BoxDecoration(
//                 color: Colors.blue, // Replace with your button_drawable color
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: const Text(
//                 "View",
//                 style: TextStyle(
//                   color: Colors.white, // Replace with your white color
//                   fontSize: 15,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



// class ProductCard extends StatelessWidget {
//   final String imageUrl;
//   final String productName;
//   final String description;
//   final String url;
//
//   const ProductCard({
//     Key? key,
//     required this.imageUrl,
//     required this.productName,
//     required this.description,
//     required this.url,
//   }) : super(key: key);
//
//   void _launchURL() async {
//     final uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       debugPrint('Could not launch $url');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 5,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Product Image
//           ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//             child: Image.network(
//               imageUrl,
//               height: 120,
//               width: double.infinity,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) => Container(
//                 height: 120,
//                 color: Colors.grey.shade300,
//                 child: const Center(child: Icon(Icons.image_not_supported)),
//               ),
//             ),
//           ),
//
//           // Product Details
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Product Name
//                 Text(
//                   productName,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//
//                 // Fixed Height Scrollable Description
//                 Container(
//                   height: 80, // Fixed height
//                   padding: const EdgeInsets.only(right: 8),
//                   child: Scrollbar(
//                     thumbVisibility: true,
//                     child: SingleChildScrollView(
//                       child: Text(
//                         description,
//                         style: const TextStyle(fontSize: 13, color: Colors.black87),
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 10),
//
//                 // View Button aligned bottom
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: _launchURL,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blueAccent,
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 10,
//                         horizontal: 20,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text(
//                       '🔗 View',
//                       style: TextStyle(fontSize: 14),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// class ProductCard extends StatelessWidget {
//   final String imageUrl;
//   final String productName;
//   final String description;
//   final String url;
//
//   const ProductCard({
//     Key? key,
//     required this.imageUrl,
//     required this.productName,
//     required this.description,
//     required this.url,
//   }) : super(key: key);
//
//   void _launchURL() async {
//     final uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       debugPrint('Could not launch $url');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 5,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Column(
//         mainAxisSize: MainAxisSize.min, // Prevents overflow
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Product Image
//           ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//             child: Image.network(
//               imageUrl,
//               height: 120,
//               width: double.infinity,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) => Container(
//                 height: 120,
//                 color: Colors.grey.shade300,
//                 child: const Center(child: Icon(Icons.image_not_supported)),
//               ),
//             ),
//           ),
//
//           // Product Details
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min, // Prevents overflow
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Product Name
//                 Text(
//                   productName,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 5),
//
//                 // Description
//                 Text(
//                   description,
//                   style: const TextStyle(
//                     fontSize: 13,
//                     color: Colors.black87,
//                   ),
//                   maxLines: 3,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 10),
//
//                 // View Button
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: _launchURL,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blueAccent,
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 8,
//                         horizontal: 16,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text(
//                       '🔗 View',
//                       style: TextStyle(fontSize: 14),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final String description;
  final String url;

  const ProductCard({
    Key? key,
    required this.imageUrl,
    required this.productName,
    required this.description,
    required this.url,
  }) : super(key: key);


  void _launchURL(String urlString) async {
    final Uri uri = Uri.parse(urlString);
    print('imageUrl: $imageUrl');

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      print('Could not launch URL: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ClipRRect(
            //   borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            //   child: Image.network(
            //     imageUrl,
            //     height: 120,
            //     width: double.infinity,
            //     fit: BoxFit.contain,
            //     errorBuilder: (context, error, stackTrace) => Container(
            //       height: 120,
            //       color: Colors.grey.shade300,
            //       child: const Center(child: Icon(Icons.image_not_supported)),
            //     ),
            //   ),
            // ),

            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                imageUrl,
                height: 120,             // fixed height to limit space used
                width: double.infinity,  // full width of card
                fit: BoxFit.contain,     // scale image down to fit inside box, preserve aspect ratio, no cropping
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 120,
                  color: Colors.grey.shade300,
                  child: const Center(child: Icon(Icons.image_not_supported)),
                ),
              ),
            ),

            // Content section with productName and description, wrapped in Expanded
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        style:  TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),
                      ),
                      const SizedBox(height: 6),
                      // You can add description or other content here if needed
                    ],
                  ),
                ),
              ),
            ),

            // Fixed button at bottom
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _launchURL(url),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    '🔗 View',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


// @override
  // Widget build(BuildContext context) {
  //   return SizedBox(
  //     height: 280,
  //     child: Card(
  //       color: Colors.white,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //       elevation: 5,
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           ClipRRect(
  //             borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
  //             child: Image.network(
  //               imageUrl,
  //               height: 120,
  //               width: double.infinity,
  //               fit: BoxFit.contain,
  //               errorBuilder: (context, error, stackTrace) => Container(
  //                 height: 120,
  //                 color: Colors.grey.shade300,
  //                 child: const Center(child: Icon(Icons.image_not_supported)),
  //               ),
  //             ),
  //           ),
  //           Expanded(
  //             child: Padding(
  //               padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   // Text(
  //                   //   productName,
  //                   //   style: const TextStyle(
  //                   //       fontSize: 16, fontWeight: FontWeight.bold),
  //                   //   maxLines: 1,
  //                   //   overflow: TextOverflow.ellipsis,
  //                   // ),
  //
  //                   Text(
  //                     productName,
  //                     style: const TextStyle(
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                     // No maxLines or overflow limits
  //                   ),
  //
  //                   // const SizedBox(height: 6),
  //                   // Expanded(
  //                   //   child: SingleChildScrollView(
  //                   //     child: Text(
  //                   //       description,
  //                   //       style: const TextStyle(fontSize: 13),
  //                   //     ),
  //                   //   ),
  //                   // ),
  //                   const SizedBox(height: 6),
  //                   SizedBox(
  //                     width: double.infinity,
  //                     child: ElevatedButton(
  //                       onPressed: () => _launchURL(url),
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: Colors.blueAccent,
  //                         padding: const EdgeInsets.symmetric(vertical: 10),
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(8),
  //                         ),
  //                       ),
  //                       child: const Text(
  //                         '🔗 View',
  //                         style: TextStyle(fontSize: 14, color: Colors.white),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}



// class ProductCard extends StatelessWidget {
//   final String imageUrl;
//   final String productName;
//   final String description;
//   final String url;
//
//   const ProductCard({
//     Key? key,
//     required this.imageUrl,
//     required this.productName,
//     required this.description,
//     required this.url,
//   }) : super(key: key);
//
//
//
//
//   // import 'package:url_launcher/url_launcher.dart';
//
//   void _launchURL(String urlString) async {
//     final uri = Uri.parse(urlString);
//     if (await canLaunchUrl(uri)) {
//       final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
//       if (!launched) {
//
//       }
//     } else {
//       print('Cannot launch $urlString');
//     }
//   }
//
//   // void _launchURL(String url) async {
//   //   final uri = Uri.parse(url);
//   //   if (await canLaunchUrl(uri)) {
//   //     await launchUrl(uri, mode: LaunchMode.externalApplication);
//   //   } else {
//   //     debugPrint('Could not launch $url');
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 280,
//       child: Card(
//         color: Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         elevation: 5,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Product Image
//             ClipRRect(
//               borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//               child: Image.network(
//                 imageUrl,
//                 height: 120,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) => Container(
//                   height: 120,
//                   color: Colors.grey.shade300,
//                   child: const Center(child: Icon(Icons.image_not_supported)),
//                 ),
//               ),
//             ),
//
//             // Content & Button Area
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Product Name
//                     Text(
//                       productName,
//                       style: const TextStyle(
//                           fontSize: 16, fontWeight: FontWeight.bold),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//
//                     const SizedBox(height: 6),
//
//                     // Scrollable Description
//                     Expanded(
//                       child: SingleChildScrollView(
//                         child: Text(
//                           description,
//                           style: const TextStyle(fontSize: 13),
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(height: 6),
//
//                     // View Button
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () => _launchURL(url), // ✅ Pass URL here
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blueAccent,
//                           padding: const EdgeInsets.symmetric(vertical: 10),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: const Text(
//                           '🔗 View',
//                           style: TextStyle(fontSize: 14, color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
