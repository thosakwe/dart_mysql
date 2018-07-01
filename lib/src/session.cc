#include <mysqlx/xapi.h>
#include <dart_api.h>
#include "dart_mysql_connector.h"

void Session_close(Dart_NativeArguments arguments)
{
    // Read the pointer sent by the user.
    Dart_Handle pointerHandle = Dart_GetNativeArgument(arguments, 0);
    uint64_t pointer;
    HandleError(Dart_IntegerToUint64(pointerHandle, &pointer));

    auto *session = (mysqlx_session_t *)pointer;
    mysqlx_session_close(session);
}

void Session_new(Dart_NativeArguments arguments)
{
    // Read the URL sent by the user.
    Dart_Handle urlHandle = Dart_GetNativeArgument(arguments, 0);
    const char *url;
    HandleError(Dart_StringToCString(urlHandle, &url));

    // (Attempt to) connect to the database.
    char connectionError[MYSQLX_MAX_ERROR_LEN];
    int connectionErrorCode;
    mysqlx_session_t *session = mysqlx_get_session_from_url(url, connectionError, &connectionErrorCode);

    if (!session)
    {
        Dart_Handle result = Dart_NewList(3);
        Dart_ListSetAt(result, 0, Dart_NewInteger(connectionErrorCode));
        Dart_ListSetAt(result, 1, Dart_NewStringFromCString(connectionError));
        Dart_ListSetAt(result, 2, Dart_Null());
        Dart_SetReturnValue(arguments, result);
        return;
    }

    Dart_Handle result = Dart_NewList(3);
    Dart_ListSetAt(result, 0, Dart_Null());
    Dart_ListSetAt(result, 1, Dart_Null());
    Dart_ListSetAt(result, 2, Dart_NewIntegerFromUint64((uint64_t)session));
    Dart_SetReturnValue(arguments, result);
}