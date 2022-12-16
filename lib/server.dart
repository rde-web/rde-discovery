import 'dart:io';

import 'package:leto/leto.dart';
import 'package:leto_shelf/leto_shelf.dart';
import 'package:rde_discovery/graphql_api.schema.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

Future<HttpServer> runServer(int port, {bool playground = false}) async {
  final ScopedMap scopedMap = ScopedMap();
  final schema = graphqlApiSchema;
  final letoGraphQL = GraphQL(
    schema,
    extensions: [],
    introspect: true,
    globalVariables: scopedMap,
  );

  const graphqlPath = 'discover';

  final app = Router();
  app.post(
    '/$graphqlPath',
    graphQLHttp(letoGraphQL),
  );

  if (playground) {
    final endpoint = 'http://localhost:$port/$graphqlPath';
    app.get(
      '/playground',
      playgroundHandler(
        config: PlaygroundConfig(
          endpoint: endpoint,
        ),
      ),
    );
  }

  app.get('/schema', (Request request) {
    return Response.ok(
      schema.schemaStr,
      headers: {
        'content-type': 'text/plain',
        'content-disposition': 'inline',
      },
    );
  });

  final server = await shelf_io.serve(
    const Pipeline()
        .addMiddleware(customLog(log: (msg) {
          if (!msg.contains('IntrospectionQuery')) {
            print(msg);
          }
        }))
        .addMiddleware(cors())
        .addMiddleware(etag())
        .addMiddleware(jsonParse())
        .addHandler(app),
    '0.0.0.0',
    port,
  );

  return server;
}
