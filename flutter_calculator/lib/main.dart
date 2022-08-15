import 'dart:async';

import 'package:flutter/material.dart';

extension StringExtension on String {
  bool get isNumber => isNotEmpty && contains(RegExp(r'[0-9]'));
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final List<List<String>> layoutNumbers = [
      [
        'AC', 'Del', '÷',
      ],
      [
        '7', '8', '9', '×',
      ],
      [
        '4', '5', '6', '-',
      ],
      [
        '1', '2', '3', '+',
      ],
      [
        '0', '.', '=',
      ]
    ];

    final Map layoutColorNumbers = {
      'AC': Colors.grey,
      'Del': Colors.grey,
      '÷': Colors.orange,
      '×': Colors.orange,
      '-': Colors.orange,
      '+': Colors.orange,
      '=': Colors.orange,
    };

    final StreamController<String> displayController = StreamController();
    final StreamController<String> resultController = StreamController();
    final List<String> tempDisplays = [];

    final List<int?> mainNumbers = [null];
    final List<String?> mainOpers = [null];

    String tempNewDisplayNumber = '';
    String tempNewDisplayOper = '';

    int currIndex = 0;

    final Map <String, Function> operators = {
      'Del': () {
        if (tempDisplays.isNotEmpty) {
          tempDisplays.removeLast();
          displayController.sink.add(tempDisplays.join());
        }
      },
      'AC': () {
        if (tempDisplays.isNotEmpty) {
          tempDisplays.clear();
          
          mainNumbers.clear();
          mainNumbers.add(null);

          mainOpers.clear();
          mainOpers.add(null);

          currIndex = 0;
          
          displayController.sink.add(tempDisplays.join());
        }
      },
      '=': () {
        if (mainNumbers.isNotEmpty) {
          double result = 0;
          
          var tempMainNumbers = mainNumbers;
          var tempMainOpers = mainOpers;
          
          do {
            final num1 = tempMainNumbers.removeAt(0);
            final oper = tempMainOpers.removeAt(0);
            
            switch (oper) {
            case '+':
              if (tempMainNumbers.isNotEmpty) {
                final num2 = tempMainNumbers.removeAt(0);
                result += ((num1 ?? 0) + (num2 ?? 0)).toDouble();
              } else {
                result += (num1 ?? 0).toDouble();
              }
              break;
            case '-':
              if (tempMainNumbers.isNotEmpty) {
                final num2 = tempMainNumbers.removeAt(0);
                if (result <= 0) {
                    result += ((num1 ?? 0) - (num2 ?? 0)).toDouble();
                } else {
                    result -= ((num1 ?? 0) - (num2 ?? 0)).toDouble();
                }
              } else {
                result -= (num1 ?? 0).toDouble();
              }
              break;
            case '×':
              if (result == 0) result = 1;
              if (tempMainNumbers.isNotEmpty) {
                final num2 = tempMainNumbers.removeAt(0);
                result *= ((num1 ?? 1) * (num2 ?? 1)).toDouble();
              } else {
                result *= (num1 ?? 1).toDouble();
              }
              break;
            case '÷':
                if (result == 0) result = 1;
                if (tempMainNumbers.isNotEmpty) {
                  final num2 = tempMainNumbers.removeAt(0);
                  if (mainNumbers.first == num1) {
                      result = ((num1 ?? 1) / (num2 ?? 1)).toDouble();
                  } else {
                      result /= ((num1 ?? 1) / (num2 ?? 1)).toDouble();
                  }
                } else {
                  result /= (num1 ?? 1).toDouble();
                }
              break;
            default:
              result = (num1 ?? 0).toDouble();
            } 
          } while (tempMainNumbers.isNotEmpty);
          
          resultController.sink.add(result.toString());
        }
      },
    };

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  StreamBuilder<String>(
                    stream: displayController.stream,
                    builder: (context, snapshot) {
                      final str = snapshot.data ?? '0';
                      return Text(
                        str == '' ? '0' : str,
                        style: const TextStyle(
                          fontSize: 32,
                        ),
                        textAlign: TextAlign.right,
                      );
                    }
                  ),
                  const SizedBox(height: 16,),
                  StreamBuilder<String>(
                    stream: resultController.stream,
                    builder: (context, snapshot) {
                      final str = snapshot.data ?? '';
                      return Text(
                        str,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.grey.shade800
                        ),
                        textAlign: TextAlign.right,
                      );
                    }
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  for (final row in layoutNumbers) Expanded(
                    child: Row(
                      children: [
                        for (final number in row) Expanded(
                          flex: ['AC', '0'].contains(number) ? 2 : 1,
                          child: Material(
                            color: layoutColorNumbers.containsKey(number) ? layoutColorNumbers[number] : Colors.grey.shade400,
                            shape: BeveledRectangleBorder(
                              side: BorderSide(color: Colors.grey.shade600, width: 0.4),
                            ),
                            child: InkWell(
                              onTap: () {
                                if (['AC', 'Del', '='].contains(number)) {
                                  operators[number]?.call();
                                } else {                                  
                                  if (['+', '-', '×', '÷'].contains(number)) {
                                    
                                    tempNewDisplayNumber = '';
                                    tempNewDisplayOper = number;

                                    if (tempDisplays.isNotEmpty) {
                                      if (tempDisplays.last.isNumber) {
                                        tempDisplays.add(number);
                                      } else {
                                        tempDisplays.removeLast();
                                        tempDisplays.add(number);
                                      }
                                    }

                                    if (mainNumbers[currIndex] != null) {
                                        mainOpers[currIndex] = tempNewDisplayOper;
                                        currIndex += 1;
                                        mainNumbers.add(null);
                                        mainOpers.add(null);
                                    } else {
                                      final prevIndex = currIndex - 1;
                                      if (prevIndex >= 0) {
                                        if (mainOpers[prevIndex] != null) {
                                          mainOpers[prevIndex] = tempNewDisplayOper;
                                        } else {
                                          mainOpers[currIndex] = tempNewDisplayOper;
                                        }
                                      } else {
                                        mainOpers[currIndex] = tempNewDisplayOper;
                                      }
                                    }
                                    print(currIndex);
                                    print(mainOpers);
                                    print(mainNumbers);
                                    
                                  } else {
                                    tempNewDisplayOper = '';
                                    tempNewDisplayNumber += number;
                                    tempDisplays.add(number);

                                    mainNumbers[currIndex] = int.parse(tempNewDisplayNumber);
                                    
                                    print(currIndex);
                                    print(mainOpers);
                                    print(mainNumbers);
                                  }

                                  displayController.sink.add(tempDisplays.join());
                                }
                              },
                              child: Center(
                                child: Text(
                                  number,
                                  style: const TextStyle(fontSize: 32),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )      
    );
  }
}
