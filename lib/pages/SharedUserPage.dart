import 'package:file_icon/file_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:web_test/API/ApiMethodsImpl.dart';
import 'package:web_test/pages/DrawerPage.dart';

class SharedUserFiles extends StatefulWidget {
  final int userId;
  SharedUserFiles(this.userId);

  @override
  _SharedUserFilesState createState() => _SharedUserFilesState(this.userId);
}

class _SharedUserFilesState extends State<SharedUserFiles> {
  ApiMethodsImpl api = ApiMethodsImpl();

  // 0 - PUBLIC
  // 1 - SHARED
  int _currentAccessIndex = 0;
  int userId;
  var data = [];
  String pageTitle = "";
  String _publicPass;

  var _txtPublicPassController = TextEditingController();

  // Constructor
  _SharedUserFilesState(this.userId);

  _getPublicData() async {
    setState(() => data = null);
    data = await api.getPublicData(userId);
    setState(() {});
  }

  _getSharedData() async {
    if (_publicPass == null) //if
      _verifyPublicPass();
    else {
      setState(() => data = null);
      data = await api.getSharedData(userId);
      setState(() {});
    }
  }

  _verifyPublicPass() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text("Authentication"),
          content: TextFormField(
            controller: _txtPublicPassController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(border: OutlineInputBorder()),
          ),
          actions: [
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                // Set it to public dir only once cancelled.
                setState(() {
                  _currentAccessIndex = 0; // 0 - Public Dir.
                  Navigator.pop(context);
                });
              },
            ),
            FlatButton(
              child: Text("Verify"),
              onPressed: () async {
                await api.getSharedKey(userId).then((value) {
                  if (value == _txtPublicPassController.text) {
                    // IF *entered pass == acc public pass*
                    Navigator.pop(context); // Close the dialog.
                    setState(() {
                      _publicPass = value; // Set _publicPass private variable.
                      _currentAccessIndex =
                          1; // Set index of PageView as 1 - Shared.
                    });
                    _getSharedData(); // Call Shared Data Now.
                  } else {
                    // ELSE just show the Authentication Failed toast.
                    Fluttertoast.showToast(
                        msg: "Authentication Failed.",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.TOP,
                        textColor: Colors.white,
                        backgroundColor: Colors.red);
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _getPublicData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: _currentAccessIndex == 0
            ? Text("Public Files")
            : Text("Shared Files"),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Do nothing as of now.
              }),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: data != null
            ? RefreshIndicator(
                onRefresh: () async => _currentAccessIndex == 0
                    ? await _getPublicData()
                    : await _getSharedData(),
                child: data.isEmpty
                    ? ListView(
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
                      )
                    : AnimationLimiter(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: Card(
                                    child: ListTile(
                                      leading: FileIcon(
                                        data[index]["fileName"],
                                        size: 40.0,
                                      ),
                                      title: Text(data[index]['fileName']),
                                      trailing: Text(data[index]['fileSize']),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: data.length,
                        ),
                      ),
              )
            : Center(child: CircularProgressIndicator()),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentAccessIndex,
        onTap: (value) {
          setState(() {
            if (_currentAccessIndex != value) {
              // So that it does not refresh, even if its on the same Dir.
              value == 0 ? _getPublicData() : _getSharedData();
              _currentAccessIndex = value;
            }
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_open),
            title: Text("Public"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_shared),
            title: Text("Shared"),
          ),
        ],
      ),
    );
  }
}
