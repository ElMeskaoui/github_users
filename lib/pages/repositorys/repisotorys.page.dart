import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class RepisotorysPage extends StatefulWidget{
  String login="";
  String avatarUrl="";
  RepisotorysPage({required this.login, required this.avatarUrl});

  @override
  State<RepisotorysPage> createState() => _RepisotorysPageState();
}

class _RepisotorysPageState extends State<RepisotorysPage> {
  dynamic userRepo=null;

  @override
  void initState(){
    loadRepository();

  }
  void loadRepository() async{
    String url="https://api.github.com/users/${widget.login}/repos";
    http.Response reponce = await http.get(Uri.parse(url));
    if(reponce.statusCode==200){
      setState((){
          userRepo=jsonDecode(reponce.body);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Repisotorys ${widget.login}'),
        actions: [
          CircleAvatar(backgroundImage: NetworkImage(widget.avatarUrl),)
        ],
      ),
      body: Center(
        child: ListView.separated(
            itemBuilder: (context, index)=>ListTile(
              title: Text("${userRepo[index]['name']}"),
            ),
            separatorBuilder: (context, index)=> Divider(height: 3, color: Colors.deepOrange),
            itemCount: userRepo==null?0:userRepo.length),
      ),
    );
  }
}