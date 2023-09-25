import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String balance;
  final String income;
  final String expense;

  Header({required this.balance, required this.income, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 10.0),
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade500,
              offset: Offset(4.0, 4.0),
              blurRadius: 15.0,
              spreadRadius: 0.8,
            ),
          ],
        ),
        child: FittedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 0, 5.0, 0),
                        child: Text(
                          'Income',
                          style: TextStyle(
                              fontFamily: 'SansationRegular', fontSize: 10),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 0, 5.0, 0),
                        child: Text(
                          income,
                          style: TextStyle(
                              fontFamily: 'SansationRegular', fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 0),
                        child: Text(
                          '|',
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                        child: Text(
                          'Balance',
                          style: TextStyle(
                              fontFamily: 'SansationRegular', fontSize: 10),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                        child: Text(
                          balance,
                          style: TextStyle(
                              fontFamily: 'SansationRegular', fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 0),
                        child: Text(
                          '|',
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5.0, 0, 20.0, 0),
                        child: Text(
                          'Expenses',
                          style: TextStyle(
                              fontFamily: 'SansationRegular', fontSize: 10),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5.0, 0, 20.0, 0),
                        child: Text(
                          expense,
                          style: TextStyle(
                              fontFamily: 'SansationRegular', fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
