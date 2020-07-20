import 'package:flutter/material.dart';
import 'package:start_up/upload_image.dart';
import 'package:start_up/search_image.dart';

class OptionPage extends StatefulWidget {
  @override
   _OptionPageState createState() => _OptionPageState();
}
class _OptionPageState extends State<OptionPage> {

  int _selectedPage = 0;
  final pageOptions = [
    UploadImage(),
    SearchImage(),
  ];

   @override
   Widget build(BuildContext context) {
     const primaryColor = Colors.blue;
    return  Scaffold(
         appBar: AppBar(
           centerTitle: true,
           backgroundColor: primaryColor,
           title: Text("Firebase App",),),
         bottomNavigationBar: BottomNavigationBar(
           currentIndex: _selectedPage,
           backgroundColor: Colors.blue,
          selectedLabelStyle: TextStyle(fontSize: 13),
           elevation: 30,
           unselectedItemColor: Colors.grey,
           selectedItemColor: Colors.white,
           selectedFontSize: 10,
           onTap: (int index){
             setState(() {
               _selectedPage = index;
             });
           },
           items: [
             BottomNavigationBarItem(
               icon: Icon(Icons.map),
               backgroundColor: Colors.grey[50],
               title: Text("Upload")
             ),
             BottomNavigationBarItem(
               icon: Icon(Icons.account_circle),
               title: Text("Search")
             ),
           ],
         ),
         body: pageOptions[_selectedPage]
       );
  }
} 