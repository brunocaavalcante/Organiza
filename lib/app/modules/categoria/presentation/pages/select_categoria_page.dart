import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:organiza2/app/core/widgets/widget_ultil.dart';
import '../../domain/entities/categoria.dart';
import '../controllers/categoria_controller.dart';
import 'cadastro_categoria_page.dart';

class SelectCategoriaPage extends StatelessWidget {
  const SelectCategoriaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CategoriaController>();

    return Scaffold(
      appBar: WidgetUltil.barWithArrowBackIos(context, "Categorias", null),
      body: Obx(() {
        if (controller.isLoading.value && controller.categorias.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return _buildBody(context, controller);
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CadastroCategoriaPage(),
            ),
          );
        },
        tooltip: 'Add Categoria',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context, CategoriaController controller) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      height: MediaQuery.of(context).size.height,
      margin: const EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.82,
            child: Obx(() => _buildList(context, controller)),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, CategoriaController controller) {
    if (controller.categorias.isEmpty) {
      return const Center(
        child: Text('Nenhuma categoria encontrada'),
      );
    }

    return ListView.builder(
      itemCount: controller.categorias.length,
      itemBuilder: (context, index) {
        final categoria = controller.categorias[index];
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: WidgetUltil.returnDimissibleExcluir(
            _buildCard(context, categoria),
            _dismissExcluir(controller, categoria.id),
          ),
        );
      },
    );
  }

  Widget _buildCard(BuildContext context, Categoria categoria) {
    return Card(
      shadowColor: Theme.of(context).colorScheme.primary,
      elevation: 5,
      surfaceTintColor: Theme.of(context).colorScheme.background,
      child: ListTile(
        onTap: () {
          Navigator.pop(context, categoria);
        },
        contentPadding: const EdgeInsets.all(10),
        leading: Container(
          width: 50,
          height: 50,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Icon(
            IconData(categoria.icon, fontFamily: categoria.fontFamily),
            size: 35,
            color: Color(categoria.color),
          ),
        ),
        title: Text(
          categoria.descricao,
          textAlign: TextAlign.start,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Function(DismissDirection)? _dismissExcluir(
    CategoriaController controller,
    String id,
  ) {
    return (_) async {
      await controller.excluirCategoria(id);
    };
  }
}