import 'package:flutter/material.dart';
import 'package:flutter_hive/css/colors.dart';
import 'package:flutter_hive/models/developer.dart';
import 'package:flutter_hive/widgets/appbar_widget.dart';
import 'package:flutter_hive/widgets/developer_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'forms/form.dart';

class NotGraduated extends StatefulWidget {
  @override
  _NotGraduatedState createState() => _NotGraduatedState();
}

class _NotGraduatedState extends State<NotGraduated> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: CustomColors.textColor,
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => FormDeveloper()),
          );
        },
      ),
      appBar: MyAppBar(
        title: "Hive not Graduated",
        actionsAppBar: Container(),
      ),
      body: Center(
        child: Container(
          width: size.width * 0.95,
          child: ValueListenableBuilder(
            valueListenable: Hive.box<Developer>('developers').listenable(),
            builder: (context, Box<Developer> box, _) {
              List<int> keys;

              keys = box.keys
                  .cast<int>()
                  .where((key) => box.get(key).isGraduated == false)
                  .toList();

              if (box.values.isEmpty) {
                return Center(
                  child: Text("No data available!",
                      style: TextStyle(fontFamily: 'Montserrat')),
                );
              }
              return ListView.builder(
                  itemCount: keys.length,
                  itemBuilder: (context, index) {
                    final int key = keys[index];
                    final Developer dev = box.get(key);

                    return DeveloperWidget(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FormDeveloper(
                                      id: index,
                                      nomeChange: dev.nome,
                                    )));
                      },
                      onLongPress: () async {
                        await box.deleteAt(index);
                      },
                      icon: Icon(dev.isGraduated ? Icons.school : Icons.person,
                          color: CustomColors.textColor),
                      text: dev.nome ?? "default",
                      subtitle: dev.choices == null
                          ? Text("Unknow",
                              style: TextStyle(color: CustomColors.textColor))
                          : Text(dev.choices,
                              style: TextStyle(color: CustomColors.textColor)),
                    );
                  });
            },
          ),
        ),
      ),
    );
  }
}
