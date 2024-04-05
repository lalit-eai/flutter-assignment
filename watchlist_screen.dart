import 'package:flutter/material.dart';
import 'stock_manager.dart';

class WatchlistScreen extends StatefulWidget {
  @override
  _WatchlistScreenState createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  late StockManager _stockManager;
   @override
  void initState() {
    super.initState();
    _stockManager = StockManager();
    _stockManager.loadStocksFromJson();
    _stockManager.subscribeToStocks();
    _stockManager.subscribeToStocks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Watchlist'),
      ),
      body: StreamBuilder<List<Stock>>(
        stream: _stockManager.watchlistStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Stock>? watchlist = snapshot.data;
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                Stock stock = snapshot.data![index];
                return ListTile(
                  title: Text(stock.symbol),
                  subtitle: Text('LTP: ${stock.ltp.toStringAsFixed(2)}'),
                  onLongPress: () {
                    _stockManager.removeFromWatchlist(index);
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _stockManager.addStocksToWatchlist();
        },
        tooltip: 'Add Stocks',
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _webSocketManager.dispose();
    super.dispose();
  }
}