import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'share_service.dart';

void main() {
  runApp(const CubaCelApp());
}

class CubaCelApp extends StatelessWidget {
  const CubaCelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cubacel USSD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class UssdCode {
  final String name;
  final String code;
  final String description;
  final IconData icon;
  final Color? color;

  UssdCode({
    required this.name,
    required this.code,
    required this.description,
    required this.icon,
    this.color,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchQuery = '';
  
  final List<UssdCode> ussdCodes = [
    UssdCode(
      name: 'Saldo Principal',
      code: '*222#',
      description: 'Consulta tu saldo principal',
      icon: Icons.attach_money,
      color: Colors.green,
    ),
    UssdCode(
      name: 'Saldo Bonus',
      code: '*222*266#',
      description: 'Consulta tu saldo bonus',
      icon: Icons.card_giftcard,
      color: Colors.orange,
    ),
    UssdCode(
      name: 'Paquete Datos',
      code: '*99#',
      description: 'Contratar paquetes de datos',
      icon: Icons.wifi,
      color: Colors.blue,
    ),
    UssdCode(
      name: 'Paquete Voz',
      code: '*123#',
      description: 'Contratar paquetes de voz',
      icon: Icons.phone_in_talk,
      color: Colors.purple,
    ),
    UssdCode(
      name: 'Paquete SMS',
      code: '*124#',
      description: 'Contratar paquetes de SMS',
      icon: Icons.message,
      color: Colors.teal,
    ),
    UssdCode(
      name: 'Transferir Saldo',
      code: '*234#',
      description: 'Transferir saldo a otro número',
      icon: Icons.swap_horiz,
      color: Colors.indigo,
    ),
    UssdCode(
      name: 'Mi Número',
      code: '*222*328#',
      description: 'Conocer mi propio número',
      icon: Icons.person_outline,
      color: Colors.pink,
    ),
    UssdCode(
      name: 'Última Recarga',
      code: '*222*732#',
      description: 'Consultar última recarga',
      icon: Icons.receipt_long,
      color: Colors.brown,
    ),
    UssdCode(
      name: 'Plan Amigos',
      code: '*111#',
      description: 'Gestionar plan amigos',
      icon: Icons.people_outline,
      color: Colors.cyan,
    ),
    UssdCode(
      name: 'Buzón de Voz',
      code: '*999#',
      description: 'Acceder al buzón de voz',
      icon: Icons.mail_outline,
      color: Colors.red,
    ),
    UssdCode(
      name: 'Datos Internacionales',
      code: '*99*7#',
      description: 'Paquetes de datos para roaming',
      icon: Icons.language,
      color: Colors.deepPurple,
    ),
    UssdCode(
      name: 'Activar Roaming',
      code: '*222*762#',
      description: 'Activar servicio de roaming',
      icon: Icons.flight_takeoff,
      color: Colors.amber,
    ),
  ];

  List<UssdCode> get filteredCodes {
    if (_searchQuery.isEmpty) {
      return ussdCodes;
    }
    return ussdCodes.where((code) {
      return code.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          code.code.contains(_searchQuery) ||
          code.description.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  Future<void> _launchUSSD(String code) async {
    final Uri uri = Uri(scheme: 'tel', path: code);
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Text('Abriendo marcador con $code'),
              ],
            ),
            backgroundColor: Colors.green.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Copia el código: $code'),
            backgroundColor: Colors.orange.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  void _shareCode(UssdCode code) {
    ShareService.shareCode(code);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.share, color: Colors.white),
            const SizedBox(width: 12),
            Text('${code.name} compartido'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cubacel USSD'),
        backgroundColor: colorScheme.inversePrimary,
        foregroundColor: colorScheme.onInverseSurface,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(),
            tooltip: 'Información',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBar(
              hintText: 'Buscar código USSD...',
              prefixIcon: const Icon(Icons.search),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              controller: TextEditingController(text: _searchQuery),
            ),
          ),
          Expanded(
            child: filteredCodes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No se encontraron códigos',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredCodes.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      final code = filteredCodes[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: (code.color ?? colorScheme.primary).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              code.icon,
                              color: code.color ?? colorScheme.primary,
                              size: 28,
                            ),
                          ),
                          title: Text(
                            code.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(code.description),
                                Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.secondaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    code.code,
                                    style: TextStyle(
                                      fontFamily: 'monospace',
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSecondaryContainer,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'call') {
                                _launchUSSD(code.code);
                              } else if (value == 'share') {
                                _shareCode(code);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'call',
                                child: Row(
                                  children: [
                                    Icon(Icons.phone, size: 20),
                                    SizedBox(width: 8),
                                    Text('Marcar'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'share',
                                child: Row(
                                  children: [
                                    Icon(Icons.share, size: 20),
                                    SizedBox(width: 8),
                                    Text('Compartir'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          onTap: () => _launchUSSD(code.code),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Desliza hacia arriba para ver más códigos'),
              backgroundColor: colorScheme.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
        icon: const Icon(Icons.touch_app),
        label: const Text('Toque un código'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.apps_outage),
            label: 'Códigos',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            label: 'Favoritos',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: 'Ajustes',
          ),
        ],
        onDestinationSelected: (index) {
          if (index != 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Próximamente: ${index == 1 ? "Favoritos" : "Ajustes"}'),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info, color: Colors.blue),
            SizedBox(width: 8),
            Text('Información'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Esta aplicación te permite acceder rápidamente a los códigos USSD de Cubacel.'),
            SizedBox(height: 16),
            Text('• Toca un código para abrir el marcador'),
            Text('• Usa el buscador para encontrar códigos específicos'),
            Text('• Algunos códigos requieren saldo o estar en red Cubacel'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}
