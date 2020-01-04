import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_farmer/tabscreen3.dart';
import 'user.dart';
import 'tabscreen.dart';
import 'tabscreen2.dart';
import 'tabscreen3.dart';

 
void main() => runApp(mainscreen());
 
class mainscreen extends StatefulWidget {
  final User user;

 const mainscreen({Key key,this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<mainscreen> {
 List<Widget> tabs;

 int currentTabIndex = 0;

 @override
  void initState() {
    super.initState();
    tabs = [
      TabScreen(),
      TabScreen2(),
      TabScreen3(user: widget.user),
    ];
  }

  String $pagetitle = "My Farmer";

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setSystemUIOverlayStyle(
       SystemUiOverlayStyle(statusBarColor: Colors.green));
    return Scaffold(
      body: tabs[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        currentIndex: currentTabIndex,
        //backgroundColor: Colors.blueGrey,
        type: BottomNavigationBarType.fixed ,
        
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.store,color: Color.fromRGBO(159, 30, 99, 1)),
            title: Text("Product"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart,color: Color.fromRGBO(159, 30, 99, 1)),
            title: Text("My Item"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,color: Color.fromRGBO(159, 30, 99, 1)),
            title: Text("Profile"),
          )
        ],
      ),
    );
  }

  
}
