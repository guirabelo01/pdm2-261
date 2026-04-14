import 'dart:io';
import 'dart:convert';

Future<void> main() async {
  final address = InternetAddress.loopbackIPv4;
  const port = 4040;

  final server = await ServerSocket.bind(address, port);
  print('Servidor rodando em ${server.address.address}:$port');

  await for (Socket client in server) {
    print('Cliente conectado: ${client.remoteAddress.address}:${client.remotePort}');

    client.listen(
      (data) {
        final message = utf8.decode(data).trim();
        print('Temperatura recebida: $message °C');
      },
      onError: (error) {
        print('Erro no cliente: $error');
        client.close();
      },
      onDone: () {
        print('Cliente desconectado');
        client.close();
      },
    );
  }
}