import 'dart:convert';
import 'package:flutter/services.dart';

class Stock {
  final int token;
  final String symbol;
  final String company;
  final String industry;
  final String sectoralIndex;
  double ltp;

  Stock({
    required this.token,
    required this.symbol,
    required this.company,
    required this.industry,
    required this.sectoralIndex,
    this.ltp = 0,
  });
}

class StockManager {
  final webSocketManager webSocketManager;
  List<Stock> _watchlist = [];

  StockManager({required this.webSocketManager});

  Future<void> loadStocksFromJson() async {
    try {
      String jsonData = await rootBundle.loadString('stocks.json');
      Map<String, dynamic> jsonMap = json.decode(jsonData);
      _watchlist = jsonMap.entries.map((entry) {
        return Stock(
          token: int.parse(entry.key),
          symbol: entry.value['symbol'],
          company: entry.value['company'],
          industry: entry.value['industry'],
          sectoralIndex: entry.value['sectoralIndex'],
        );
      }).toList();
    } catch (e) {
      print('Error loading stocks from JSON: $e');
    }
  }

  Stream<List<Stock>> get watchlistStream => Stream.fromIterable([_watchlist]);

  void subscribeToStocks() {
    webSocketManager.stream.listen((data) {
      int token = data['Token'];
      double ltp = data['LTP'];
      Stock? stockToUpdate = _watchlist.firstWhere(
        (stock) => stock.token == token,
        orElse: () => null,
      );
      if (stockToUpdate != null) {
        stockToUpdate.ltp = ltp;
      }
    }, onError: (error) {
      print('WebSocket error: $error');
    }, onDone: () {
      print('WebSocket connection closed');
    });
  }

  void removeFromWatchlist(int index) {
    int token = _watchlist[index].token;
    _watchlist.removeAt(index);
    unsubscribeFromStock(token);
  }

  void addStockToWatchlist(Stock stock) {
    _watchlist.add(stock);
    subscribeToStock(stock.token);
  }

  void subscribeToStock(int token) {
    webSocketManager.sendSubscribeRequest(token);
  }

  void unsubscribeFromStock(int token) {
    webSocketManager.sendUnsubscribeRequest(token);
  }
}
