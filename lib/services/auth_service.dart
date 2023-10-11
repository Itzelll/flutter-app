import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AuthService with ChangeNotifier {
  final String urlApi = "http://localhost:8000/graphql/";
  bool _auntenticando = false;

  bool get autenticando => _auntenticando;
  set autenticando(bool valor) {
    _auntenticando = valor;
    notifyListeners();
  }
  
  Future<bool> login(String username, String password) async {
  final HttpLink httpLink = HttpLink(
    urlApi,
  );

  final GraphQLClient client = GraphQLClient(
    cache: GraphQLCache(),
    link: httpLink,
  );

  final MutationOptions options = MutationOptions(
    document: gql('''
      mutation LoginUser(\$username: String!, \$password: String!) {
        tokenAuth(username: \$username, password: \$password) {
          token
        }
      }
    '''),
    variables: <String, dynamic>{
      'username': username,
      'password': password,
    },
  );

  final QueryResult result = await client.mutate(options);

  if (result.hasException) {
    return false; 
  }

  final String? token = result.data?['tokenAuth']['token'];
  
  return token != null;
}

Future<bool> register(String email, String username, String password) async {
    final HttpLink httpLink = HttpLink(
      urlApi,
    );

    final GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: httpLink,
    );

    final MutationOptions options = MutationOptions(
      document: gql('''
        mutation RegisterUser(\$email: String!, \$username: String!, \$password: String!) {
          createUser(email: \$email, username: \$username, password: \$password) {
            user {
              id
              username
              email
            }
          }
        }
      '''),
      variables: <String, dynamic>{
        'email': email,
        'username': username,
        'password': password,
      },
    );

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      return false;
    }

    return true;
  }

}