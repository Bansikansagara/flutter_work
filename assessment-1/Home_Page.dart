import 'package:ass1/view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'db.dart';

class Home_Page extends StatefulWidget
{
  @override
  Home_PageState createState() => Home_PageState();
}

class Home_PageState extends State<Home_Page>
{
  final FlutterTts flutterTts = FlutterTts();
  TextEditingController word = TextEditingController();
  TextEditingController meaning = TextEditingController();

  MyDb mydb = MyDb();

  @override
  void initState() {
    mydb.open();
    super.initState();
  }
  Widget build(BuildContext context)
  {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Add Words"),
      backgroundColor: Colors.lightBlue.shade400,),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Add a Word"),
            Row(
              children: [
                IconButton(onPressed: ()
                {
                  speak(word.text);
                }, icon: Icon(Icons.volume_up)),
                SizedBox(
                  height: 100,
                  width: 200,
                  child: TextField(
                    controller: word,
                    decoration: InputDecoration(labelText: 'Word'),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    word.clear();
                  },
                  icon: Icon(Icons.highlight_remove, color: Colors.grey),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(onPressed: ()
                {
                  speak1(meaning.text);
                }, icon: Icon(Icons.volume_up)),
                SizedBox(
                  height: 100,
                  width: 200,
                  child: TextField(
                    controller: meaning,
                    decoration: InputDecoration(labelText: 'Meaning'),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    meaning.clear();
                  },
                  icon: Icon(Icons.highlight_remove, color: Colors.grey),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  height: 40,
                  width: 140,
                  child: ElevatedButton(onPressed: (){
                    mydb.db.rawInsert("INSERT INTO STUDENTS (word, meaning) VALUES (?, ?);",
                        [word.text, meaning.text]);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Word Added Successfully")));
                    word.text = "";
                    meaning.text = "";
                    }, child: Text("Add Word"),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlue.shade200,
                        onPrimary: Colors.black87,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                SizedBox(width: 15,),
                SizedBox(
              height: 40,
              width: 140,
              child: ElevatedButton(onPressed: ()
              {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ViewStudent()));
              }, child: Text("View Dictionary"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.lightBlue.shade200,
                  onPrimary: Colors.black87,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
              ],
            ),

            SizedBox(height: 20, width: 10),
            Column(
              children: [
                SizedBox(
                  height: 40,
                  width: 160,
                  child: ElevatedButton.icon(onPressed: ()
                  {
                    websitelaunch();
                  },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightBlue.shade200,
                      onPrimary: Colors.black87,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ), icon: Icon(Icons.g_mobiledata_rounded), label: Text("Google"),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Image.asset('assets/book.jpg', height: 200, width: 200,),
          ],

        ),
      ),
    );
  }

  void speak(String word) async
  {
    await flutterTts.speak(word);
  }

  void speak1(String meaning) async
  {
    await flutterTts.speak(meaning);
  }

  void websitelaunch() async
  {
    var url = Uri.parse("https://www.google.com/");
    if (await canLaunchUrl(url))
    {
      await launchUrl(url);
    }
    else
    {
      throw 'Could not launch $url';
    }
  }

}

class Word {
  String word;
  String meaning;

  Word({required this.word, required this.meaning});
}
