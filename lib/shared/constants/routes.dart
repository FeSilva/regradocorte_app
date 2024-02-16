class Routes {  
  static const String authService = "https://identitytoolkit.googleapis.com/v1/";
  static const String apiKey = "AIzaSyCcLkSPnXprPnl84uY0sEXwyuL3QPTv-mI";

  String signIn() {
    return authService + "accounts:signInWithPassword?key=" + apiKey;
  }

  String signUp() {
    return authService + "accounts:signUp?key=" + apiKey;
  }
}