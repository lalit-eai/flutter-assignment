import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trading App - MVP',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _stocks = jsonDecode(stockData) as Map<String, dynamic>;
  final _subscriptions = <String>{};
  final _channel = WebSocketChannel.connect(Uri.parse(
      'ws://122.179.143.201:8089/websocket?sessionID=kavan&userID=kavan&apiToken=kavan'));
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _initWebsocket();
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  void _initWebsocket() {
    _channel.stream.listen((message) {
      log(message);
      final data = jsonDecode(message);
      final token = data['token'];
      if (data['mode'] == 'ltp' && _subscriptions.contains(token)) {
        setState(() {
          _stocks[token]['ltp'] = data['ltp'];
        });
      }
      _stocks.keys.forEach((token) {
        log(token);
        _subscribeToLTP(token);
      });
    });
  }

  void _subscribeToLTP(String token) {
    if (!_subscriptions.contains(token)) {
      _channel.sink.add(jsonEncode({
        'Task': 'subscribe',
        'Mode': 'ltp',
        'Tokens': [token],
      }));
      _subscriptions.add(token);
    }
  }

  void _unsubscribeFromLTP(String token) {
    if (_subscriptions.contains(token)) {
      _channel.sink.add(jsonEncode({
        'Task': 'unsubscribe',
        'Mode': 'ltp',
        'Tokens': [token],
      }));
      _subscriptions.remove(token);
    }
  }

  void _showStockDetails(BuildContext context, String token) {
    final stock = _stocks[token];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StockDetailsPage(stock: stock),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Watchlist'),
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(48.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by symbol',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) =>
                      setState(() => _searchText = value.toLowerCase()),
                ),
              ))),
      body: ListView.builder(
        itemCount: _stocks.length,
        itemBuilder: (context, index) {
          final token = _stocks.keys.elementAt(index);
          if (!token.toLowerCase().contains(_searchText)) return Container();
          final stock = _stocks[token];
          return Dismissible(
            key: Key(token),
            background: Container(color: Colors.red),
            //  confirmToDelete: true,
            onDismissed: (direction) {
              _unsubscribeFromLTP(token);
              setState(() {
                _stocks.remove(token);
              });
            },
            child: ListTile(
              title: Text(stock['symbol']),
              subtitle: Text(stock['ltp']?.toString() ?? 'N/A'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.info),
                    onPressed: () => _showStockDetails(context, token),
                  ),
                  // Optional: Add button for changing display format
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Stock details page
class StockDetailsPage extends StatelessWidget {
  final Map<String, dynamic> stock;

  const StockDetailsPage({Key? key, required this.stock}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(stock['symbol']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Company: ${stock['company']}'),
            Text('Industry: ${stock['industry']}'),
            Text('Sectoral Index: ${stock['sectoralIndex']}'),
            Text('LTP: ${stock['ltp']?.toString() ?? 'N/A'}'),
            // Add more details as needed (e.g., change, percentage change)
          ],
        ),
      ),
    );
  }
}

