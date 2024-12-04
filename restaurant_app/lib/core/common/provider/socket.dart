import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:restaurant_app/config/constants/api_endpoints.dart';

final socketProvider = Provider<Socket>((ref) {
  return Socket(
    io.io(ApiEndpoints.socketServerURL, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    }),
  );
});

class Socket{
  io.Socket socket;
  Socket(this.socket);
}