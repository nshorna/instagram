import 'package:flutter/material.dart';
import 'package:sms/sms.dart';

class SmsScreen extends StatefulWidget {
  @override
  _SmsScreenState createState() => _SmsScreenState();
}

class _SmsScreenState extends State<SmsScreen> {
  List<SmsMessage> _allMessagesList;
  bool _isLoading = false;
  SmsQuery _query = new SmsQuery();

  _getAllSms() async {
    print('${DateTime.now()}: Start: _getAllSms');
    _isLoading = true;
    List<SmsMessage> allMessagesList = await _query.getAllSms;
    setState(() {
      _allMessagesList = allMessagesList;
      _isLoading = false;
    });
    print('${DateTime.now()}: Finish: _getAllSms');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: Column(
        children: <Widget>[
          FlatButton(
            child: Text('Get all sms'),
            onPressed: () => _getAllSms(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _allMessagesList.length,
              itemBuilder: (BuildContext ctx, int i) => Text(
                _allMessagesList[i].body,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
