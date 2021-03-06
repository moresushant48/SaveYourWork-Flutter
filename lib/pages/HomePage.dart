import 'dart:ui';

import 'package:file_icon/file_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:SaveYourWork/API/ApiMethodsImpl.dart';

import 'package:SaveYourWork/Globals.dart' as global;
import 'package:SaveYourWork/pages/DrawerPage.dart';

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
  ApiMethodsImpl api;
  var data = [];

  @override
  void initState() {
    super.initState();
    api = ApiMethodsImpl();
    getData();
  }

  getData() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() => data = null);
    data = await api.getUserFilesById(prefs.getInt('id'));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.transparent,
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
        child: data != null
            ? RefreshIndicator(
                onRefresh: () async => await getData(), // GET DATA ONREFRESH
                child: data.isEmpty // CHECK IF DATA IS EMPTY
                    ? Container(
                        height: MediaQuery.of(context).size.height,
                        child: ListView(
                          padding: EdgeInsets.all(24.0),
                          children: [
                            Center(
                                child: Icon(
                              Icons.assistant_photo,
                              size: 50.0,
                            )),
                            SizedBox(height: 10.0),
                            Center(child: Text("No Files Found"))
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: Padding(
                          // CONTINUE SHOWING DATA ASUSUAL.
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              //
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  "Recently accessed",
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                              ),

                              //
                              SizedBox(
                                height: 10.0,
                              ),

                              // Horizontal RECENTS LISTVIEW
                              Container(
                                height: 135.0,
                                alignment: Alignment.centerLeft,
                                child: AnimationLimiter(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return AnimationConfiguration
                                          .staggeredGrid(
                                        columnCount: data.length,
                                        position: index,
                                        duration:
                                            const Duration(milliseconds: 375),
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

                              //
                              SizedBox(
                                height: 10.0,
                              ),

                              //
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  "All Files",
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                              ),

                              //
                              SizedBox(
                                height: 10.0,
                              ),

                              //
                              Flexible(
                                fit: FlexFit.loose,
                                child: Container(
                                  child: AnimationLimiter(
                                    child: ListView.builder(
                                      primary: false,
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return AnimationConfiguration
                                            .staggeredList(
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
                                                  title: Text(
                                                      data[index]['fileName']),
                                                  trailing: Text(
                                                      data[index]['fileSize']),
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
                              ),
                            ],
                          ),
                        ),
                      ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
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
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData.dark();
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
          leading: FileIcon(suggList[index]),
          title: Text(suggList[index]),
        );
      },
      itemCount: suggList.length,
    );
  }
}
