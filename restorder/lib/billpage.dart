import 'package:flutter/material.dart';
import 'package:restorder/details.dart';
import 'package:restorder/main.dart';

class showBill extends StatelessWidget {
  const showBill({Key? key}) : super(key: key);
  double total(List<Detail> show) {
    double sum = 0;
    for (int i = 0; i < show.length; i++) {
      sum += double.parse(show[i].iprice) * double.parse(show[i].ivalue);
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bill"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                      columnSpacing: 50,
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text(
                            'Food Item',
                            style: TextStyle(fontStyle: FontStyle.normal),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Qty',
                            style: TextStyle(fontStyle: FontStyle.normal),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'cost',
                            style: TextStyle(fontStyle: FontStyle.normal),
                          ),
                        ),
                      ],
                      rows: show
                          .map((e) => DataRow(cells: [
                                DataCell(Text(e.iname)),
                                DataCell(Text(e.ivalue)),
                                DataCell(Text(
                                    "${double.parse(e.iprice) * double.parse(e.ivalue)}")),
                              ]))
                          .toList()),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(34, 0, 34, 0),
              child: Divider(
                color: Colors.black,
              ),
            ),
            SizedBox.fromSize(
              size: Size.fromHeight(20),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 150, bottom: 50),
              child: Text(
                " Total \t = \t\t\t${total(show)}",
                style: TextStyle(color: Colors.black87),
              ),
            )
          ],
        ),
      ),
    );
  }
}
