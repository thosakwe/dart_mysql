import 'package:mysql/mysql.dart';

main() async {
  var session = new MySqlSession(Uri.parse('mysqlx://root@127.0.0.1'));
  await session.open();
  print('MySQL!!!');
  await session.close();
}