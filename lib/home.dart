import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class JsonSimple extends StatefulWidget {
  const JsonSimple({super.key});

  @override
  State<JsonSimple> createState() => _MyJson();
}

class _MyJson extends State<JsonSimple> {
  late Future data;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("BLOG EXAMPLE")),
        ),
        body: Center(
          child: Container(
            child: FutureBuilder(
              future: getData(),
              builder: ((context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  // return Text(snapshot.data[0]['title']);
                  return CreateListView(snapshot.data, context);
                } else {
                  return CircularProgressIndicator();
                }
              }),
            ),
          ),
        ));
  }

  Widget CreateListView(List data, context) {
    return Container(
      child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, int index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Divider(
                  height: 5,
                ),
                ListTile(
                  title: Text("${data[index]['title']}"),
                  subtitle: Text("${data[index]['body']}"),
                  leading: Column(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: const Color.fromARGB(66, 177, 29, 29),
                        radius: 23,
                        child: Text("${data[index]['id']}"),
                      )
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }
}

class Network {
  final String url;

  Network(this.url);

  Future fetchData() async {
    print("$url");

    Response response = await get(Uri.parse(url));

    if (response.statusCode == 200) {
      // print(response.body);
      return json.decode(response.body);
    } else {
      print(response.statusCode);
    }
  }
}

Future getData() async {
  return Network("https://jsonplaceholder.typicode.com/posts").fetchData();
}
