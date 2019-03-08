import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'ConfigAP.dart';
import 'ConfigSTA.dart';

class ListWIFI extends StatelessWidget {
  ListWIFI({Key key}) : super(key: key);
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('WIFI'),
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(null);
            }
        ),
      ),
      key: _scaffoldKey,
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
    _configList.add("AP");
    _configList.add("STA");
  }

  Widget _buildRow(String pair) {
    return new InkWell(
      onTap: ()
      {
        pair = pair.toLowerCase();
        if (pair == "ap") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ConfigAP()),
          );
        }
        else if (pair == "sta")
        {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ConfigSTA()),
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