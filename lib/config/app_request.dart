class AppRequest {
  static Map<String, String> header([String? bearerToken]) {
    if (bearerToken == null) {
      return {
        "Accept": "application/json",
      };
    } else {
      return {
        "Accept": "application/json",
        "Accept-Encoding": "gzip, deflate, br",
        "Connection": "keep-alive",
        "Authorization": "Bearer $bearerToken"
      };
    }
  }
}
