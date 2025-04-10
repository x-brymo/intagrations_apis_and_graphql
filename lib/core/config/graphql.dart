import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ServicesGraphQl {
  ValueNotifier<GraphQLClient> init() { 
    final HttpLink httpLink = HttpLink('https://graphqlzero.almansi.me/api');
    final GraphQLClient client = GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(),
    );
    return ValueNotifier(client);
  }
}
