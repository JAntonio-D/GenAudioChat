import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/controllers/filter_chip_controller.dart';
import 'package:test_app/screens/language_screen.dart';
import 'package:test_app/widgets/button.dart';
import 'package:test_app/widgets/category_filter_chip.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:test_app/services/controlled_generation.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  // Future<void> fetchCategories() async {
  //   print("CategoryScreen ");
  //   await getCategories();
  // }

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  // ControlledGeneration service = ControlledGeneration();

  // Future<void> fetchCategories() async {
  //   // setState(() {
  //   //   isLoading = true;
  //   //   errorMessage = '';  // Restablecer el mensaje de error
  //   // });

  //   try {
  //     await service.getCategories();
  //   } catch (e) {
  //     // errorMessage = e.toString();
  //   } finally {
  //     // setState(() {
  //     //   isLoading = false;
  //     // });
  //     print("loadeddd");
  //   }
  // }

  @override
  void initState() {
    // fetchCategories(); // Cargar categorías cuando la pantalla se inicializa
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Consumer<FilterChipController>(builder: (context, controller, _) {
      return Scaffold(
        // appBar: AppBar(
        //   title: const Text('Selecciona una categoría de tu interés'),
        // ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(AppLocalizations.of(context)!.selectCategory,
                  style: textTheme.titleLarge),
              const SizedBox(height: 5.0),
              CategoryFilterChip(),
              const SizedBox(height: 10.0),
              Text(
                'Tus temas: ${controller.selectedCategories.join(', ')}',
                style: textTheme.labelLarge,
              ),
              Button(
                  buttonText: "Next",
                  isEnabled: controller.selectedCategories.isNotEmpty,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LanguageSelectionScreen()),
                    );
                  })
            ],
          ),
        ),
      );
    });
  }
}
