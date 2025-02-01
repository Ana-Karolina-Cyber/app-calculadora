// ignore: depend_on_referenced_packages
import 'package:expressions/expressions.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  final String _C = 'C';
  String _expressao = '';
  String _resultado = '';

  void _pressionarBotao(String valor) {
    setState(() {
      if (valor == _C) {
        _expressao = '';
        _resultado = '';
      } else if (valor == '=') {
        _calcularResultado();
      } else {
        // Novas operações: dando sentido as expressões
        if (valor == 'x²') {
          _expressao += '^2';
        } else if (valor == '√') {
          _expressao += '√';
        } else if (valor == '!') {
          _expressao += '!';
        } else if (valor == '%') {
          _expressao += '%';
        } else {
          _expressao += valor;
        }
      }
    });
  }

  void _calcularResultado() {
    try {
      _resultado = _avaliarExpressao(_expressao).toString();
    } catch (e) {
      _resultado = 'Erro';
    }
  }

  num _avaliarExpressao(String expressao) {
    expressao = expressao.replaceAll('x', '*');
    expressao = expressao.replaceAll('÷', '/');

    // Novos códigos, definidos em aula presencial
    if (expressao.contains('√')) {
      return sqrt(_avaliarExpressao(expressao.replaceAll('√', '')));
    } else if (expressao.contains('^2')) {
      // Corrigindo a chamada para a função de potencia
      return pow(_avaliarExpressao(expressao.replaceAll('^2', '')), 2);
    } else if (expressao.contains('!')) {
      return _fatorial(int.parse(expressao.replaceAll('!', '')));
    } else if (expressao.contains('%')) {
      return _avaliarExpressao(expressao.replaceAll('%', '')) / 100;
    }
    ExpressionEvaluator avaliador = const ExpressionEvaluator();
    double resultado =
        avaliador.eval(Expression.parse(expressao), {}) as double;
    return resultado;
  }

  int _fatorial(int n) {
    if (n <= 1) return 1;
    return n * _fatorial(n - 1);
  }

  Widget _botao(String valor) {
    return TextButton(
      onPressed: () => _pressionarBotao(valor),
      style: TextButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 105, 105, 105),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color.fromARGB(255, 55, 55, 55), width: 2),
        ),
      ),
      child: Text(
        valor,
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Text(
            _expressao,
            style: const TextStyle(fontSize: 24,
              shadows: [
                Shadow(
                  offset: Offset(1.0, 1.0),
                  blurRadius: 2.0,
                  color: Color.fromARGB(5, 255, 255, 255),
                ),
              ],
            ),
          ),
        ),

         Center( // Centraliza a linha no meio da tela
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 3, // Define a largura da linha para metade da tela
            child: const Divider(
              color: Color.fromARGB(255, 0, 0, 0),
              thickness: 1,
            ),
          ),
        ),

        Expanded(
          child: Text(
            _resultado,
            style: const TextStyle(fontSize: 24,
              shadows: [
                Shadow(
                  offset: Offset(1.0, 1.0),
                  blurRadius: 2.0,
                  color: Color.fromARGB(5, 255, 255, 255),
                ),
              ],
            ), 
          ),
        ),
        Expanded(
          flex: 3,
          child: GridView.count(
            crossAxisCount: 4,
            childAspectRatio: 2,
            children: [
              _botao('7'),
              _botao('8'),
              _botao('9'),
              _botao('÷'),
              _botao('4'),
              _botao('5'),
              _botao('6'),
              _botao('x'),
              _botao('1'),
              _botao('2'),
              _botao('3'),
              _botao('-'),
              _botao('0'),
              _botao('.'),
              _botao('='),
              _botao('+'),
              _botao('!'),
              _botao('%'),
              _botao('√'),
              _botao('x²'),
            ],
          ),
        ),
        Expanded(
          child: _botao(_C),
        ),
      ],
    );
  }
}
