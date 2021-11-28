import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

Brightness brightness = Brightness.light;
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        brightness: brightness,
        primarySwatch: Colors.blue,
      ),
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  List<String> buttons = [
    'C',
    '/',
    '*',
    '⌫',
    '7',
    '8',
    '9',
    '^',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '√',
    '0',
    '.',
    '='
  ];
  String expression = '';
  String hist = '';
  String ans = '';
  numClick(i) {
    setState(() {
      expression += buttons[i];
    });
  }

  clear() {
    setState(() {
      expression.length != 0
          ? expression = expression.substring(0, expression.length - 1)
          : expression = '';
    });
  }

  clearExp() {
    setState(() {
      expression = '';
    });
  }

  clearAll() {
    setState(() {
      expression = '';
      hist = '';
    });
  }

  bool lp = false;
  taps(i) {
    if (buttons[i].isNotEmpty) print(buttons[i]);
    if (buttons[i].contains('C')) {
      clearAll();
    } else if (buttons[i].contains('⌫')) {
      lp ? clearExp() : clear();
    } else if (buttons[i] == '=') {
      if (expression.isEmpty) {
        setState(() {
          expression = '0';
        });
      } else {
        eval();
      }
    } else {
      numClick(i);
    }
  }

  eval() {
    if (expression.length != 0) {
      Parser p = Parser();
      Expression exp = p.parse(expression.contains('√')
          ? expression.replaceAll('√', 'sqrt')
          : expression);
      ContextModel cm = ContextModel();
      double res = exp.evaluate(EvaluationType.REAL, cm);

      setState(() {
        hist = expression;
        expression = res.toString();
        ans = res.toString();
      });
    } else {}
    print(expression);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: size.width,
              height: size.height / 15,
              child: Card(
                elevation: 0,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            hist,
                            style: TextStyle(fontSize: 15),
                          )),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: size.width,
              height: size.height / 5,
              child: Card(
                elevation: 0,
                child: Stack(
                  children: [
                    Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          expression,
                          style: TextStyle(fontSize: 25),
                        )),
                  ],
                ),
              ),
            ),
            Container(
              width: size.width,
              child: Wrap(
                alignment: WrapAlignment.center,
                children: buttons.map<Widget>((e) {
                  int index = buttons.indexOf(e);
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      height: size.width / 5,
                      width: size.width / 5,
                      child: Material(
                        borderRadius: BorderRadius.circular(e == '=' ? 20 : 90),
                        color: e == '='
                            ? Colors.blue
                            : e == 'C'
                                ? Colors.redAccent
                                : Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(90),
                          onTap: () {
                            taps(index);
                          },
                          onLongPress: () {
                            setState(() {
                              lp = true;
                            });
                            taps(index);
                            setState(() {
                              lp = false;
                            });
                          },
                          splashColor: Colors.grey,
                          child: Center(
                            child: Text(
                              e == '.' ? '▪' : e,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 19),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
