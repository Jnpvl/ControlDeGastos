import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money/layout/homeLayout.dart';
import 'package:money/services/categoria_provider.dart';
import 'package:money/services/movimiento_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await  MobileAds.instance.initialize();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CategoriaProvider()),
        ChangeNotifierProvider(create: (context) => MovimientoProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ahorrar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.merriweatherSansTextTheme(),
      ),
      home: HomeLayout(),
    );
  }
}
