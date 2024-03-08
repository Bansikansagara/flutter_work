import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Home_Page.dart';
import 'db.dart';
import 'edit.dart';

class ViewStudent extends StatefulWidget
{
  @override
  ViewState createState() => ViewState();
}

class ViewState extends State<ViewStudent>
{
  TextEditingController searchController = TextEditingController();
  List<Map> slist = [];
  MyDb mydb = new MyDb();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mydb.open();
    getdata();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(title: Text("View Dictionary"),
      backgroundColor:Colors.lightBlue.shade400,),
      body: SingleChildScrollView(
        child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  controller: searchController,
                  onChanged:  filterTasks,
                  decoration: InputDecoration(
                    labelText: "Search by Task Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    prefixIcon: Icon
                      (Icons.search),
                  ),
                ),
              ),
              Container(
                child: slist.length == 0 ? Text("No any students to show."):
                  Column(
                      children: slist.map((stuone)
                      {
                        return Card
                          (
                          child: ListTile(

                            leading: Icon(Icons.library_books_rounded),
                            title: Text(stuone["word"]),
                            subtitle: Text("meaning:" + stuone["meaning"].toString()),
                            trailing: Wrap(
                              children: [
                                IconButton(onPressed: ()
                                {
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)
                                  {
                                    return EditStudents(word: stuone["word"]);
                                  }
                                  ));
                                }, icon: Icon(Icons.edit, color: Colors.blue)),
                                IconButton(onPressed: (){
                                  mydb.db.rawDelete("DELETE FROM students where word = ? ", [stuone["word"]]);
                                  print("Data Deleted");
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Student Data Deleted")));
                                  getdata();
                                  }, icon: Icon(Icons.delete, color: Colors.red)),
                              ],
                            ),
                          ),
                        );
                      }).toList()
                  ),
              ),
            ],
          ),
      ),

      floatingActionButton: FloatingActionButton(
          onPressed: ()
          {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Home_Page()));
          },
          child: Icon(Icons.add),
        backgroundColor: Colors.lightBlue.shade300,
          ),
    );
  }
  void getdata()
  {
    Future.delayed(Duration(milliseconds: 500),()async
    {
      slist = await mydb.db.rawQuery('SELECT * FROM students');
      setState(()
      {
      });
    });
  }
  void filterTasks(String query)
  {
    if (query.isEmpty) {
      getdata(); // If the search query is empty, show all tasks
    } else {
      List<Map> filteredList = slist!
          .where((task) =>
      task["word"]!.toLowerCase().contains(query.toLowerCase()) ||
          task["meaning"]!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      setState(() {
        slist = filteredList;
      });
    }
  }
}
