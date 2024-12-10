



import 'package:connectivity_plus/connectivity_plus.dart';

class InternetConnection{

  static Future<bool> isConnected() async{

    var connectivityResult = await Connectivity().checkConnectivity();

    var isConnected =  false;

    switch(connectivityResult){

      case ConnectivityResult.mobile :
      case  ConnectivityResult.wifi :
        isConnected = true;
        break;
      default:
        isConnected =   false;
    }
    return isConnected;
  }
}