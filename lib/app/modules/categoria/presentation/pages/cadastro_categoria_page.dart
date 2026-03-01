import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:organiza2/app/core/widgets/widget_ultil.dart';
import '../../domain/entities/categoria.dart';
import '../widgets/select_icon_page.dart';
import '../../../usuario/presentation/widgets/select_color_page.dart';
import '../controllers/categoria_controller.dart';

class CadastroCategoriaPage extends StatefulWidget {
  const CadastroCategoriaPage({super.key});

  @override
  State<CadastroCategoriaPage> createState() => _CadastroCategoriaPageState();
}

class _CadastroCategoriaPageState extends State<CadastroCategoriaPage> {
  final formKey = GlobalKey<FormState>();
  final descricaoController = TextEditingController();
  late final CategoriaController controller;

  @override
  void initState() {
    super.initState();
    controller = Modular.get<CategoriaController>();
    
    // Resetar seleções
    controller.setIcon(Icons.home);
    controller.setColor(Colors.amber);
  }

  @override
  void dispose() {
    descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUltil.barWithArrowBackIos(
          context, "Cadastro Categoria", true),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.07),
          padding: const EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WidgetUltil.returnField(
                  "Descrição: ",
                  descricaoController,
                  TextInputType.text,
                  null,
                  "",
                  false,
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório';
                    }
                    if (value.length < 3) {
                      return 'Mínimo 3 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                _buildIconColorSelector(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconColorSelector() {
    double altura = MediaQuery.of(context).size.height * 0.1;
    
    return Obx(() {
      final icon = controller.selectedIcon.value;
      final color = controller.selectedColor.value;

      return Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text("Cor", style: TextStyle(fontSize: 30)),
              Text("Ícone", style: TextStyle(fontSize: 30)),
            ],
          ),
          const SizedBox(height: 20),
          
          // Seletores
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () async {
                  final selectedColor = await Navigator.push<Color>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SelectColorPage(),
                    ),
                  );
                  if (selectedColor != null) {
                    controller.setColor(selectedColor);
                  }
                },
                child: Container(
                  width: 85,
                  height: 85,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    color: color,
                  ),
                ),
              ),
              
              IconButton(
                icon: Icon(icon),
                iconSize: 100,
                onPressed: () async {
                  final selectedIcon = await Navigator.push<IconData>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SelectIconPage(),
                    ),
                  );
                  if (selectedIcon != null) {
                    controller.setIcon(selectedIcon);
                  }
                },
              ),
            ],
          ),
          SizedBox(height: altura),
          
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Card(
              shadowColor: Theme.of(context).colorScheme.primary,
              elevation: 5,
              surfaceTintColor: Theme.of(context).colorScheme.background,
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: Container(
                  width: 60,
                  height: 60,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Icon(icon, size: 55, color: color),
                ),
                title: Text(
                  descricaoController.text.isEmpty
                      ? 'Preview'
                      : descricaoController.text,
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontSize: 30),
                ),
              ),
            ),
          ),
          SizedBox(height: altura),
          
          // Botão Salvar
          WidgetUltil.returnButtonSalvar(_onSalvar()),
        ],
      );
    });
  }

  Function()? _onSalvar() {
    return () async {
      if (formKey.currentState!.validate()) {
        final categoria = Categoria(
          id: '',
          descricao: descricaoController.text,
          color: controller.selectedColor.value.value,
          icon: controller.selectedIcon.value.codePoint,
          fontFamily: 'MaterialIcons',
        );

        await controller.salvarCategoria(context, categoria);
      }
    };
  }
}