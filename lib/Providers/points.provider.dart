import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class Transaction {
  final String type;
  final String title;
  final int points;
  final DateTime dateTime;
  final String? redemptionCode;

  Transaction({
    required this.type,
    required this.title,
    required this.points,
    required this.dateTime,
    this.redemptionCode,
  });
}

class PointsProvider with ChangeNotifier {
  int _totalPoints = 308;
  List<Transaction> _transactions = [];

  int get totalPoints => _totalPoints;
  List<Transaction> get transactions => _transactions;

  Future<void> donatePoints(String title, int points) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      
      _totalPoints -= points;
      _transactions.insert(0, Transaction(
        type: 'Donasi',
        title: title,
        points: -points,
        dateTime: DateTime.now(),
      ));
      notifyListeners();
      
      /* actual HTTP request 
      final response = await http.post(
        Uri.parse('https://api.example.com/donate'),
        body: json.encode({
          'title': title,
          'points': points,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        _totalPoints -= points;
        _transactions.insert(0, Transaction(
          type: 'Donasi',
          title: title,
          points: -points,
          dateTime: DateTime.now(),
        ));
        notifyListeners();
      } else {
        throw Exception('Gagal melakukan donasi');
      }
      */
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> exchangePoints(String title, int points) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      
      _totalPoints -= points;
      _transactions.insert(0, Transaction(
        type: 'Barang Ecofriendly',
        title: title,
        points: -points,
        dateTime: DateTime.now(),
        redemptionCode: _generateRedemptionCode(),
      ));
      notifyListeners();
      
      /* actual HTTP request 
      final response = await http.post(
        Uri.parse('https://api.example.com/exchange'),
        body: json.encode({
          'title': title,
          'points': points,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        _totalPoints -= points;
        _transactions.insert(0, Transaction(
          type: 'Barang Ecofriendly',
          title: title,
          points: -points,
          dateTime: DateTime.now(),
          redemptionCode: _generateRedemptionCode(),
        ));
        notifyListeners();
      } else {
        throw Exception('Gagal melakukan penukaran');
      }
      */
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  String _generateRedemptionCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(12, (index) => chars[random.nextInt(chars.length)]).join();
  }
}