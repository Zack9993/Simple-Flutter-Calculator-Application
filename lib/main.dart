import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Responsive Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        hintColor: Colors.blueAccent,
      ),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> with SingleTickerProviderStateMixin {
  String output = "0";
  String _output = "0";
  double num1 = 0;
  double num2 = 0;
  String operand = "";
  bool isDarkMode = false;
  List<String> history = [];
  late AnimationController _animationController;
  late Animation<Color?> _buttonColorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _buttonColorAnimation = ColorTween(
      begin: Colors.blue,
      end: Colors.blueAccent,
    ).animate(_animationController);
  }

  void buttonPressed(String buttonText) {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    if (buttonText == "C") {
      _output = "0";
      num1 = 0;
      num2 = 0;
      operand = "";
    } else if (buttonText == "+" || buttonText == "-" || buttonText == "x" || buttonText == "/" || buttonText == "%" || buttonText == "√" || buttonText == "^" || buttonText == "!") {
      num1 = double.parse(output);
      operand = buttonText;
      _output = "0";
    } else if (buttonText == ".") {
      if (_output.contains(".")) {
        return;
      } else {
        _output = _output + buttonText;
      }
    } else if (buttonText == "=") {
      num2 = double.parse(output);

      switch (operand) {
        case "+":
          _output = (num1 + num2).toString();
          break;
        case "-":
          _output = (num1 - num2).toString();
          break;
        case "x":
          _output = (num1 * num2).toString();
          break;
        case "/":
          if (num2 == 0) {
            _output = "Error";
          } else {
            _output = (num1 / num2).toString();
          }
          break;
        case "%":
          _output = (num1 % num2).toString();
          break;
        case "√":
          _output = (num1 * num1).toString();
          break;
        case "^":
          _output = (num1 * num1 * num1).toString();
          break;
        case "!":
          _output = factorial(num1.toInt()).toString();
          break;
      }

      history.add("$num1 $operand $num2 = $_output");
      num1 = 0;
      num2 = 0;
      operand = "";
    } else if (buttonText == "√") {
      num1 = double.parse(output);
      _output = (num1 * num1).toString();
    } else if (buttonText == "%") {
      num1 = double.parse(output);
      _output = (num1 / 100).toString();
    } else {
      _output = _output == "0" ? buttonText : _output + buttonText;
    }

    setState(() {
      output = _output;
    });
  }

  int factorial(int n) {
    if (n == 0 || n == 1) return 1;
    return n * factorial(n - 1);
  }

  Widget buildButton(String buttonText, {Color? color}) {
    return Flexible(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedBuilder(
          animation: _buttonColorAnimation,
          builder: (context, child) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color ?? _buttonColorAnimation.value,
                padding: EdgeInsets.all(24.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onPressed: () => buttonPressed(buttonText),
              child: Text(
                buttonText,
                style: TextStyle(fontSize: 24.0, color: Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;

    return Scaffold(
      appBar: AppBar(
        title: Text('Advanced Responsive Calculator'),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              setState(() {
                isDarkMode = !isDarkMode;
              });
            },
          ),
        ],
      ),
      body: AnimatedTheme(
        data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
        duration: Duration(milliseconds: 500),
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      output,
                      style: TextStyle(fontSize: isPortrait ? 48.0 : 36.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Divider(),
              Expanded(
                flex: isPortrait ? 6 : 4,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          buildButton("7"),
                          buildButton("8"),
                          buildButton("9"),
                          buildButton("/", color: Colors.orange),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          buildButton("4"),
                          buildButton("5"),
                          buildButton("6"),
                          buildButton("x", color: Colors.orange),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          buildButton("1"),
                          buildButton("2"),
                          buildButton("3"),
                          buildButton("-", color: Colors.orange),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          buildButton("."),
                          buildButton("0"),
                          buildButton("C", color: Colors.red),
                          buildButton("+", color: Colors.orange),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          buildButton("√", color: Colors.green),
                          buildButton("%", color: Colors.green),
                          buildButton("^", color: Colors.green),
                          buildButton("!", color: Colors.green),
                          buildButton("=", color: Colors.blue),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "History",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: history.length,
                          itemBuilder: (context, index) {
                            return Text(history[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}