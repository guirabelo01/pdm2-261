import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';
import '../widgets/card_usuario.dart';

/// Tela principal do app.
/// Responsável por:
///   1. Fazer a requisição GET à API
///   2. Decodificar o JSON e converter em lista de Usuario
///   3. Gerenciar estado: loading, erro e dados
///   4. Exibir ListView.builder com cards e pull-to-refresh
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ── Estado da tela ────────────────────────────────────────────────────────
  List<Usuario> _usuarios = [];
  bool _carregando = true;
  String? _erro;

  static const String _apiUrl =
      'https://jsonplaceholder.typicode.com/users';

  // ── Ciclo de vida ─────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _buscarUsuarios(); // Carrega os dados ao abrir a tela
  }

  // ── Requisição HTTP GET ───────────────────────────────────────────────────
  Future<void> _buscarUsuarios() async {
    // Ativa o indicador de carregamento e limpa erro anterior
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      // 1. Faz a requisição com timeout de 10 segundos
      final response = await http
          .get(Uri.parse(_apiUrl))
          .timeout(const Duration(seconds: 10));

      // 2. Verifica o status HTTP
      if (response.statusCode == 200) {
        // 3. Decodifica o JSON
        final List<dynamic> jsonList = jsonDecode(response.body);

        // 4. Converte cada item em um objeto Usuario
        final lista = jsonList
            .map((json) => Usuario.fromJson(json as Map<String, dynamic>))
            .toList();

        // 5. Atualiza o estado para renderizar a lista
        setState(() {
          _usuarios = lista;
          _carregando = false;
        });
      } else {
        // Erro de status HTTP (ex: 404, 500)
        setState(() {
          _erro = 'Erro do servidor: ${response.statusCode}.\nTente novamente.';
          _carregando = false;
        });
      }
    } on http.ClientException {
      // Sem internet ou falha de conexão
      setState(() {
        _erro = 'Sem conexão com a internet.\nVerifique sua rede e tente novamente.';
        _carregando = false;
      });
    } on FormatException {
      // JSON inválido
      setState(() {
        _erro = 'Resposta inválida da API.\nO formato dos dados é inesperado.';
        _carregando = false;
      });
    } catch (e) {
      // Qualquer outro erro (timeout incluso)
      setState(() {
        _erro = 'Não foi possível carregar os dados.\n$e';
        _carregando = false;
      });
    }
  }

  // ── Build principal ───────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF2563EB),
      elevation: 0,
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lista de Usuários',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'jsonplaceholder.typicode.com',
            style: TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
      actions: [
        // Botão de recarregar manual
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          tooltip: 'Recarregar',
          onPressed: _carregando ? null : _buscarUsuarios,
        ),
      ],
    );
  }

  // ── Corpo: decide entre loading, erro ou lista ────────────────────────────
  Widget _buildBody() {
    if (_carregando) {
      return _buildLoading();
    }
    if (_erro != null) {
      return _buildErro();
    }
    return _buildLista();
  }

  // ── Tela de carregamento ──────────────────────────────────────────────────
  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Color(0xFF2563EB),
            strokeWidth: 3,
          ),
          SizedBox(height: 20),
          Text(
            'Buscando usuários...',
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  // ── Tela de erro com botão de retry ──────────────────────────────────────
  Widget _buildErro() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                size: 56,
                color: Colors.red.shade400,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ops! Algo deu errado',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _erro!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: _buscarUsuarios,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Lista com pull-to-refresh ─────────────────────────────────────────────
  Widget _buildLista() {
    return RefreshIndicator(
      onRefresh: _buscarUsuarios, // Deslizar para baixo recarrega
      color: const Color(0xFF2563EB),
      child: Column(
        children: [
          // Banner com total de usuários carregados
          Container(
            width: double.infinity,
            color: const Color(0xFF2563EB),
            padding: const EdgeInsets.only(
              left: 16, right: 16, bottom: 16, top: 4,
            ),
            child: Text(
              '${_usuarios.length} usuários carregados',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ),
          // ListView.builder com os cards
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
              itemCount: _usuarios.length,
              itemBuilder: (context, index) {
                final usuario = _usuarios[index];
                return CardUsuario(usuario: usuario);
              },
            ),
          ),
        ],
      ),
    );
  }
}
