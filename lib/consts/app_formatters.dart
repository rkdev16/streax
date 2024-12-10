class AppFormatters{

  AppFormatters._();

  static  var validEmailExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  static RegExp validPasswordExp =
  RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');


  static final RegExp validNameExp = RegExp('[a-zA-Z]');
  static final RegExp validPhoneExp = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
}