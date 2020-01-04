import 'dart:async';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'user.dart';
import 'item.dart';
import 'main.dart';
 
class ItemDetail extends StatefulWidget {
  final Item item;
  final User user;

  const ItemDetail({Key key, this.item, this.user}): super(key: key);


  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  @override
   Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.deepOrange));
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text('ITEM DETAIL'),
            backgroundColor: Colors.deepOrange,
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
              child: DetailInterface(
                item: widget.item,
                user: widget.user,
              ),
            ),
          )),
    );
  }

    Future<bool> _onBackPressAppBar() async {
    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => mainscreen(
            user: widget.user,
          ),
        ));
    return Future.value(false);
  }
}

class DetailInterface extends StatefulWidget {
  final Item item;
  final User user;
  DetailInterface({this.item, this.user});

  @override
  _DetailInterfaceState createState() => _DetailInterfaceState();
}

class _DetailInterfaceState extends State<DetailInterface> {
  

  @override
  void initState() {
    super.initState();
  
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(),
        Container(
          width: 280,
          height: 200,
          child: Image.network(
              'http://lastyeartit/myfarmer_admin/images/${widget.item.itemimage}.jpg',
              fit: BoxFit.fill),
        ),
        SizedBox(
          height: 10,
        ),
        Text(widget.item.itemtitle.toUpperCase(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
        Text(widget.item.itemtime),
        Container(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              Table(children: [
                TableRow(children: [
                  Text("Item Description",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.item.itemdes),
                ]),
                TableRow(children: [
                  Text("Item Price",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("RM" + widget.item.itemprice),
                ])
             ]),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 350,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                ),
                //MapSample(),
              )
            ],
          ),
        ),
      ],
    );
  }


  
   void _onLogin(String email, BuildContext ctx) {
     String urlgetuser = "http://lastyear.com//myfarmer_admin/get_user.php";

    http.post(urlgetuser, body: {
      "email": email,
    }).then((res) {
      print(res.statusCode);
      var string = res.body;
      List dres = string.split(",");
      print(dres);
      if (dres[0] == "success") {
        User user = new User(
            name: dres[1],
            email: dres[2],
            phone: dres[3],);
        Navigator.push(ctx,
            MaterialPageRoute(builder: (context) => mainscreen(user: user)));
      }
    }).catchError((err) {
      print(err);
    });
  }
}