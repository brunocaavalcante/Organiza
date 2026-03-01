import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:organiza2/app/core/models/custom_exception.dart';
import '../../domain/entities/categoria.dart';
import '../../domain/usecases/buscar_categorias_usecase.dart';
import '../../domain/usecases/excluir_categoria_usecase.dart';
import '../../domain/usecases/salvar_categoria_usecase.dart';

class CategoriaController extends GetxController {
  final SalvarCategoriaUseCase _salvarUseCase;
  final ExcluirCategoriaUseCase _excluirUseCase;
  final BuscarCategoriasUseCase _buscarUseCase;

  CategoriaController(
    this._salvarUseCase,
    this._excluirUseCase,
    this._buscarUseCase,
  );

  // Estado reativo
  final categorias = <Categoria>[].obs;
  final isLoading = false.obs;
  final selectedIcon = Rx<IconData>(Icons.home);
  final selectedColor = Rx<Color>(Colors.amber);

  @override
  void onInit() {
    super.onInit();
    carregarCategorias();
  }

  Future<void> carregarCategorias() async {
    try {
      isLoading.value = true;
      categorias.value = await _buscarUseCase.call();
    } on CustomException catch (e) {
      Get.snackbar(
        'Erro',
        e.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro inesperado ao carregar categorias',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> salvarCategoria(Categoria categoria) async {
    try {
      isLoading.value = true;
      await _salvarUseCase.call(categoria);

      await carregarCategorias();
      Modular.to.pushNamed('/categoria/select');
      Get.snackbar(
        'Sucesso',
        'Categoria salva com sucesso',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on CustomException catch (e) {
      Get.snackbar(
        'Erro',
        e.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro inesperado ao salvar categoria',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> excluirCategoria(String id) async {
    try {
      isLoading.value = true;
      await _excluirUseCase.call(id);

      // Remover da lista local
      categorias.removeWhere((cat) => cat.id == id);

      Get.snackbar(
        'Sucesso',
        'Categoria excluída com sucesso',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on CustomException catch (e) {
      Get.snackbar(
        'Erro',
        e.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro inesperado ao excluir categoria',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void setIcon(IconData icon) {
    selectedIcon.value = icon;
  }

  void setColor(Color color) {
    selectedColor.value = color;
  }
}
