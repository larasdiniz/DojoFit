import 'package:flutter/services.dart';
import 'package:pop_network/pop_network.dart';

import 'network_logger.dart';

class NetworkConfig {
  static IApiManager create({required String baseUrl, bool isMock = false}) {
    return ApiManager(
      baseUrl: baseUrl,
      // Necessário para que o mockReplyParams funcione buscando arquivos nos assets
      loadMockAsset: isMock ? rootBundle.loadString : null,
      interceptors: [
        NetworkLogger(), // Nosso interceptor de log personalizado
      ],
    );
  }
}
