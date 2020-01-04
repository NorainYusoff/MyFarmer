import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/services.dart';
import 'main.dart';
import 'user.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'item.dart';
import 'item_detail.dart';

import 'slideRight.dart';
import 'enterExit.dart';

double perpage = 1;

class TabScreen extends StatefulWidget {
  

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  //final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  List data;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }



  @override
  Widget build(BuildContext context) {
    
   SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.deepOrange));
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            resizeToAvoidBottomPadding: false,
           
            body: RefreshIndicator(
              key: refreshKey,
              color: Colors.deepOrange,
              onRefresh: () async {
                await refreshList();
              },
              child: ListView.builder(
                  //Step 6: Count the data
                  itemCount: data == null ? 1 : data.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Container(
                        child: Column(
                          children: <Widget>[
                            Stack(children: <Widget>[
                              Image.asset(
                                "assets/images/background.png",
                                fit: BoxFit.fitWidth,
                              ),
                              Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Center(
                                    child: Text("MyFarmer",
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: 300,
                                    height: 140,
                                    child: Card(
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.person,
                                                    ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.credit_card,
                                                  ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                            SizedBox(
                              height: 4,
                            ),
                            Container(
                              color: Colors.deepOrange,
                              child: Center(
                                child: Text("No Data",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    if (index == data.length && perpage > 1) {
                      return Container(
                        width: 250,
                        color: Colors.white,
                        child: MaterialButton(
                          child: Text(
                            "Load More",
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {},
                        ),
                      );
                    }
                    index -= 1;
                    return Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Card(
                        elevation: 2,
                        child: InkWell(
                          onTap: () => _onItemDetail( 
                            data[index]['itemid'],
                            data[index]['itemtitle'],
                            data[index]['itemprice'],
                            data[index]['itemdes'],
                            data[index]['itemwoner'],
                            data[index]['itemtime'],
                            data[index]['itemimage'],
                            data[index]['itemrating']
                          ),
                          onLongPress: _onJobDelete,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white),
                                      image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                    "http://lastyeartit/myfarmer_admin/images/${data[index]['itemimage']}.jpg"
                                  )))),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                            data[index]['jobtitle']
                                                .toString()
                                                .toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        RatingBar(
                                          itemCount: 5,
                                          itemSize: 12,
                                          initialRating: double.parse(data[index]['itemrating']
                                                .toString()),
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 2.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text("RM " + data[index]['itemprice']),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(data[index]['jobtime']),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            )));
  }

  

  Future<String> makeRequest() async {
    String urlLoadItem = "http://lastyeartit//myfarmer_admin/load_item.php"; //load_item
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading Item");
    pr.show();
    http.post(urlLoadItem, body: {
      //"email": widget.user.email ?? "notavail",
    }).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        data = extractdata["item"];
        perpage = (data.length / 10);
        print("data");
        print(data);
        pr.dismiss();
      });
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    return null;
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    this.makeRequest();
    return null;
  }

  

  void _onItemDetail(
      String itemid,
      String itemtitle,
      String itemowner,
      String itemdes,
      String itemprice,
      String itemtime,
      String itemimage,
      String  itemrating,)  {

    Item item = new Item(
      itemid: itemid,
      itemtitle: itemtitle,
      itemowner: itemowner,
      itemdes:  itemdes,
      itemprice: itemprice,
      itemtime: itemtime,
      itemimage: itemimage,
      itemrating: itemrating );
    //print(data);
    
    Navigator.push(context, SlideRightRoute(page: ItemDetail(item: item))); //Item 
  }

  void _onJobDelete() {
    print("Delete");
  }
}

