import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ListWIFI.dart';
import 'ListServerConfiguration.dart';
import 'ConfigESPNow.dart';

class ListConfiguration extends StatelessWidget {
  final UserInfoDetails detailsUser;
  ListConfiguration({Key key, @required this.detailsUser}) : super(key: key);
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Configuration'),
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.list, color: Colors.white),
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            }
        ),
      ),
      key: _scaffoldKey,
      drawer: new Drawer(
        child: new ListView(
          children: <Widget> [
            new ListTile(
              title: new Text('Logout'),
              onTap: () {
                _removeAllData();
                final FirebaseAuth _fAuth = FirebaseAuth.instance;
                _fAuth.signOut();
                Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new MyApp(),
                  ),
                );
              },
            ),
          ],
        )
      ),
 
      body: ConfigListView(),
    );
  }

  void setState() {}
}

class ConfigListView extends StatefulWidget {
  @override
  _ConfigListView createState() => new _ConfigListView();
}

class _ConfigListView extends State<ConfigListView> {
  List<String> _configList = <String>[];

  @override
  void initState() {
    _configList.add("WIFI");
    _configList.add("Configuration");
    _configList.add("ESPNow");
  }

  Widget _buildRow(String pair) {
    return new InkWell(
      onTap: ()
      {
        pair = pair.toLowerCase();
        if (pair == "wifi")
        {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ListWIFI()),
          );
        }
        else if(pair == "configuration") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ListServerConfiguration()),
          );
        }
        else if(pair == "espnow") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ConfigESPNow()),
          );
        }
      },
      child: ListTile(
        title: new Text(
          pair,
        ),
        trailing:
          Icon(
            Icons.keyboard_arrow_right, color: Colors.black87, size: 30.0
          ),
      ),
    );
  }

  Widget _buildNotiList()
  {
    return new ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: Colors.black38,
        height: 3,
      ),
      itemCount: _configList.length,
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
      itemBuilder: (BuildContext _context, int i) {
        final int index = i;
        return _buildRow(_configList[index]);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildNotiList();
  }

}

Future<void> _removeAllData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}