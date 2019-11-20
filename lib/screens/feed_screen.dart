import 'package:flutter/material.dart';
// import 'package:instagram_clone/services/auth_service.dart';

class FeedScreen extends StatefulWidget {
  static final String id = 'feed_screen';
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'Instagram',
            style: TextStyle(
              fontFamily: 'Billabong',
              fontSize: 35.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Center(
        child: Text('Feed Screen'),
      ),
    );
  }
}
