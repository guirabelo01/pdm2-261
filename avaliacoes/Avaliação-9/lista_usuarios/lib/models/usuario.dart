/// Modelo que representa um usuário retornado pela API.
/// A API utilizada é: https://jsonplaceholder.typicode.com/users
class Usuario {
  final int id;
  final String nome;
  final String email;
  final String telefone;
  final String website;
  final String cidade;
  final String empresa;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.website,
    required this.cidade,
    required this.empresa,
  });

  /// Converte um Map (JSON decodificado) em um objeto Usuario.
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] as int,
      nome: json['name'] as String,
      email: json['email'] as String,
      telefone: json['phone'] as String,
      website: json['website'] as String,
      cidade: json['address']['city'] as String,
      empresa: json['company']['name'] as String,
    );
  }

  /// Retorna a inicial do nome para uso no avatar.
  String get inicial => nome.isNotEmpty ? nome[0].toUpperCase() : '?';
}
