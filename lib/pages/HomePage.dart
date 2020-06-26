import 'dart:convert';
import 'dart:ui';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:file_icon/file_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

import 'package:web_test/Globals.dart' as global;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DynamicTheme.of(context).brightness == Brightness.light
          ? Colors.white
          : null,
      body: HomeBody(),
      appBar: AppBar(
        textTheme: TextTheme(
            headline6: TextStyle(
                color: DynamicTheme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white)),
        title: Text("Home"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
            color: DynamicTheme.of(context).brightness == Brightness.light
                ? Colors.grey
                : Colors.white),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountEmail: Text("moresushant48@gmail.com"),
              accountName: Text("Sushant More"),
              otherAccountsPictures: [
                IconButton(
                    icon: Icon(Icons.brightness_4),
                    color: Colors.white,
                    onPressed: () {
                      DynamicTheme.of(context).setBrightness(
                          Theme.of(context).brightness == Brightness.dark
                              ? Brightness.light
                              : Brightness.dark);
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  var url = global.API_URL + "list-files/1";
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
    return Container(
      alignment: Alignment.center,
      child: data != null
          ? Container(
              child: Column(
                children: [
                  // HORIZONTAL RECENTLY VIEWED ITEM LIST.
                  Container(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Recently Viewed",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          height: 150.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return GridTile(
                                child: Column(
                                  children: [
                                    Card(
                                      child: FileIcon(
                                        data[index]["fileName"],
                                        size: 100.0,
                                      ),
                                    ),
                                    SizedBox(height: 4.0),
                                    Text(data[index]["fileName"])
                                  ],
                                ),
                              );
                            },
                            itemCount: data.length,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ALL FILES LIST.
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              "All Files",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 12.0),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    leading: FileIcon(
                                      data[index]["fileName"],
                                      size: 40.0,
                                    ),
                                    title: Text(data[index]['fileName']),
                                    trailing: Text(data[index]['fileSize']),
                                  ),
                                );
                              },
                              itemCount: data.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          : CircularProgressIndicator(),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    throw UnimplementedError();
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {});
  }

  @override
  Widget buildResults(BuildContext context) {}

  @override
  Widget buildSuggestions(BuildContext context) {}
}
