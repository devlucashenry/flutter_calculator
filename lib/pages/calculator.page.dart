import 'package:calculator/enums/operation.type.dart';
import 'package:calculator/pages/historic.page.dart';
import 'package:calculator/widgets/button.widget.dart';
import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  late String displayNumber;
  late List<String> historic;

  @override
  void initState() {
    historic = [];
    displayNumber = '0';
    super.initState();
  }

  void setOperationType(OperationTypeEnum newType) {
    setState(() {
      displayNumber += newType.symbol;
    });
  }

  void clear() {
    setState(() {
      displayNumber = '0';
    });
  }

  void appendNumber(String stringNumber) {
    setState(() {
      if (displayNumber == '0') {
        displayNumber = stringNumber;
      } else {
        displayNumber += stringNumber;
      }
    });
  }

  List<double> parseNumbers(String expression) {
    RegExp regExp = RegExp(r'[0-9]+\.?[0-9]*');

    var matches = regExp.allMatches(expression);

    List<double> numbers = [];
    for (var match in matches) {
      String numberText = match.group(0)!;
      numbers.add(double.parse(numberText));
    }
    return numbers;
  }

  List<OperationTypeEnum> getOperators(String expression) {
    final expression1 = expression.characters.where(
      (x) => OperationTypeEnum.values.any((op) => op.symbol == x),
    );

    return expression1
        .map((x) => OperationTypeEnum.values.firstWhere((op) => op.symbol == x))
        .toList();
  }

  void resolvePriorityOperations(
    List<double> numbers,
    List<OperationTypeEnum> operators,
  ) {
    int index = 0;

    while (index < operators.length) {
      if (operators[index] == OperationTypeEnum.multiplication) {
        numbers[index] = numbers[index] * numbers[index + 1];
        numbers.removeAt(index + 1);
        operators.removeAt(index);
      } else if (operators[index] == OperationTypeEnum.division) {
        numbers[index] = numbers[index] / numbers[index + 1];
        numbers.removeAt(index + 1);
        operators.removeAt(index);
      } else {
        index++;
      }
    }
  }

  double resolveAdditionAndSubtraction(
    List<double> numbers,
    List<OperationTypeEnum> operators,
  ) {
    int index = 0;

    while (index < operators.length) {
      if (operators[index] == OperationTypeEnum.addition) {
        numbers[0] = numbers[0] + numbers[index + 1];
        //numbers.removeAt(index + 1);
      } else {
        numbers[0] = numbers[0] - numbers[index + 1];
        //numbers.removeAt(index + 1);
      }
      index++;
    }
    return numbers[0];
  }

  void calculate() {
    String expression = displayNumber.replaceAll(',', '.');
    List<double> numbers = parseNumbers(expression);
    List<OperationTypeEnum> operations = getOperators(expression);

    resolvePriorityOperations(numbers, operations);
    final result = resolveAdditionAndSubtraction(numbers, operations);

    setState(() {
      displayNumber = result.toString().replaceAll(',', '.');
      historic.add("$expression = $result");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HistoricPage(historic: historic),
                ),
              );
            },
            icon: Icon(Icons.history),
          ),
        ],
      ),

      body: Column(
        children: [
          Container(
            height: 300,
            width: double.maxFinite,
            color: Colors.black87,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                displayNumber,
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.yellow,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ButtonWidget(
                    text: "C",
                    color: Colors.red,
                    onPressed: () {
                      clear();
                    },
                  ),
                  ButtonWidget(
                    text: "\u232b",
                    color: Colors.orange,
                    onPressed: () {},
                  ),
                  ButtonWidget(
                    text: "÷",
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      setOperationType(OperationTypeEnum.division);
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  ButtonWidget(
                    text: "7",
                    onPressed: () {
                      appendNumber("7");
                    },
                  ),
                  ButtonWidget(
                    text: "8",
                    onPressed: () {
                      appendNumber("8");
                    },
                  ),
                  ButtonWidget(
                    text: "9",
                    onPressed: () {
                      appendNumber("9");
                    },
                  ),
                  ButtonWidget(
                    text: "x",
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      setOperationType(OperationTypeEnum.multiplication);
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  ButtonWidget(
                    text: "4",
                    onPressed: () {
                      appendNumber("4");
                    },
                  ),
                  ButtonWidget(
                    text: "5",
                    onPressed: () {
                      appendNumber("5");
                    },
                  ),
                  ButtonWidget(
                    text: "6",
                    onPressed: () {
                      appendNumber("6");
                    },
                  ),
                  ButtonWidget(
                    text: "-",
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      setOperationType(OperationTypeEnum.subtraction);
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  ButtonWidget(
                    text: "1",
                    onPressed: () {
                      appendNumber("1");
                    },
                  ),
                  ButtonWidget(
                    text: "2",
                    onPressed: () {
                      appendNumber("2");
                    },
                  ),
                  ButtonWidget(
                    text: "3",
                    onPressed: () {
                      appendNumber("3");
                    },
                  ),
                  ButtonWidget(
                    text: "+",
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      setOperationType(OperationTypeEnum.addition);
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  ButtonWidget(
                    text: ",",
                    onPressed: () {
                      appendNumber(",");
                    },
                  ),
                  ButtonWidget(
                    text: "0",
                    onPressed: () {
                      appendNumber("0");
                    },
                  ),
                  ButtonWidget(
                    text: "=",
                    color: Colors.green,
                    textColor: Colors.white,
                    onPressed: () {
                      calculate();
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
