import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import '../../models/notifyModel.dart';
import '../Setting/notify.dart';

class CalculatorNav extends StatefulWidget {
  const CalculatorNav({super.key});

  @override
  State<CalculatorNav> createState() => _CalculatorNavState();
}

class _CalculatorNavState extends State<CalculatorNav> {
  final TextEditingController _textEditingController = TextEditingController();
  String? _fromCurrency = 'USD';
  String? _toCurrency = 'THB';
  double _exchangeRate = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Currency Converter'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {},
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => notify(
                  notification: NotificationModel(amount: '', fromCurrency: ''),
                ),
              ),
            );
          },
          child: Icon(Icons.notifications),
          backgroundColor: Colors.blue,
          elevation: 4,
          shape: CircleBorder(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        body: ListView(children: [
          Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(mainAxisSize: MainAxisSize.max, children: [
                SizedBox(
                    width: 350,
                    height: 335,
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 5,
                        child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      DropdownButton<String>(
                                        value: _fromCurrency,
                                        onChanged: (String? value) {
                                          setState(() {
                                            _fromCurrency = value;
                                            print(
                                                'fromCurrency: $_fromCurrency');
                                          });
                                        },
                                        items: [
                                          DropdownMenuItem(
                                            child: Text('AED'),
                                            value: 'AED',
                                          ),
                                          DropdownMenuItem(
                                            child: Text('AUD'),
                                            value: 'AUD',
                                          ),
                                          DropdownMenuItem(
                                            child: Text('BHD'),
                                            value: 'BHD',
                                          ),
                                          DropdownMenuItem(
                                            child: Text('BND'),
                                            value: 'BND',
                                          ),
                                          DropdownMenuItem(
                                            child: Text('USD'),
                                            value: 'USD',
                                          ),
                                          DropdownMenuItem(
                                            child: Text('JPY'),
                                            value: 'JPY',
                                          ),
                                          DropdownMenuItem(
                                            child: Text('SGD'),
                                            value: 'SGD',
                                          ),
                                          // Add more currencies here
                                        ],
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.arrow_forward_ios),
                                        onPressed: () {
                                          // setState(() {
                                          //   var temp = _fromCurrency;
                                          //   _fromCurrency = _toCurrency;
                                          //   _toCurrency = temp;
                                          // });
                                        },
                                      ),
                                      DropdownButton<String>(
                                        value: _toCurrency,
                                        onChanged: (String? value) {
                                          setState(() {
                                            _toCurrency = value;
                                            print('toCurrency: $_toCurrency');
                                          });
                                        },
                                        items: [
                                          DropdownMenuItem(
                                            child: Text('THB'),
                                            value: 'THB',
                                          ),
                                          // Add more currencies here
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  TextFormField(
                                    controller: _textEditingController,
                                    validator: RequiredValidator(
                                        errorText: "กรุณาใส่ค่าตัวเลข"),
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        border: UnderlineInputBorder(),
                                        hintText: '0.00',
                                        hintStyle: TextStyle(fontSize: 30)),
                                  ),
                                  SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () async {
                                      var message = "";
                                      message = "กรุณาใส่ค่าตัวเลข";
                                      if (_textEditingController.text.isEmpty) {
                                        setState(() {
                                          _exchangeRate = 0.0;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(message)));
                                        print('Error: Please enter amount');
                                        return;
                                      } else {
                                        var apiKey = 'e50a59e299ef0bae5bc03139';
                                        var url =
                                            'https://v6.exchangerate-api.com/v6/$apiKey/latest/$_fromCurrency';
                                        var response =
                                            await http.get(Uri.parse(url));
                                        if (response.statusCode == 200) {
                                          var jsonResponse =
                                              jsonDecode(response.body);
                                          var conversionRates =
                                              jsonResponse['conversion_rates'];
                                          if (conversionRates != null &&
                                              conversionRates
                                                  .containsKey(_toCurrency)) {
                                            setState(() {
                                              _exchangeRate =
                                                  conversionRates[_toCurrency];
                                              print(
                                                  'Input amount: $_exchangeRate');
                                            });
                                          } else {
                                            print(
                                                'Error: Invalid response from API');
                                          }
                                        } else {
                                          print(
                                              'Error: Failed to get response from API');
                                        }
                                      }
                                    },
                                    child: Text(
                                      'คำนวณอัตราแลกเปลี่ยนสกุลเงิน',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 16),
                                      primary: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'Exchange rate: $_exchangeRate',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'Result: ${(_exchangeRate ?? 0.0) * (double.tryParse(_textEditingController?.text?.toString() ?? '0.0') ?? 0.0)}',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ])))),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: SizedBox(
                      //Box1
                      height: 50,
                      width: MediaQuery.of(context).size.width * 1.0,
                      child: Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                            side: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1, // Add a border
                            ),
                          ),
                          elevation: 8, // Add a shadow
                          child: InkWell(
                            onTap: () {
                              // Do something when the ListTile is tapped
                            },
                          ))),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: SizedBox(
                      //Box1
                      height: 50,
                      width: MediaQuery.of(context).size.width * 1.0,
                      child: Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                            side: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1, // Add a border
                            ),
                          ),
                          elevation: 8, // Add a shadow
                          child: InkWell(
                            onTap: () {
                              // Do something when the ListTile is tapped
                            },
                          ))),
                ),
              ])),
        ]));
  }
}
