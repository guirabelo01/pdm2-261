import 'dart:io';
import 'dart:async';
import 'dart:math';

Future<void> main() async {
  final address = InternetAddress.loopbackIPv4;
  const port = 4040;

  try {
    final socket = await Socket.connect(address, port);
    print('Conectado ao servidor ${socket.remoteAddress.address}:$port');

    final random = Random();

    // Envia temperatura a cada 10 segundos
    Timer.periodic(Duration(seconds: 10), (timer) {
      double temperature = 20 + random.nextDouble() * 15; // 20°C a 35°C
      String message = temperature.toStringAsFixed(2);

      socket.write(message + '\n');
      print('Temperatura enviada: $message °C');
    });

  } catch (e) {
    print('Erro ao conectar: $e');
  }
}