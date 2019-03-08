import 'package:cmmc_legend_app/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

String apiUrl = BASE_API_URL + "wifi/espnow";

Future<Post> fetchPost() async {
  final response =
    await http.get(apiUrl);
  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return Post.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

Future<Post> createPost(Post post) async{
  final response = 
  await http.post(apiUrl,
      headers: {
        "content-type": "application/json",
        'Accept': 'application/json',
      },
      body: json.encode(post.toJson())
  );
  return Post.fromJson(json.decode(response.body));
}

class Post {
  final String mac;
  final String self_mac;
  final String deviceName;

  Map<String, dynamic> toJson() => _toJson(this);

  Post({this.mac, this.deviceName, this.self_mac});

  Map<String, dynamic> _toJson(Post post) {
    return <String, String>
    {
      'mac': post.mac,
      'deviceName': post.deviceName,
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      mac: json['mac'],
      self_mac: json['self_mac'],
      deviceName: json['deviceName'],
    );
  }
}

class ConfigESPNow extends StatelessWidget {
  ConfigESPNow({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('ESPNow'),
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop(null);
            }
        ),
      ),
      body: new ConfigDetailView(),
    );
  }
}

class ConfigDetailView extends StatefulWidget {
  @override
  _ConfigDetailView createState() => new _ConfigDetailView();
}

class _ConfigDetailView extends State<ConfigDetailView> {
  
  Future<Post> post;

  @override
  Widget build(BuildContext context) {

    var macController = new TextEditingController();
    var deviceNameController = new TextEditingController();
    String mac;
    String deviceName;
    post = fetchPost();
    
    return new Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: FutureBuilder<Post>(
        future: post,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              mac = snapshot.data.self_mac;
              deviceName = snapshot.data.deviceName;

              macController.text = mac;
              deviceNameController.text = deviceName;
            }
            else if (snapshot.hasError) {
              return new Center(child:Text("${snapshot.error}"));
            }
            else if (!snapshot.hasData) {
              return  new Center(child: CircularProgressIndicator());
            }
            
            return new Container(
              child: new Column(
                children: <Widget>[
                  new TextField(
                    controller: macController,
                    obscureText: false,
                    autocorrect: false, // turns off auto-correct
                    decoration: InputDecoration(
                      labelText: "MAC",
                    ),
                    onChanged: (str) {
                      mac = str;
                    },
                    onSubmitted: (str) {
                      mac = str;
                    },
                  ),
                  new TextField(
                    controller: deviceNameController,
                    obscureText: true,
                    autocorrect: false, // turns off auto-correct
                    decoration: InputDecoration(
                      labelText: "Device Name",
                    ),
                    onChanged: (str) {
                      deviceName = str;
                    },
                    onSubmitted: (str) {
                      deviceName = str;
                    },
                  ),
                  new Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16))
                  ,
                  new MaterialButton(
                    color: Colors.blueAccent,
                    child: Text('Submit'),
                    onPressed: () {

                      Post post = new Post(mac: mac, deviceName: deviceName);
                      createPost(post).then((onValue) {
                        
                      });
                    },
                  ), 
                ]
              )
            );
          }
      )
    );
  }
}