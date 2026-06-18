class MockAuthService {
  static Future<bool> login(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return username == "admin" && password == "admin123";
  }
}
