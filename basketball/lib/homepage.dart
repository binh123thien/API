import 'dart:convert';

import 'package:api/model/player_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});
  List<Player> teams = [];
//get
  Future<List<Player>> getTeams() async {
    var respone = await http.get(Uri.http('balldontlie.io', '/api/v1/players'));
    var jsondata = jsonDecode(respone.body);
    print(jsondata);

    for (var eachPlayer in jsondata['data']) {
      final team = Player(
        eachPlayer['first_name'].toString(),
        eachPlayer['position'].toString(),
      );
      teams.add(team);
    }
    return teams;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.red),
      body: FutureBuilder(
        future: getTeams(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // xử lý dữ liệu khi stream phát ra dữ liệu mới
            return ListView.builder(
              itemCount: teams.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text('${index + 1}',
                        style: TextStyle(color: Colors.white)),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(teams[index].name),
                      // Text(teams[index].city),
                      Text(teams[index].position),
                      const Divider(
                        thickness: 1,
                      )
                    ],
                  ),
                );
              },
            );
          } else {
            // xử lý khi chưa có dữ liệu phát ra
            return const Center(child: Text('Chưa nhận được dữ liệu'));
          }
        },
      ),
    );
  }
}
