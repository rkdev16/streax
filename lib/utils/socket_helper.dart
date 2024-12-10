import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:streax/network/api_urls.dart';
import 'package:streax/utils/preference_manager.dart';

class SocketHelper {
  SocketHelper._();

  static IO.Socket? _socket;

  ///
  IO.Socket get socket {
    return _socket!;
  }

  static IO.Socket getInstance() {
    _socket ??= IO.io(
       ApiUrls.baseUrl,
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .build());

    if (!_socket!.connected) {
      _socket?.connect();
      _socket?.on('onConnection', (data) =>
          _socket?.emit('join',{
            'userId':PreferenceManager.user?.id
          })
      );
    }

    debugPrint("SocketConnected = ${_socket?.connected}");
    return _socket!;
  }
}
