import 'package:excel_sheet_connect/color.dart';
import 'package:excel_sheet_connect/provider/provider.dart';
import 'package:excel_sheet_connect/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:excel_sheet_connect/user_sheet_api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController datecontroler = TextEditingController();
  final TextEditingController modecontroler = TextEditingController();
  final TextEditingController entrycontroler = TextEditingController();
  final TextEditingController costcontroler = TextEditingController();
  late DataProvider dataProvider;
  @override
  void didChangeDependencies() async {
    dataProvider = Provider.of<DataProvider>(context);
    dataProvider.init();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.remove_red_eye,
              size: 30,
              color: Colors.black,
            ),
            onPressed: () async {
              final url1 =
                  'https://docs.google.com/spreadsheets/d/1m_4XchqNLsqgEJhM9TJaqwzLq4njRpW_b0UEOMcjCOo/edit#gid=1514675007';
              final url2 =
                  'https://docs.google.com/spreadsheets/d/1FRDmUYkf0i4r0SPW0UNI3UYNNi1VJmwBCIYeu8lB9Wk/edit#gid=0';
              launchUrl(
                Uri.parse(url1),
              );
            },
          ),
        ],
        backgroundColor: Colors.greenAccent,
        title: Text(
          "Hisab",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: dataProvider.hasLoaded
          ? Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      width: double.infinity,
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Balance",
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                          Text(
                            '${dataProvider.formatCurrency(double.parse(dataProvider.bal))} ৳',
                            style: TextStyle(fontSize: 22),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.arrow_upward,
                                          color: Colors.green,
                                        )),
                                    Column(
                                      children: [
                                        Text(
                                          "Entry",
                                          style: TextStyle(
                                              fontSize: 15, color: Colors.grey),
                                        ),
                                        Text(
                                            '${dataProvider.formatCurrency(double.parse(dataProvider.entry))} ৳'),
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.arrow_downward,
                                          color: Colors.red,
                                        )),
                                    Column(
                                      children: [
                                        Text(
                                          "Cost",
                                          style: TextStyle(
                                              fontSize: 15, color: Colors.grey),
                                        ),
                                        Text(
                                            '${dataProvider.formatCurrency(double.parse(dataProvider.cost))} ৳'),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: dataProvider.rowData.length,
                        itemBuilder: (context, index) {
                          final row = dataProvider.rowData[index + 1];
                          return Card(
                            elevation: 10,
                            child: ListTile(
                              leading: CircleAvatar(
                                  backgroundColor: Colors.grey.shade200,
                                  child: Text('${index + 2}')),

                              title: Text(row[1]),

                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    row[2],
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  Text(
                                    row[3],
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                ],
                              ),
                              // title: Text(row.join(', ')),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: SpinKitFadingCircle(
                color: Colors.greenAccent,
              ),
            ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey.shade400,
          onPressed: () {
            _showDialog(context);
          },
          child: Icon(Icons.add)),
    ));
  }

  _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          elevation: 20,
          title: Text("Add new task"),
          content: Container(
            width: double.infinity,
            height: 250,
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    autofocus: false,
                    controller: datecontroler,
                    onTap: () async {
                      DateTime? pickeddate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now().subtract(Duration(days: 300)),
                        lastDate: DateTime.now(),
                      );
                      if (pickeddate != null) {
                        String formate =
                            DateFormat("dd-MMM-yyyy").format(pickeddate);
                        datecontroler.text = formate.toString();
                      } else {
                        print("Not selected");
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      prefixIcon: Icon(Icons.calendar_today),
                      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      labelText: "Enter Date",
                      labelStyle: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w400),
                    ),
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r'^[0-9]').hasMatch(value)) {
                        return 'Please Enter Date';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: modecontroler,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r'^[a-z A-Z]').hasMatch(value)) {
                        return ("Please Enter ");
                      } else {
                        return null;
                      }
                    },
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.text_format),
                      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      label: Text(
                        "Way of Entry or Cost ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: entrycontroler,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty)
                        return ("Please Enter ");
                      else if (!RegExp(r'^[0-9]').hasMatch(value)) {
                        return ("Please Enter Valid Number ");
                      } else {
                        return null;
                      }
                    },
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        FontAwesomeIcons.plus,
                        color: Colors.green,
                      ),
                      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      label: Text(
                        "Entry",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: costcontroler,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty)
                        return ("Please Enter ");
                      else if (!RegExp(r'^[0-9]').hasMatch(value)) {
                        return ("Please Enter Valid Number ");
                      } else {
                        return null;
                      }
                    },
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        FontAwesomeIcons.minus,
                        color: Colors.red,
                      ),
                      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      label: Text(
                        "Cost",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 15, color: mycolor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            SizedBox(
              width: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                shape: StadiumBorder(),
              ),
              child: Text(
                "Save",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              onPressed: () async {
                if (_formkey.currentState!.validate()) {
                  final user = User(
                    date: datecontroler.text,
                    mode: modecontroler.text,
                    entry: entrycontroler.text,
                    cost: costcontroler.text,
                  );

                  await UserSheetsApi.insert([user.toJson()]);

                  // await dataProvider.insertData([user.toJson()]);
                  dataProvider.init();
                  setState(() {});
                  datecontroler.clear();
                  modecontroler.clear();
                  entrycontroler.clear();
                  costcontroler.clear();
                  Navigator.pop(context);
                  final snackbar =
                      SnackBar(content: Text("Thank You❤ Updated Your Data"));
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
