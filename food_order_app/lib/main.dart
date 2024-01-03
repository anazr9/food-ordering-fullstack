import 'package:flutter/material.dart';
import 'package:food_order_app/composition_root.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CompositionRoot.configure();
  final screenToShow = await CompositionRoot.start();
  runApp(MyApp(screenToShow));
}

class MyApp extends StatelessWidget {
  final Widget startPage;
  const MyApp(this.startPage, {super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Space',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 251, 176, 59)),
        useMaterial3: true,
      ),
      home: startPage,
    );
  }
}
