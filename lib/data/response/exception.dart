class AppExceptions implements Exception {
  final _message;
  final _prefix;
  AppExceptions([this._message, this._prefix]);
  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppExceptions {
  FetchDataException([String? message])
    : super(message, "Error During Communication:");
}

class BadRequestException extends AppExceptions {
  BadRequestException([message]) : super(message, "Invalid Request:");
}

class UnauthorisedException extends AppExceptions {
  UnauthorisedException([message]) : super(message, "Unauthorised:");
}

class InvalidInputException extends AppExceptions {
  InvalidInputException([String? message]) : super(message, "Invalid Input:");
}

class ServerException extends AppExceptions {
  ServerException([String? message]) : super(message, "Internal Server Error:");
}

class NotFoundException extends AppExceptions {
  NotFoundException([String? message]) : super(message, "Not Found:");
}

class CacheException extends AppExceptions {
  CacheException([String? message]) : super(message, "Cache Error:");
}

class NoInternetException extends AppExceptions {
  NoInternetException([String? message]) : super(message, "No Internet:");
}

class DefaultException extends AppExceptions {
  DefaultException([String? message]) : super(message, "Error:");
}

class SocketException extends AppExceptions {
  SocketException([String? message]) : super(message, "Socket Error:");
}

class FormatException extends AppExceptions {
  FormatException([String? message]) : super(message, "Format Error:");
}
