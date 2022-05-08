import 'package:flutter/material.dart';
import 'package:flutter_hive/models/developer.dart';
import 'package:flutter_hive/screens/forms/update_developer.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'graduated.dart';
import 'forms/create_developer.dart';
import 'not_graduated.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> Menu = ["Developers graduated", "Developers not graduated"];

  _menuOptions(String options) {
    switch (options) {
      case "Developers graduated":
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Graduated()));
        break;

      case "Developers not graduated":
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => NotGraduated()));
        break;
    }
  }

  var boxform = Hive.box<Developer>('developers').listenable();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    Hive.box('developers');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => DeveloperCreate()),
          );
        },
      ),
      appBar: AppBar(
        title: Text("Hive Form"),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _menuOptions,
            itemBuilder: (context) {
              return Menu.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Container(
        child: ValueListenableBuilder(
          valueListenable: boxform,
          builder: (context, Box<Developer> box, _) {
            if (box.values.isEmpty) {
              return Center(
                child: Text("No data available!",
                    style: TextStyle(fontFamily: 'Montserrat')),
              );
            }
            return ListView.builder(
                itemCount: box.length,
                itemBuilder: (context, index) {
                  Developer form = box.getAt(index);

                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DeveloperUpdate(
                                    id: index,
                                    nomeChange: form.nome,
                                  )));
                    },
                    onLongPress: () async {
                      await box.deleteAt(index);
                    },
                    trailing: Icon(
                      form.isGraduated
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: Colors.blue,
                    ),
                    title: Text(
                      form.nome??"default",
                      style: TextStyle(fontSize: 20, fontFamily: 'Montserrat'),
                    ),
                    subtitle: form.choices == null
                        ? Text("Unknow")
                        : Text(form.choices),
                  );
                });
          },
        ),
      ),
    );
  }
}