// Constant for stock data (replace with actual data)
const String stockData = '''
{
    "7": {
        "symbol": "AARTIIND",
        "company": "AARTI INDUSTRIES LTD",
        "industry": "Specialty Chemicals",
        "sectoralIndex": "NIFTY 500"
    },
    "13": {
        "symbol": "ABB",
        "company": "ABB INDIA LIMITED",
        "industry": "Heavy Electrical Equipment",
        "sectoralIndex": "NIFTY INFRASTRUCTURE"
    },
    "22": {
        "symbol": "ACC",
        "company": "ACC LIMITED",
        "industry": "Cement & Cement Products",
        "sectoralIndex": "NIFTY COMMODITIES"
    },
    "25": {
        "symbol": "ADANIENT",
        "company": "ADANI ENTERPRISES LIMITED",
        "industry": "Trading - Minerals",
        "sectoralIndex": "NIFTY 500"
    },
    "157": {
        "symbol": "APOLLOHOSP",
        "company": "APOLLO HOSPITALS ENTER. L",
        "industry": "Hospital",
        "sectoralIndex": "NIFTY PHARMA"
    },
    "212": {
        "symbol": "ASHOKLEY",
        "company": "ASHOK LEYLAND LTD",
        "industry": "Commercial Vehicles",
        "sectoralIndex": "NIFTY 500"
    },
    "383": {
        "symbol": "BEL",
        "company": "BHARAT ELECTRONICS LTD",
        "industry": "Aerospace & Defense",
        "sectoralIndex": "NIFTY 500"
    },
    "6705": {
        "symbol": "PAYTM",
        "company": "ONE 97 COMMUNICATIONS LTD",
        "industry": "Financial Technology (Fintech)",
        "sectoralIndex": ""
    },
    "6545": {
        "symbol": "NYKAA",
        "company": "FSN E COMMERCE VENTURES",
        "industry": "E-Retail/ E-Commerce",
        "sectoralIndex": ""
    },
    "317": {
        "symbol": "BAJFINANCE",
        "company": "BAJAJ FINANCE LIMITED",
        "industry": "Non Banking Financial Company (NBFC)",
        "sectoralIndex": "NIFTY FINANCIAL SERVICES"
    },
    "480": {
        "symbol": "BIRLACORPN",
        "company": "BIRLA CORPORATION LTD",
        "industry": "Cement & Cement Products",
        "sectoralIndex": "NIFTY COMMODITIES"
    },
    "694": {
        "symbol": "CIPLA",
        "company": "CIPLA LTD",
        "industry": "Pharmaceuticals",
        "sectoralIndex": "NIFTY PHARMA"
    },
    "772": {
        "symbol": "DABUR",
        "company": "DABUR INDIA LTD",
        "industry": "Personal Care",
        "sectoralIndex": "NIFTY FMCG"
    },
    "1333": {
        "symbol": "HDFCBANK",
        "company": "HDFC BANK LTD",
        "industry": "Private Sector Bank",
        "sectoralIndex": "NIFTY BANK"
    },
    "1476": {
        "symbol": "IDBI",
        "company": "IDBI BANK LIMITED",
        "industry": "Private Sector Bank",
        "sectoralIndex": "NIFTY BANK"
    },
    "2475": {
        "symbol": "ONGC",
        "company": "OIL AND NATURAL GAS CORP.",
        "industry": "Oil Exploration & Production",
        "sectoralIndex": "NIFTY 500"
    },
    "2868": {
        "symbol": "HITECH",
        "company": "HI-TECH PIPES LIMITED",
        "industry": "Iron & Steel Products",
        "sectoralIndex": "NIFTY METAL"
    },
    "2955": {
        "symbol": "KALYANKJIL",
        "company": "KALYAN JEWELLERS IND LTD",
        "industry": "Gems Jewellery And Watches",
        "sectoralIndex": ""
    },
    "2963": {
        "symbol": "SAIL",
        "company": "STEEL AUTHORITY OF INDIA",
        "industry": "Iron & Steel",
        "sectoralIndex": "NIFTY METAL"
    },
    "3024": {
        "symbol": "JINDALSAW",
        "company": "JINDAL SAW LIMITED",
        "industry": "Iron & Steel Products",
        "sectoralIndex": "NIFTY METAL"
    },
    "3045": {
        "symbol": "SBIN",
        "company": "STATE BANK OF INDIA",
        "industry": "Public Sector Bank",
        "sectoralIndex": "NIFTY BANK"
    },
    "3150": {
        "symbol": "SIEMENS",
        "company": "SIEMENS LTD",
        "industry": "Heavy Electrical Equipment",
        "sectoralIndex": "NIFTY 500"
    },
    "3389": {
        "symbol": "AGARIND",
        "company": "AGARWAL INDS CORP LTD.",
        "industry": "Petrochemicals",
        "sectoralIndex": "NIFTY INFRASTRUCTURE"
    },
    "3405": {
        "symbol": "TATACHEM",
        "company": "TATA CHEMICALS LTD",
        "industry": "Commodity Chemicals",
        "sectoralIndex": "NIFTY 500"
    },
    "3426": {
        "symbol": "TATAPOWER",
        "company": "TATA POWER CO LTD",
        "industry": "Integrated Power Utilities",
        "sectoralIndex": "NIFTY INFRASTRUCTURE"
    },
    "3506": {
        "symbol": "TITAN",
        "company": "TITAN COMPANY LIMITED",
        "industry": "Gems Jewellery And Watches",
        "sectoralIndex": "NIFTY 500"
    },
    "3626": {
        "symbol": "HEALTHIETF",
        "company": "ICICIPRAMC - ICICIPHARM",
        "industry": "Mutual Fund Scheme",
        "sectoralIndex": "NA"
    },
    "3787": {
        "symbol": "WIPRO",
        "company": "WIPRO LTD",
        "industry": "Computers - Software & Consulting",
        "sectoralIndex": "NIFTY IT"
    },
    "4391": {
        "symbol": "GULFOILLUB",
        "company": "GULF OIL LUB. IND. LTD.",
        "industry": "Lubricants",
        "sectoralIndex": "NIFTY 500"
    },
    "5258": {
        "symbol": "INDUSINDBK",
        "company": "INDUSIND BANK LIMITED",
        "industry": "Private Sector Bank",
        "sectoralIndex": "NIFTY BANK"
    },
    "5279": {
        "symbol": "ROLEXRINGS",
        "company": "ROLEX RINGS LIMITED",
        "industry": "Auto Components & Equipments",
        "sectoralIndex": ""
    }
}
''';
