import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "dart:async";
import "package:http/http.dart" as http;
import "dart:convert";
import 'package:flutter_elegant_number_button/flutter_elegant_number_button.dart';
import 'package:restorder/details.dart';
import 'billpage.dart';

List<Detail> show = [];
void main() {
  runApp(
    MaterialApp(
      title: "Restorder",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),
      home: Home(),
    ),
  );
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List list = [];
  bool _isVisible = false;
  String selectedvalue = "";

  Future getdata() async {
    var response = await http
        .get("http://192.168.109.146/dashboard/restaurant/getdata.php");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        list = jsonData;

        // selectedvalue = list[0]["i_name"];
      });
    }
    print(list);
  }

  String iname = "";
  String iprice = "";
  TextEditingController ivalue = new TextEditingController();

  int defaultvalue = 0;
  int index = 0;
  void addItem(Detail detail) {
    for (int i = 0; i < list.length; i++) {
      if (list[i]["i_name"] == detail.iname) {
        detail.iprice = list[i]["price"];
      }
    }
    setState(() {
      show.add(detail);
    });
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("Retaurant")),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(),
          child: Column(
            children: [
              Container(
                child: DropdownButtonFormField(
                    hint: Text("select item"),
                    value: selectedvalue.isNotEmpty ? selectedvalue : null,
                    items: list.map((Category) {
                      iprice = Category["price"];
                      return DropdownMenuItem(
                        value: Category["i_name"],
                        child: Text(Category["i_name"]),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedvalue = value.toString();
                        iname = selectedvalue;
                      });
                    }),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter Quantity",
                ),
                controller: ivalue,
              ),
              MaterialButton(
                child: Text("Add Item"),
                color: Colors.red,
                onPressed: () {
                  Detail detail = new Detail(iname, ivalue.text, iprice);
                  addItem(detail);
                },
              ),
              Container(
                child: ListView.builder(
                    physics: const ScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: show.length,
                    itemBuilder: (ctx, i) {
                      return Card(
                        child: ListTile(
                          title: Text(show[i].iname),
                          subtitle: Text('qty:${show[i].ivalue}\t' +
                              "\tprice:${show[i].iprice}"),
                          trailing: ElegantNumberButton(
                            initialValue: int.parse(show[i].ivalue),
                            minValue: 0,
                            maxValue: 100,
                            step: 1,
                            decimalPlaces: 0,
                            onChanged: (value) {
                              // get the latest value from here
                              setState(() {
                                show[i].ivalue = value.toString();
                              });
                            },
                          ),
                        ),
                      );
                    }),
              ),
              MaterialButton(
                  child: Text("Generate bill"),
                  color: Colors.redAccent,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => showBill()));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
