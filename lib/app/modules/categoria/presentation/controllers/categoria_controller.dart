import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:organiza2/app/core/models/custom_exception.dart';
import 'package:organiza2/app/core/services/alert_service.dart';
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
    carregarCategorias(null);
  }

  Future<void> carregarCategorias(BuildContext? context) async {
    try {
      isLoading.value = true;
      categorias.value = await _buscarUseCase.call();
    } on CustomException catch (e) {
      if (context != null) {
        AlertService.alertErro(context, e.message);
      }
    } catch (e) {
      if (context != null) {
        AlertService.alertErro(
            context, 'Erro inesperado ao carregar categorias');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> salvarCategoria(
      BuildContext context, Categoria categoria) async {
    try {
      isLoading.value = true;
      await _salvarUseCase.call(categoria);

      await carregarCategorias(context);
      await AlertService.alertaSucesso(
        context,
        'Categoria salva com sucesso',
      );
      await Future.delayed(const Duration(milliseconds: 300));
      Modular.to.pushNamed('/categoria/select');
    } on CustomException catch (e) {
      await AlertService.alertErro(context, e.message);
    } catch (e) {
      await AlertService.alertErro(
          context, 'Erro inesperado ao salvar categoria');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> excluirCategoria(BuildContext context, String id) async {
    try {
      isLoading.value = true;
      await _excluirUseCase.call(id);

      // Remover da lista local
      categorias.removeWhere((cat) => cat.id == id);

      await AlertService.alertaSucesso(
          context, 'Categoria excluída com sucesso');
    } on CustomException catch (e) {
      await AlertService.alertErro(context, e.message);
    } catch (e) {
      await AlertService.alertErro(
          context, 'Erro inesperado ao excluir categoria');
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
