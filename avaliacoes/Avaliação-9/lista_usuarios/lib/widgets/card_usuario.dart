import 'package:flutter/material.dart';
import '../models/usuario.dart';

/// Widget de card personalizado exibido em cada item do ListView.
class CardUsuario extends StatelessWidget {
  final Usuario usuario;

  const CardUsuario({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Avatar com inicial do nome ──────────────────────────────
            _Avatar(inicial: usuario.inicial, id: usuario.id),
            const SizedBox(width: 14),
            // ── Informações do usuário ──────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nome
                  Text(
                    usuario.nome,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Empresa
                  Text(
                    usuario.empresa,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF2563EB),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Divider(height: 14, thickness: 0.5),
                  // Linhas de info
                  _InfoLinha(Icons.email_outlined, usuario.email),
                  _InfoLinha(Icons.phone_outlined, usuario.telefone),
                  _InfoLinha(Icons.location_on_outlined, usuario.cidade),
                  _InfoLinha(Icons.language_outlined, usuario.website),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Avatar colorido com base no ID ─────────────────────────────────────────
class _Avatar extends StatelessWidget {
  final String inicial;
  final int id;

  const _Avatar({required this.inicial, required this.id});

  static const List<Color> _cores = [
    Color(0xFF2563EB),
    Color(0xFF7C3AED),
    Color(0xFFDB2777),
    Color(0xFFD97706),
    Color(0xFF059669),
    Color(0xFF0891B2),
    Color(0xFFDC2626),
    Color(0xFF65A30D),
    Color(0xFF9333EA),
    Color(0xFF0369A1),
  ];

  @override
  Widget build(BuildContext context) {
    final cor = _cores[id % _cores.length];
    return CircleAvatar(
      radius: 28,
      backgroundColor: cor.withOpacity(0.15),
      child: Text(
        inicial,
        style: TextStyle(
          color: cor,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ── Linha de informação com ícone ──────────────────────────────────────────
class _InfoLinha extends StatelessWidget {
  final IconData icone;
  final String texto;

  const _InfoLinha(this.icone, this.texto);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(icone, size: 14, color: const Color(0xFF94A3B8)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF475569),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
