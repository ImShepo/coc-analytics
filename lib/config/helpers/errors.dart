Exception handleDioException(int statusCode) {
  if (statusCode != 200) {
    switch (statusCode) {
      case 400:
        throw 'Bad request, please check your input.';
      case 401:
        throw 'Unauthorized access, please log in.';
      case 403:
        throw 'Acceso denegado (403). Revisa tu API key en .env';
      case 500:
        throw 'Internal server error, please try again later.';
      default:
        throw 'Unexpected error occurred.';
    }
  } else {
    throw 'Connection error, please check your internet.';
  }
}
