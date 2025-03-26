import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreInformationPage extends StatelessWidget {
  const MoreInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Uri parseLink = Uri.parse('https://twitter.com/SaverMax_App');
    Future<void> launchUrlExt() async {
      if (!await launchUrl(parseLink, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $parseLink');
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        foregroundColor: Colors.white,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(''),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color.fromRGBO(37, 211, 102, 1)),
        child: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
              height: 70,
            ),
            const Text(
              'FAQ',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),
            const SizedBox(
              height: 60,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 242, 239, 239),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(37, 211, 102, 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: const Column(
                        children: [
                          Text(
                            'How do I earn Max?',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(height: 14),
                          Text(
                            'There are many through which users can earn Max which includes:',
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '1. Downloading image, video, text and audio files directly to your device from SaverMax. You earn 10 Max points for each file you save on your device. Please note that an active internet connection is required to earn Max after the interstitial ad has been loaded and displayed',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            '2. Referring family and friends. You earn 400 Max for each user you refer to SaverMax',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            '3. Watching rewarded video ads from the rewards center. You earn 15 Max points for every ad you watch',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            '4. Participating in special promotions across our official social media handles',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      )),
                  const SizedBox(height: 14),
                  Container(
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(37, 211, 102, 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: const Column(
                        children: [
                          Text(
                            'How long will it take before I receive my redeemed item?',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Typically all reward requests are treated within 7 working days except for airtime redemption which usually takes 24 - 72 hours to be fulfilled. Please note, fulfillment time may vary depending on your location',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      )),
                  const SizedBox(height: 14),
                  Container(
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(37, 211, 102, 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: const Column(
                        children: [
                          Text(
                            'Why am I not able to redeem airtime?',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'There is a limit on how many airtime redeem request users can make daily. If the allocation for the day has been exhausted then you may have to wait till the next day, also note that Non-Nigerians are not eligible to redeem airtime',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      )),
                  const SizedBox(height: 14),
                  Container(
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(37, 211, 102, 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: const Column(
                        children: [
                          Text(
                            'How often can I redeem items?',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Please note that can redeem airtime once every 7 days however other items can be redeemed only once every 30 days. If you have made more than one redeem request within the stipulated time, then order will be cancelled and your Max points refunded within 48 hours',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      )),
                  const SizedBox(height: 14),
                  Container(
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(37, 211, 102, 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: const Column(
                        children: [
                          Text(
                            'Can I exchange my prize for it\'s cash equivalent?',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Unfortunately we do not allow monetary option for rewards by any means either cash, bank deposit, cheque or transfers',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      )),
                  const SizedBox(height: 14),
                  Container(
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(37, 211, 102, 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: const Column(
                        children: [
                          Text(
                            'I am saving files but my Max balance isn\'t increasing?',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Please note that before you can earn when you save files to your device, the interstitial ad must load and display first; otherwise, your points will not be accrued. Ads enable us in fulfilling your gifts and requests',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      )),
                  const SizedBox(height: 14),
                  Container(
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(37, 211, 102, 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: const Column(
                        children: [
                          Text(
                            'Are there limits to how many Max I can earn per day?',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Yes. Please note that you can earn a maximum of 1,000 Max per day; earnings from referrals excluded',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      )),
                  const SizedBox(height: 14),
                  Container(
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(37, 211, 102, 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: const Column(
                        children: [
                          Text(
                            'Are there any limits to how much I can earn in total?',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Absolutely not! You can earn as much as you are able to and redeem your prize as soon as you reach the required Max threshold',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      )),
                  const SizedBox(height: 14),
                  Container(
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(37, 211, 102, 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: const Column(
                        children: [
                          Text(
                            'Will my earned Max ever expire?',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Not at all, all your earnings are securely stored in our database; no one can tamper with them. We place high priority on our users data security',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      )),
                  const SizedBox(height: 14),
                  Container(
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(37, 211, 102, 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: const Column(
                        children: [
                          Text(
                            'I watched ads, saved files, referred friends but did not receive any Max?',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Please ensure you have an active internet connection before performing any of the tasks. Then consider refreshing the rewards page to see your current Max balance',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      )),
                  const SizedBox(height: 14),
                  Container(
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(37, 211, 102, 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: const Column(
                        children: [
                          Text(
                            'Why is my Max balance showing "null"?',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'This is because the system is trying to fetch your current Max balance but failed to do so usually due to internet connectivity issues, please check your internet and refresh',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      )),
                  const SizedBox(height: 14),
                  Container(
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(37, 211, 102, 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Column(
                        children: [
                          Text(
                            'I need more help/information?',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(height: 8),
                          Column(
                            children: [
                              Text(
                                'Feel free to send us a message via the contact page on this app or send us a direct message on X (Twitter). Click the button below to send us a message now',
                                style: TextStyle(fontSize: 14),
                              ),
                              TextButton(
                                  onPressed: () {
                                    launchUrlExt();
                                  },
                                  child: Text(
                                    '@SaverMax_App (Twitter)',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ))
                            ],
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
