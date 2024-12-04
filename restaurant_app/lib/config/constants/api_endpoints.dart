class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);

  // static const String baseUrl = "http://10.0.2.2:5000/api/";
  // static const String socketServerURL = "http://10.0.2.2:5000/";
  static const String baseUrl = "https://192.168.1.70:5000/api/";
  static const String socketServerURL = "https://192.168.1.70:5000/";

  static const limitPage = 5;

  // ======================== Auth Routes ========================
  static const String login = "user/login";
  static const String register = "user/signup";
  static const String sendOTP = "user/send-otp";
  static const String verifyOTP = "user/verify-otp";
  static const String resetPassword = "user/reset-password";

  // ====================== Category Routes ======================
  static const String getAllCategory = "category/get-categories";

  // ======================== Food Routes ========================
  static const String getSelectedFood = "food/get-selected";
  static const String getSearchedFood = "food/search";

  // ======================= Order Routes ========================
  static const String createOrders = "order/create-order";
  static const String addToOrders = "order/add-to-order";
  static const String updatePayment = "order/update-payment";
  static const String getOrders = "order/get-orders";
  static const String deleteOrder = "order/delete-order";
  static const String getHistory = "order/get-orders";

  // ===================== Favourites Routes =====================
  static const String addToFavourites = "favourites/add-to-favourites";
  static const String removeFromFavourites = "favourites/remove-from-favourites";
  static const String getFavourites = "favourites/get-favourites";
}
