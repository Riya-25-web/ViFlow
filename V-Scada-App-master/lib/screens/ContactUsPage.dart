import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final String phoneNumbers = '+91-7742714000 , +91-8505000844';

  Future<void> sendEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'admin@visionworldtech.com',
      queryParameters: {
        'subject': '${_nameController.text}',
        'body': _messageController.text,
      },
    );

    if (!await launchUrl(emailLaunchUri,
        mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not launch email app")),
      );
    }
  }

  Future<void> openWebsite() async {
    const url = 'https://visionworldtech.com/';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch the URL')),
      );
    }
  }

  Future<void> openGmail() async {
    final intent = AndroidIntent(
      action: 'android.intent.action.SENDTO',
      data: Uri.encodeFull(
          'mailto:admin@visionworldtech.com?subject=${_nameController.text}&body=${_messageController.text}'),
      package: 'com.google.android.gm',
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );

    try {
      await intent.launch();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gmail app not available")),
      );
    }
  }

  void _copyEmail(BuildContext context) {
    Clipboard.setData(const ClipboardData(text: 'admin@visionworldtech.com'));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Email copied to clipboard")),
    );
  }

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: phoneNumbers));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Phone numbers copied to clipboard")),
    );
  }

  void _copyNumber(BuildContext context) {
    Clipboard.setData(ClipboardData(text: phoneNumbers));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Phone numbers copied to clipboard")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children:  [
                      Icon(Icons.arrow_back, size: 30),
                      SizedBox(width: 10),
                      Text('Back',
                          style: TextStyle(fontSize: 15, color: Theme.of(context).textTheme.bodyLarge!.color)),
                    ],
                  ),
                ),

                Center(
                  child:
                      Image.asset('assets/logo2.png', width: 280, height: 100),
                ),

                // Image Card
                Center(
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/contactusimage.png',
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Meet Us Section
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Meet Us',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            const Icon(Icons.phone,
                                size: 20, color: Colors.green),
                            const SizedBox(width: 5),
                            GestureDetector(
                              onLongPress: () => _copyToClipboard(context),
                              child: Text(
                                phoneNumbers,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // const Row(
                        //   children: [
                        //     Icon(Icons.phone, size: 20,color: Colors.green,),
                        //     SizedBox(width: 5),
                        //     Text('+91-7742714000 , +91-8505000844',
                        //         style: TextStyle(fontSize: 15)),
                        //   ],
                        // ),
                        const SizedBox(height: 10),
                        // const Row(
                        //   children: [
                        //     Icon(Icons.email, size: 20,color: Colors.red,),
                        //     SizedBox(width: 5),
                        //     Text('admin@visionworldtech.com',
                        //         style: TextStyle(fontSize: 15, color: Colors.blue)),
                        //   ],
                        // ),

                        // Inside your widget tree:
                        Row(
                          children: [
                            const Icon(Icons.email,
                                size: 20, color: Colors.red),
                            const SizedBox(width: 5),
                            GestureDetector(
                              onTap: openGmail,
                              onLongPress: () => _copyEmail(context),
                              child: const Text(
                                'admin@visionworldtech.com',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // Clickable Website Link
                        GestureDetector(
                          onTap: openWebsite,
                          child: Row(
                            children: const [
                              Icon(
                                Icons.language,
                                size: 20,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'https://visionworldtech.com/',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Contact Us Form
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Contact Us',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: 'Enter user name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _messageController,
                          maxLines: 8,
                          maxLength: 400,
                          decoration: InputDecoration(
                            hintText: 'Enter message',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: sendEmail,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Send',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
