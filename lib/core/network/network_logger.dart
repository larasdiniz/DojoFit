import 'dart:developer' as developer;

import 'package:pop_network/pop_network.dart';

class NetworkLogger extends PopNetworkLogInterceptor {
  NetworkLogger()
    : super(
        logPrint: (objeto) {
          developer.log(objeto.toString(), name: 'DOJOFIT_NETWORK');
        },
      );
}
