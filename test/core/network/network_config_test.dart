import 'package:dojofit/core/network/network_config.dart';
import 'package:dojofit/core/network/network_logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pop_network/pop_network.dart';

void main() {
  group('NetworkConfig', () {
    test(
      'Deve criar uma instância de IApiManager com as configurações de interceptores corretamente',
      () {
        // ARRANGE
        const urlBaseTeste = 'https://api.api-ninjas.com';

        // ACT
        final apiManager = NetworkConfig.create(baseUrl: urlBaseTeste);

        // ASSERT
        expect(apiManager, isA<IApiManager>());
        final possuiLogger = apiManager.interceptors.any(
          (i) => i is NetworkLogger,
        );

        expect(
          possuiLogger,
          isTrue,
          reason:
              'O NetworkLogger deve ser injetado durante a criação do ApiManager',
        );
      },
    );
  });
}
