import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:savermax/Screen/points_history.dart';

class RedeemHistory extends StatefulWidget {
  const RedeemHistory({super.key});

  @override
  State<RedeemHistory> createState() => _RedeemHistoryState();
}

class _RedeemHistoryState extends State<RedeemHistory> {
  bool? exists;
  CollectionReference fileRef =
      FirebaseFirestore.instance.collection('RedeemHistory');
  final List<Tab> tabs = [
    const Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.card_giftcard),
          SizedBox(
            width: 8,
          ),
          Text('REDEMPTION'),
        ],
      ),
    ),
    const Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.money),
          SizedBox(
            width: 8,
          ),
          Text('POINTS')
        ],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
          return DefaultTabController(
            length: tabs.length,
            child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: const Color.fromRGBO(37, 211, 102, 1),
                  foregroundColor: Colors.white,
                  title: const Text('History'),
                  leading: null,
                  bottom: TabBar(
            dividerColor: Colors.transparent,
            automaticIndicatorColorAdjustment: false,
            unselectedLabelColor: Colors.black,
            labelColor: Colors.white,
            indicatorColor: Colors.transparent,
            tabs: tabs,
          ),
                ),
        body: TabBarView(
            children: [
              DocumentList(),
              PointsHistory()
            ],
          ),),
          );
  }
}

class DocumentList extends StatefulWidget {
  const DocumentList({super.key});

  @override
  State<DocumentList> createState() => _DocumentListState();
}

class _DocumentListState extends State<DocumentList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('RedeemHistory')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection('Redeemed')
          .orderBy('created', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // Extract and save fields from each document into strings
          List documentFields = [];
          snapshot.data!.docs.forEach((doc) {
            final itemName = doc.get('ItemName');
            final itemImage = doc.get('Image');
            final itemOrderID = doc.get('OrderID');
            final itemTime = doc.get('Time');
            final itemStatus = doc.get('Status');
            final itemReason = doc.get('Reason');
            // Add more fields as needed

            List<Map<String, dynamic>> details = [
              {
                'ItemName': itemName,
                'ItemImage': itemImage,
                'ItemOrderID': itemOrderID,
                'ItemTime': itemTime,
                'ItemStatus': itemStatus,
                'ItemReason': itemReason,
              }
            ];
            documentFields.add(details);
          });
          final myValues = documentFields.asMap();

          // Display the list of strings
          return snapshot.data!.docs.isEmpty ? Empty() : ListView.builder(
              itemCount: myValues.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  padding: const EdgeInsets.fromLTRB(5, 15, 5, 15),
                  child: Row(children: [
                    // Image
                    Padding(
                      padding: const EdgeInsets.only(right: 14.0),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        child: Image.network(
                          '${myValues[index][0]['ItemImage']}',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${myValues[index][0]['ItemName']}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${myValues[index][0]['ItemTime']}',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                              Text(
                                  'Order ID: ${myValues[index][0]['ItemOrderID']}',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey))
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${myValues[index][0]['ItemStatus']}',
                            style: TextStyle(
                                color: myValues[index][0]['ItemStatus'] ==
                                            'Pending' ||
                                        myValues[index][0]['ItemStatus'] ==
                                            'Cancelled'
                                    ? Colors.red
                                    : Colors.green,
                                fontSize: 11),
                          ),
                          Text(
                            '${myValues[index][0]['ItemReason']}',
                            style: TextStyle(fontSize: 10.5),
                          )
                        ],
                      ),
                    )
                  ]),
                );
              });
        }
      },
    );
  }
}

class Empty extends StatelessWidget {
  const Empty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}
