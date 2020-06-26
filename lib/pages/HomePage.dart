import 'dart:convert';
import 'dart:ui';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:file_icon/file_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;

import 'package:web_test/Globals.dart' as global;
import 'package:web_test/pages/DrawerPage.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeBody();
  }
}

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  var url = global.API_URL + "list-files/1";
  var downloadUrl = global.API_URL + "uploads/";
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
    return Scaffold(
      backgroundColor: DynamicTheme.of(context).brightness == Brightness.light
          ? Colors.white
          : null,
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
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch(data));
              }),
        ],
      ),
      drawer: AppDrawer(),
      body: Container(
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
                            child: AnimationLimiter(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return AnimationConfiguration.staggeredGrid(
                                    columnCount: data.length,
                                    position: index,
                                    duration: const Duration(milliseconds: 375),
                                    child: ScaleAnimation(
                                      scale: 0.5,
                                      child: FadeInAnimation(
                                        child: GridTile(
                                          child: Container(
                                            width: 120.0,
                                            child: Column(
                                              children: [
                                                Card(
                                                  child: FileIcon(
                                                    data[index]["fileName"],
                                                    size: 100.0,
                                                  ),
                                                ),
                                                SizedBox(height: 4.0),
                                                Text(
                                                  data[index]["fileName"],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: data.length,
                              ),
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
                              child: AnimationLimiter(
                                child: ListView.builder(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 12.0),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration:
                                          const Duration(milliseconds: 375),
                                      child: SlideAnimation(
                                        verticalOffset: 50.0,
                                        child: FadeInAnimation(
                                          child: Card(
                                            child: ListTile(
                                              leading: FileIcon(
                                                data[index]["fileName"],
                                                size: 40.0,
                                              ),
                                              title:
                                                  Text(data[index]['fileName']),
                                              trailing:
                                                  Text(data[index]['fileSize']),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: data.length,
                                ),
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
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  var fileList = <String>[];
  var suggList = <String>[];

  var downloadUrl = global.API_URL + "uploads/";

  DataSearch(data) {
    for (var i = 0; i < data.length; i++) fileList.add(data[i]['fileName']);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return query.isNotEmpty
        ? ListTile(
            title: Text("Downloading " + suggList[0]),
          )
        : Text("");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    suggList = query.isEmpty
        ? []
        : fileList.where((element) => element.contains(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.location_city),
          title: Text(suggList[index]),
        );
      },
      itemCount: suggList.length,
    );
  }
}
