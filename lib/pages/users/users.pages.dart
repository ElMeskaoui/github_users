import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:github_users/pages/repositorys/repisotorys.page.dart';
import 'package:http/http.dart' as http;

class UsersPage extends StatefulWidget{
  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  String query="";
  bool notVisible=false;
  TextEditingController queryTextEditingController=new TextEditingController();
  ScrollController scrollController=new ScrollController();
  dynamic data=null;
  int currentPage=0;
  int totalPage=0;
  int pageSize=20;
  List<dynamic> items=[];

  void _serche(String query){
    String url="https://api.github.com/search/users?q=${query}&per_page=$pageSize&page=$currentPage";
    print(url);
      http.get(Uri.parse(url))
          .then((reponce) {
            setState((){
              this.data=jsonDecode(reponce.body);
              this.items.addAll(data['items']);
              this.totalPage = data['total_count']~/this.pageSize;
            });
    }).catchError((erro){
      print(erro);
      });
  }

  @override
  void initState(){
    scrollController.addListener(() {
      if(scrollController.position.pixels==scrollController.position.maxScrollExtent){
        setState((){
          if(currentPage<totalPage-1){
            ++currentPage;
            _serche(query);

          }
        });}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Users=>${this.query} ,  $currentPage / $totalPage")),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: TextFormField(
                      obscureText: notVisible,
                      onChanged: (value){
                        setState((){
                          this.query=value;
                        });
                        },
                        controller: queryTextEditingController,
                        decoration: InputDecoration(
                        suffixIcon: IconButton(onPressed: (){
                          setState((){
                            this.notVisible=!this.notVisible;
                          });
                        }, icon: Icon(
                          this.notVisible==true? Icons.visibility : Icons.visibility_off
                        )),
                        border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(
                        width: 4, color: Colors.deepOrange
                        )
                        )
                        ),
                        ),
                        ),
                        ),
                        IconButton(onPressed: (){
                        setState((){
                        this.query=queryTextEditingController.text;
                        _serche(query);
                        });
                       }, color: Colors.deepOrange, icon: Icon(Icons.search)),
                IconButton(onPressed: (){
                  setState((){
                    this.queryTextEditingController.clear();
                    this.currentPage=0;
                    this.items=[];
                  });
                }, icon: Icon(Icons.add))
              ],
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(height: 2,color: Colors.deepOrange,),
                controller: scrollController,
                itemCount: items.length,
                  itemBuilder: (context,index){
                  return ListTile(
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder:
                              (context)=>RepisotorysPage(login:items[index]['login'],)));
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(items[index]['avatar_url']),
                            ),
                            SizedBox(width: 15),
                            Text("${items[index]['login']}"),
                          ],
                        ),
                        CircleAvatar(
                          child: Text("${items[index]['type']}", style: TextStyle(fontSize: 9),),
                        )
                      ],
                    ),
                  );
                  }
              ),
            )
          ],
        )
      ),
    );
  }


}