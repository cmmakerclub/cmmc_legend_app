import 'package:cmmc_legend_app/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

String apiUrl = BASE_API_URL + 'wifi/ap';

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
  final String ssid;
  final String password;
  final String ap_ssid;
  final String ap_password;
  String status;

  Map<String, dynamic> toJson() => _toJson(this);

  Post({this.ssid, this.password, this.ap_ssid, this.ap_password, this.status});

  Map<String, dynamic> _toJson(Post post) {
    return <String, String>
    {
      // 'ssid': post.ssid,
      // 'password': post.password,
      'ap_ssid': post.ap_ssid,
      'ap_password': post.ap_password,
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      ssid: json['ssid'],
      password: json['password'],
      ap_ssid: json['ssid'],
      ap_password: json['password'],
      status: json['status']
    );
  }
}

class ConfigAP extends StatelessWidget {
  ConfigAP({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('AP'),
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

    var ssidController = new TextEditingController();
    var passwordController = new TextEditingController();
    String ssid;
    String password;
    post = fetchPost();
    
    return new Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: FutureBuilder<Post>(
        future: post,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              ssid = snapshot.data.ssid;
              password = snapshot.data.password;

              ssidController.text = ssid;
              passwordController.text = password;
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
                    controller: ssidController,
                    obscureText: false,
                    autocorrect: false, // turns off auto-correct
                    decoration: InputDecoration(
                      labelText: "SSID",
                    ),
                    onChanged: (str) {
                      ssid = str;
                      print(ssid);
                    },
                    onSubmitted: (str) {
                      ssid = str;
                      print(ssid);
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
                  new Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16))
                  ,
                  new MaterialButton(
                    color: Colors.blueAccent,
                    child: Text('Submit'),
                    onPressed: () {

                      Post post = new Post(ap_ssid: ssid, ap_password: password);
                      createPost(post).then((onValue) {
                        print(onValue);
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