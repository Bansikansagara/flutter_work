import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'db.dart';

class EditStudents extends StatefulWidget
{
  late String word;
  EditStudents({required this.word});

  @override
  EditState createState() => EditState();
}

class EditState extends State<EditStudents>
{
  TextEditingController word = TextEditingController();
  TextEditingController meaning = TextEditingController();

  MyDb mydb = new MyDb();

  @override
  void initState() {
    // TODO: implement initState
    mydb.open();

    Future.delayed(Duration(milliseconds: 500),()async
    {
      var data = await mydb.getStudent(widget.word);
      if(data != null)
      {
        word.text = data["word"];
        meaning.text = data["meaning"].toString();
        setState(() {});
      }
      else
      {
        print("No any data with word: " + widget.word.toString());
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Word"),
          backgroundColor: Colors.lightBlue.shade400,
        ),
        body:Container(
          padding: EdgeInsets.all(30),
          child: Column(children: [
            TextField(
              controller: word,
              decoration: InputDecoration(
                hintText: "Word",
              ),
            ),
            TextField(
              controller: meaning,
              decoration: InputDecoration(
                hintText: "Meaning",
              ),
            ),
            ElevatedButton(onPressed: (){

              mydb.db.rawUpdate("Update students set word =? ,meaning=? where word=?",
                  [word.text, meaning.text,widget.word]);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data Updated")));
              }, child: Text("Save Data")),
          ],),
        )
    );
  }
}