#ifndef DART_MYSQL_H
#define DART_MYSQL_H
#include <dart_api.h>
#define DART_MYSQL_CODE_OPEN 0

Dart_Handle HandleError(Dart_Handle handle);

void Session_close(Dart_NativeArguments arguments);
void Session_new(Dart_NativeArguments arguments);
#endif