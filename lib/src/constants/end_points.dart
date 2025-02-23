class Endpoints {
  static String baseUrl =
      'https://shark-app-s8ndy.ondigitalocean.app/api/studentLogin';

  static String userData =
      'https://shark-app-s8ndy.ondigitalocean.app/api/studentData';
  static String payments =
      'https://shark-app-s8ndy.ondigitalocean.app/api/stPayments';
  static String request =
      'https://shark-app-s8ndy.ondigitalocean.app/api/student-requests';

  static String forgetPw =
      'https://shark-app-s8ndy.ondigitalocean.app/api/students/forgot-password';
}

class PayMob {
  static String baseUrl = 'https://accept.paymob.com/api';
  static String api_key =
      'ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SndjbTltYVd4bFgzQnJJam8yT0RVNE1URXNJbTVoYldVaU9pSnBibWwwYVdGc0lpd2lZMnhoYzNNaU9pSk5aWEpqYUdGdWRDSjkuRmU2SnJ0TmJxRFFzeWFOeEJVR1dXMUR5NXFZeHR2NGhHcmwwVXQ1MTBGZVBseDJFNkZpRlM1SlBzRENWbzdRNnNPdTNyUTRyZTV4dVVkZ29ObUFCQ1E=';
  static String sk_key =
      'egy_sk_test_ebc24ab35db7779f4cd97327d937de666090c5495b4d978412a7419688761570';
  static String pk_key = 'egy_pk_test_IJSBa266eJAwwBHzlpxVWIoYxz5wEn2R';
  static String reqToken = 'https://accept.paymob.com/api/auth/tokens';
  static String orderId = '$baseUrl/api/ecommerce/orders';
  static String paymentorder = '$baseUrl/acceptance/payment_keys';
  static String paymentkey = '';
  static String token = '';
  static String userOrderId = '';
  static const String integrationIdCard = '3347928';
  static String afterPayToken = '';
}
