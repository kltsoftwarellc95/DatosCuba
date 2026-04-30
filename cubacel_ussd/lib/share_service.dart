import 'package:share_plus/share_plus.dart';
import 'main.dart';

class ShareService {
  static Future<void> shareCode(UssdCode code) async {
    final message = '''
📱 *Cubacel USSD*

*Código:* ${code.name}
*Número:* ${code.code}
*Descripción:* ${code.description}

¡Usa esta app para acceder rápidamente!
''';

    await Share.share(message, subject: 'Código Cubacel: ${code.name}');
  }
}
