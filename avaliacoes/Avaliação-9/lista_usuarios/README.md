# Lista de Usuários — Flutter

Aplicativo Flutter que consome a API pública [JSONPlaceholder](https://jsonplaceholder.typicode.com/users) e exibe uma lista de usuários em cards estilizados.

## Funcionalidades

- ✅ Requisição HTTP GET com o pacote `http`
- ✅ Timeout de 10 segundos na requisição
- ✅ Tratamento de erros (sem internet, erro do servidor, JSON inválido)
- ✅ Decodificação de JSON e conversão em objetos `Usuario`
- ✅ Indicador de carregamento (`CircularProgressIndicator`)
- ✅ Mensagem de erro amigável com botão "Tentar novamente"
- ✅ `ListView.builder` com cards personalizados
- ✅ Pull-to-refresh (`RefreshIndicator`)
- ✅ Botão de recarregar na AppBar

## Estrutura do Projeto

```
lib/
├── main.dart                  # Ponto de entrada do app
├── models/
│   └── usuario.dart           # Classe de modelo com fromJson
├── screens/
│   └── home_screen.dart       # Tela principal (requisição + estado + lista)
└── widgets/
    └── card_usuario.dart      # Widget de card para cada usuário
```

## Como rodar

```bash
# 1. Instalar dependências
flutter pub get

# 2. Rodar o app
flutter run
```

## API Utilizada

**JSONPlaceholder** — `https://jsonplaceholder.typicode.com/users`

API pública e gratuita para testes. Retorna 10 usuários fictícios no formato JSON.

## Exemplo de resposta da API

```json
{
  "id": 1,
  "name": "Leanne Graham",
  "email": "Sincere@april.biz",
  "phone": "1-770-736-8031 x56442",
  "website": "hildegard.org",
  "address": { "city": "Gwenborough" },
  "company": { "name": "Romaguera-Crona" }
}
```

## Dependências

| Pacote | Versão | Uso |
|--------|--------|-----|
| `http` | ^1.2.1 | Requisições HTTP |
