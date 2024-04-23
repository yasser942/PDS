import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import 'package:url_launcher/url_launcher.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  String title = '';
  String body = '';

  List notifications = [];
  CollectionReference ref =
      FirebaseFirestore.instance.collection("notifications");

  String formateDate(timeStamp) {
    var dateFromTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(timeStamp.seconds * 1000);
    return DateFormat('dd-MM-yyyy hh:mm a').format(dateFromTimeStamp);
  }

  Future getData() async {
    var response = await ref.orderBy("date", descending: true).get();
    if (response != null) {
      notifications.clear();
      response.docs.forEach((element) {
        if (this.mounted) {
          // check whether the state object is in tree
          setState(() {
            notifications.add(element.data());
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // Refresh the notifications list
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            centerTitle: true,
            title: const Text(
              'Notifications',
            )),
        body: notifications.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: getData,
                child: ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        shape: RoundedRectangleBorder(
                          //<-- SEE HERE
                          side: BorderSide(
                              width: 0.1,
                              color: Theme.of(context).primaryColor),
                        ),
                        title: Directionality(
                          textDirection: ui.TextDirection.ltr,
                          child: Text(
                            notifications[index]["title"]
                               ,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.date_range,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                Text(
                                  formateDate(notifications[index]["date"]),
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                              ],
                            ),
                            Directionality(
                              textDirection: ui.TextDirection.ltr,
                              child: SelectableText(
                                notifications[index]["body"],
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Directionality(
                              textDirection: ui.TextDirection.ltr,
                              child: GestureDetector(
                                child: Text(notifications[index]["link"],
                                    style: const TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontSize: 14,
                                        color:
                                            Color.fromARGB(255, 13, 123, 212),
                                        fontWeight: FontWeight.w500)),
                                onTap: () {
                                  launch(notifications[index]["link"]);
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ));
  }
}
