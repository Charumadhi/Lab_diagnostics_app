import 'package:postgres/postgres.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> operation() async {
  // Load environment variables from .env file
  await dotenv.load();

  var username = dotenv.env['postgres'];
  var password = dotenv.env['charu0517'];
  var databaseName = 'djb7v0k318g55';
  var host = 'ec2-31-242-24-212.compute-1.amazonaws.com';
  var port = 5432;

  if (username == null || password == null) {
    print('Missing required environment variables for database connection.');
    return;
  }

  var connection = PostgreSQLConnection(
    host,
    port,
    databaseName,
    username: username,
    password: password,
    useSSL: true,
  );

  try {
    await connection.open();
    print("Connected");
    // Perform database operations here
  } catch (e) {
    print("Error connecting to the database: $e");
  } finally {
    await connection.close();
    print("Connection closed");
  }
}

void main() {
  operation();
}
