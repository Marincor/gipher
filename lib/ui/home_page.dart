// ignore_for_file: prefer_final_fields, unused_field, prefer_const_constructors, unused_element

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gipher_searcher/ui/gif_page.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search = '';
  int _offset = 0;
  Future<Map> _getGifs() async {
    http.Response response;
    if (_search == '') {
      response = await http.get(Uri.parse(
          "https://api.giphy.com/v1/gifs/trending?api_key=N4DqQk1me44tlyZXvLpOczmxSwrKBc07&limit=19&rating=r"));
    } else {
      response = await http.get(Uri.parse(
          "https://api.giphy.com/v1/gifs/search?api_key=N4DqQk1me44tlyZXvLpOczmxSwrKBc07&q=${this._search}&limit=19&offset=${this._offset}&rating=g&lang=en"));
    }
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Image.network(
            "https://c.tenor.com/KBe_nw4IL2QAAAAC/matrix-code.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          // ignore: prefer_const_constructors
          Padding(
            padding: EdgeInsets.all(18.0),
            // ignore: prefer_const_constructors
            child: TextField(
              // ignore: prefer_const_constructors
              decoration: InputDecoration(
                  labelText: "Buscar gif",
                  // ignore: prefer_const_constructors
                  labelStyle: TextStyle(color: Colors.grey),
                  // ignore: prefer_const_constructors
                  border: OutlineInputBorder()),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                });
              },
            ),
          ),
          Expanded(
              child: FutureBuilder(
            future: _getGifs(),
            builder: (context, snapshot) {
              // ignore: non_constant_identifier_names
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Container(
                    width: 200.0,
                    height: 200.0,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      strokeWidth: 5.0,
                    ),
                  );
                default:
                  if (snapshot.hasError)
                    return Container();
                  else {
                    return __createGifTable(context, snapshot);
                  }
              }
            },
          ))
        ],
      ),
    );
  }

  int _getCount(List data) {
    if (_search == '') {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget __createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
      itemCount: _getCount(snapshot.data['data']),
      itemBuilder: (context, index) {
        if (this._search == '' || index < snapshot.data["data"].length) {
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: snapshot.data['data'][index]['images']['fixed_height']
                  ['url'],
              height: 300.0,
              fit: BoxFit.cover,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          GifPage(snapshot.data["data"][index])));
            },
            onLongPress: () {
              Share.share(snapshot.data["data"][index]["images"]["fixed_height"]
                  ["url"]);
            },
          );
        } else {
          return Container(
              child: GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 70.0,
                ),
                Text("Carregar mais...",
                    style: TextStyle(color: Colors.white, fontSize: 22.0)),
              ],
            ),
            onTap: () {
              setState(() {
                _offset += 19;
              });
            },
            onVerticalDragUpdate: (details) {
              int sensitivity = 8;
              if (details.delta.dy < -sensitivity) {
                setState(() {
                  _offset += 19;
                });
              }
            },
          ));
        }
      },
    );
  }
}
