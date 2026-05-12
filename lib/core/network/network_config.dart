import 'package:flutter/services.dart';
import 'package:pop_network/pop_network.dart';
import 'network_logger.dart';

class NetworkConfig {
  static IApiManager create({required String baseUrl}) {
    return ApiManager(
      baseUrl: baseUrl,
      // Necessário para que o mockReplyParams funcione buscando arquivos nos assets
      loadMockAsset: rootBundle.loadString,
      interceptors: [
        NetworkLogger(), // Nosso interceptor de log personalizado
      ],
    );
  }
}
