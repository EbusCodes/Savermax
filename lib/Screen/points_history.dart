import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PointsHistory extends StatefulWidget {
  const PointsHistory({super.key});

  @override
  State<PointsHistory> createState() => _PointsHistoryState();
}

class _PointsHistoryState extends State<PointsHistory> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
        .collection('PointsHistory')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection('Points')
        .orderBy('created', descending: true)
        .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.green))));
          } else if (snapshot.hasError) {
            return Scaffold(
                backgroundColor: Colors.white,
                body: Center(child: Text('Error: ${snapshot.error}')));
          }

          List documentFields = [];
          snapshot.data!.docs.forEach((doc) {
            final fileType = doc.get('FileType');
            final points = doc.get('Points');
            final time = doc.get('Time');
            final hour = doc.get('Hour');
            // Add more fields as needed

            List<Map<String, dynamic>> details = [
              {
                'FileType': fileType,
                'Points': points,
                'Time': time,
                'Hour': hour
              }
            ];
            documentFields.add(details);
          });
          final myValues = documentFields.asMap();
          return Scaffold(
            body: snapshot.data!.docs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/trans_app_icon.png',
                          height: 200,
                          width: 200,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Nothing to show here...',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        )
                      ],
                    ),
                  )
                : GridView(
                    padding: const EdgeInsets.fromLTRB(8, 7, 8, 8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5),
                    children: List.generate(snapshot.data!.docs.length, (index) {
                      
                      return snapshot.hasData
                          ? Container(
                              decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color.fromRGBO(37, 211, 102, 1),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(
                                  0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${myValues[index][0]['Time']}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 11, color: Colors.grey),
                                  ),
                                  SizedBox(height: 2),
                                  Container(
                                      child: myValues[index][0]['FileType'] ==
                                              'Image'
                                          ? Icon(Icons.image,
                                              color: Colors.grey,
                                              weight: double.infinity)
                                          : myValues[index][0]['FileType'] ==
                                                  'Audio'
                                              ? Icon(Icons.audio_file,
                                                  color: Colors.grey,
                                                  weight: double.infinity)
                                              : myValues[index][0]
                                                          ['FileType'] ==
                                                      'Video'
                                                  ? Icon(Icons.video_file,
                                                      color: Colors.grey,
                                                      weight: double.infinity)
                                                  : myValues[index][0]
                                                              ['FileType'] ==
                                                          'Ads'
                                                      ? Icon(
                                                          Icons
                                                              .video_collection_outlined,
                                                          color: Colors.grey,
                                                          weight:
                                                              double.infinity)
                                                      : Icon(
                                                          Icons
                                                              .person_2_outlined,
                                                          color: Colors.grey,
                                                          weight:
                                                              double.infinity)),
                                  SizedBox(height: 2),
                                  Text(
                                    '+${myValues[index][0]['Points']}',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  Text(
                                    '${myValues[index][0]['Hour']}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 11, color: Colors.grey),
                                  ),
                                ],
                              ),
                            )
                          : const Center(child: CircularProgressIndicator());
                    }, growable: false),
                  ),
          );
        });
  }
}
