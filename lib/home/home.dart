import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'drawer/help.dart';
import 'drawer/language.dart';
import 'drawer/post.dart';
import 'drawer/profile.dart';
import 'drawer/theme.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final dbRef = FirebaseDatabase.instance.ref().child("Post");
  final User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Profile()));
              },
              leading:
                  Icon(Icons.person, size: 28, color: Colors.grey.shade800),
              title: Text(
                "Profile",
                style:
                    GoogleFonts.lato(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Post()));
              },
              leading: Icon(Icons.post_add_sharp,
                  size: 28, color: Colors.grey.shade800),
              title: Text(
                "Create post",
                style:
                    GoogleFonts.lato(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MyTheme()));
              },
              leading: Icon(Icons.color_lens_sharp,
                  size: 28, color: Colors.grey.shade800),
              title: Text(
                "Theme",
                style:
                    GoogleFonts.lato(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Language()));
              },
              leading:
                  Icon(Icons.language, size: 28, color: Colors.grey.shade800),
              title: Text(
                "Language",
                style:
                    GoogleFonts.lato(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
            ListTile(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
              },
              leading:
                  Icon(Icons.logout, size: 28, color: Colors.grey.shade800),
              title: Text(
                "Logout",
                style:
                    GoogleFonts.lato(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Help()));
              },
              leading: Icon(Icons.help_center_sharp,
                  size: 28, color: Colors.grey.shade800),
              title: Text(
                "Help",
                style:
                    GoogleFonts.lato(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Gimpact"),
        backgroundColor: Colors.purple,
        centerTitle: false,
        titleSpacing: 0,
        elevation: 20,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.refresh_sharp)),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: FirebaseAnimatedList(
              query: dbRef.child("Post List"),
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FadeInImage.assetNetwork(
                          placeholder: "assets/image/foko.webp",
                          image: snapshot.value.toString()),
                      Text(snapshot.value.toString()),
                      Text(snapshot.value.toString()),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
