import 'package:flutter/material.dart';


class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              'Thank you for using SaverMax. Your privacy is important to us. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use SaverMax. Please read this Privacy Policy carefully and if you do not agree with the terms of this Privacy Policy, please do not access the App.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '1. Information We Collect',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(37, 211, 102, 1)
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We may collect personal identification information from Users in a variety of ways, including, but not limited to, when Users visit our App, register on the App, subscribe to the newsletter, respond to a survey, fill out a form, and in connection with other activities, services, features, or resources we make available on SaverMax. Users may be asked for, as appropriate, name, email address, mailing address, and phone number, in some instances users may be required to upload their profile photos',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '2. How We Use Collected Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(37, 211, 102, 1)
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We may collect and use Users personal information for the following purposes:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              'a. To improve customer service: Information you provide helps us respond to your customer service requests and support needs more efficiently.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              'b. To personalize user experience: We may use information in the aggregate to understand how our Users as a group use the services and resources provided on SaverMax.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              'c. To improve SaverMax: We may use feedback you provide to improve our products and services.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              'd. To send periodic emails: We may use the email address to send User information and updates pertaining to their order. It may also be used to respond to their inquiries, questions, and/or other requests.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '3. How We Protect Your Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(37, 211, 102, 1)
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We adopt appropriate data collection, storage, and processing practices and security measures to protect against unauthorized access, alteration, disclosure, or destruction of your personal information, username, password, transaction information, and data collected and stored on SaverMax.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '4. Sharing Your Personal Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(37, 211, 102, 1)
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We do not sell, trade, or rent Users personal identification information to others. We may share generic aggregated demographic information not linked to any personal identification information regarding visitors and users with our business partners, trusted affiliates, and advertisers for the purposes outlined above.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '5. Compliance with Children\'s Online Privacy Protection Act',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(37, 211, 102, 1)
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Protecting the privacy of the very young is especially important. For that reason, we never collect or maintain information on SaverMax from those we actually know are under 13, and no part of SaverMax  is structured to attract anyone under 13.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '6. Changes to This Privacy Policy',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(37, 211, 102, 1)
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We have the discretion to update this Privacy Policy at any time. When we do, we will revise the updated date at the bottom of this page. We encourage Users to frequently check this page for any changes to stay informed about how we are helping to protect the personal information we collect. You acknowledge and agree that it is your responsibility to review this Privacy Policy periodically and become aware of modifications.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '7. Your Acceptance of These Terms',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(37, 211, 102, 1)
              ),
            ),
            SizedBox(height: 8),
            Text(
              'By using SaverMax, you signify your acceptance of this Privacy Policy. If you do not agree to this Privacy Policy, please do not use SaverMax. Your continued use of the SaverMax following the posting of changes to this Privacy Policy will be deemed your acceptance of those changes.',
              style: TextStyle(fontSize: 16),
            ),
            // Add more sections as needed
          ],
        ),
      ),
    );
  }
}