import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

import '../menu/drawerMenu.dart';
import '../menu/popUpMenu.dart';
import '../utils/sharedPref.dart';
import '../utils/constant.dart';
import '../tabs/home.dart';
import '../tabs/history.dart';


class Tabs extends StatefulWidget {
  final String userId;
  Tabs({Key key,this.userId});

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  List list = List();
  var isLoading =true;

  _fetchData() async {
    setState(() {
     isLoading =true;
    });

    final response = await http.get(Constant.studentUrl);

    if(response.statusCode == 200){
      list = json.decode(response.body) as List;
      setState(() {
       isLoading =false;
      });
    } else {
      throw Exception('failed to load user data');
    }
  }

  String name = "";
  @override
  void initState() {
    getUserId().then(updateUserId);
    _fetchData();
    super.initState();
  }

  void updateUserId(String usename){
    setState(() {
     this.name = usename;
    });
  }

  int _getIndex(List list){
    int index = 0;
    for(var i =0; i<list.length; i++){
      if(list[i]['username'] == name){
        index = i;
        break;
      }
    }
    return index;
  }


  @override
  Widget build(BuildContext context) {
return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: Text(name),
            actions: <Widget>[
              PopUpMenu(),
            ],
            bottom: TabBar(
              tabs: <Widget>[
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.perm_identity)),
                Tab(icon: Icon(Icons.history)),
              ],
            ),
          ),
          body: isLoading ?
          Center(child: CircularProgressIndicator()) :
          TabBarView(
            children: <Widget>[
              Home(),
              Container(
                child: Column(
                  children: <Widget>[
                    HistoryCard(),
                    HistoryCard(),
                    HistoryCard(),
                  ],
                ),
              ),
            ],
          ),

          drawer: Drawer(
            child: DrawerMenu(list:list,index: _getIndex(list),),
          ),
        ),
      ),
    );
  }
}