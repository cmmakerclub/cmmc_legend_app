// import 'dart:_http';
import 'dart:async';
import 'dart:convert';

import 'package:cmmc_legend_app/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

String apiUrl = BASE_API_URL + 'mqtt';

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
        // HttpHeaders.contentTypeHeader: 'application/json'
      },
      body: json.encode(post.toJson())
  );
  return Post.fromJson(json.decode(response.body));
}

class Post {
  final String host;
  final String port;
  final String clientId;
  final String username;
  final String password;
  final String prefix;
  final String deviceName;
  final String publishRateSecond;
  String lwt;
  bool enableLWT;

  Map<String, dynamic> toJson() => _toJson(this);

  Post({this.host,
        this.port,
        this.clientId,
        this.username,
        this.password,
        this.prefix,
        this.deviceName,
        this.publishRateSecond,
        this.enableLWT,
        this.lwt
        });

  Map<String, dynamic> _toJson(Post post) {
    return <String, String>
    {
      'host': post.host,
      'port': post.port,
      'clientId': post.clientId,
      'username': post.username,
      'password': post.password,
      'prefix': post.prefix,
      'deviceName': post.deviceName,
      'publishRateSecond': post.publishRateSecond,
      'lwt': post.lwt,
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      host: json['host'],
      port: json['port'],
      clientId: json['clientId'],
      username: json['username'],
      password: json['password'],
      prefix: json['prefix'],
      deviceName: json['deviceName'],
      publishRateSecond: json['publishRateSecond'],
      lwt: json['lwt'],
      enableLWT: json['lwt'] == "1" ? true : false,
    );
  }
}

class ConfigMQTT extends StatelessWidget {
  ConfigMQTT({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('MQTT'),
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

    var hostController = new TextEditingController();
    var portController = new TextEditingController();
    var clientIdController = new TextEditingController();
    var usernameController = new TextEditingController();
    var passwordController = new TextEditingController();
    var prefixController = new TextEditingController();
    var deviceNameController = new TextEditingController();
    var publishRateSecondController = new TextEditingController();
    var lwtController = new TextEditingController();

    String host;
    String port;
    String clientId;
    String username;
    String password;
    String prefix;
    String deviceName;
    String publishRateSecond;
    String lwt;
    bool enableLWT = false;

    post = fetchPost();
    
    return new Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: FutureBuilder<Post>(
        future: post,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // ssid = snapshot.data.ssid;
              // password = snapshot.data.password;

              // ssidController.text = ssid;
              // passwordController.text = password;
            }
            else if (snapshot.hasError) {
              return new Center(child:Text("${snapshot.error}"));
            }
            else if (!snapshot.hasData) {
              return  new Center(child: CircularProgressIndicator());
            }
            
            return new SingleChildScrollView(
              child: new Column(
                children: <Widget>[
                  new TextField(
                    controller: hostController,
                    obscureText: false,
                    autocorrect: false, // turns off auto-correct
                    decoration: InputDecoration(
                      labelText: "Host",
                    ),
                    onChanged: (str) {
                      host = str;
                    },
                    onSubmitted: (str) {
                      host = str;
                    },
                  ),
                  new TextField(
                    controller: portController,
                    obscureText: false,
                    autocorrect: false, // turns off auto-correct
                    decoration: InputDecoration(
                      labelText: "Port",
                    ),
                    onChanged: (str) {
                      port = str;
                    },
                    onSubmitted: (str) {
                      port = str;
                    },
                  ),
                  new TextField(
                    controller: clientIdController,
                    obscureText: false,
                    autocorrect: false, // turns off auto-correct
                    decoration: InputDecoration(
                      labelText: "Client Id",
                    ),
                    onChanged: (str) {
                      clientId = str;
                    },
                    onSubmitted: (str) {
                      clientId = str;
                    },
                  ),
                  new TextField(
                    controller: usernameController,
                    obscureText: false,
                    autocorrect: false, // turns off auto-correct
                    decoration: InputDecoration(
                      labelText: "Username",
                    ),
                    onChanged: (str) {
                      username = str;
                    },
                    onSubmitted: (str) {
                      username = str;
                    },
                  ),
                  new TextField(
                    controller: passwordController,
                    obscureText: true,
                    autocorrect: false, // turns off auto-correct
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                    onChanged: (str) {
                      password = str;
                    },
                    onSubmitted: (str) {
                      password = str;
                    },
                  ),
                  new TextField(
                    controller: prefixController,
                    obscureText: false,
                    autocorrect: false, // turns off auto-correct
                    decoration: InputDecoration(
                      labelText: "Prefix",
                    ),
                    onChanged: (str) {
                      prefix = str;
                    },
                    onSubmitted: (str) {
                      prefix = str;
                    },
                  ),
                  new TextField(
                    controller: deviceNameController,
                    obscureText: false,
                    autocorrect: false, // turns off auto-correct
                    decoration: InputDecoration(
                      labelText: "Device name",
                    ),
                    onChanged: (str) {
                      deviceName = str;
                    },
                    onSubmitted: (str) {
                      deviceName = str;
                    },
                  ),
                  new TextField(
                    controller: publishRateSecondController,
                    obscureText: false,
                    autocorrect: false, // turns off auto-correct
                    decoration: InputDecoration(
                      labelText: "Publish RateSecond",
                    ),
                    onChanged: (str) {
                      publishRateSecond = str;
                    },
                    onSubmitted: (str) {
                      publishRateSecond = str;
                    },
                  ),
                  new Row(
                    children: <Widget>[
                      new Text("Enable LWT"),
                      new Switch(
                        onChanged: (bool value) {
                          enableLWT = value;
                          lwt = (enableLWT == true) ? "1" : "0";
                        }, 
                        value: enableLWT,
                      )
                    ],
                  )
                  ,
                  new Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16))
                  ,
                  new MaterialButton(
                    color: Colors.blueAccent,
                    child: Text('Submit'),
                    onPressed: () {

                      Post post = new Post( host: host,
                                            port: port,
                                            clientId: clientId,
                                            username: username,
                                            password: password,
                                            prefix: prefix,
                                            deviceName: deviceName,
                                            publishRateSecond: publishRateSecond,
                                            lwt: lwt
                                            );
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