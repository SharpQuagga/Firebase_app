import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

class SearchImage extends StatefulWidget {
  @override
  _SearchImageState createState() => _SearchImageState();
}

class _SearchImageState extends State<SearchImage> {
  QuerySnapshot _myComplaints;
  var queryresil = '';
  final _formKey = GlobalKey<FormState>();
  TextEditingController _query = new TextEditingController();

  getData(String query) async {
    return await Firestore.instance
        .collection('Images')
        .where('Name', isEqualTo: query)
        .getDocuments();
  }

  void getRes(String query) {
    getData(query).then((resutls) {
      setState(() {
        _myComplaints = resutls;
        queryresil = _myComplaints.documents.toString();
        print('qqqqs'+queryresil);
        print('sssssssssss' + _myComplaints.documents.toString());
      });
    });
  }

  _inputDecoration(label) => InputDecoration(
      labelText: label,
      fillColor: Colors.white,
      border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(18.0),
          borderSide: new BorderSide()));

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      height: MediaQuery.of(context).size.height,
      child: Form(
        autovalidate: true,
        key: _formKey,
              child: Column(
          children: [
            TextFormField(
              key: new Key('query'),
              controller: _query,
              decoration: _inputDecoration('query'),
              validator: (value) {
                if(isAlpha(value)==false){
                return 'Length too short or wrong query';}
                return null;
              },
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 250,
                          child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blue)),
                textColor: Colors.white,
                elevation: 20,
                color: Colors.blue,
                onPressed: () {
                  getRes(_query.text);
                },
                child: Text('Search'),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            _myComplaints == null || queryresil.isEmpty
                ? Center(
                    child: Text("No record with this query"),
                  )
                : Expanded(
                      child: ListView.builder(
                      itemCount: _myComplaints.documents.length,
                      padding: EdgeInsets.all(5),
                      itemBuilder: (context, i) {
                        return Card(
                          elevation: 20,
                          shadowColor: Colors.white24,
                          child: ListTile(
                            leading: Image.network(_myComplaints.documents[i].data['ImageUrl'].toString()),
                            title: Text(
                                _myComplaints.documents[i].data['Name']),
                            subtitle:
                                Text(_myComplaints.documents[i].data['Caption']),
                          ),
                        );
                      },
                    ),
                )
          ],
        ),
      ),
    );
  }
}
