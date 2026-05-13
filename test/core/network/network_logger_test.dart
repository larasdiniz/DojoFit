import 'package:dojofit/core/network/network_logger.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NetworkLogger', () {
    test(
      'Deve inicializar o NetworkLogger e executar o logPrint sem erros',
      () {
        // Arrange
        final logger = NetworkLogger();
        const mensagemDeTeste = 'Teste de Log de Rede';

        // Act & Assert
        // Como o logger usa developer.log (que não retorna valor),
        // validamos que a chamada da função interna não dispara exceções.
        expect(() => logger.logPrint(mensagemDeTeste), returnsNormally);
      },
    );
  });
}
