import 'dart:convert';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("SaveYourWork"),
      ),
      body: HomeBody(),
    );
  }
}

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  var url = "https://saveyourwork.herokuapp.com/rest/list-files/1";
  var data;

  @override
  void initState() {
    super.initState();

    getData();
  }

  getData() async {
    data = await http.get(url);
    data = jsonDecode(data.body);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: data != null
          ? ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.insert_drive_file),
                  title: Text(data[index]["fileName"]),
                  trailing: Text(data[index]["fileSize"]),
                );
              },
              itemCount: data.length,
            )
          : CircularProgressIndicator(),
    );
  }
}