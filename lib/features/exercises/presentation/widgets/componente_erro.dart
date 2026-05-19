import 'package:flutter/material.dart';
import '../../../../core/utils/app_strings.dart';

class ComponenteErro extends StatelessWidget {
  final String mensagem;
  final VoidCallback onRetry;

  const ComponenteErro({
    super.key,
    required this.mensagem,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(mensagem, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: Text(AppStrings.tentarNovamente.texto),
            ),
          ],
        ),
      ),
    );
  }
}
