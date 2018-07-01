import 'package:mysql/mysql.dart';

main() async {
  var session = new MySqlSession(Uri.parse('mysqlx://root@127.0.0.1'));
  await session.open();
  await session.close();
}