import 'package:web_socket_channel/io.dart';

class WebSocketManager {
  final IOWebSocketChannel _channel;

  WebSocketManager()
      : _channel = IOWebSocketChannel.connect(
            'ws://122.179.143.201:8089/websocket?sessionID=dezi&userID=dezi&apiToken=dezi');

  Stream<Map<String, dynamic>> get stream => _channel.stream;

  void dispose() {
    _channel.sink.close();
  }
}
