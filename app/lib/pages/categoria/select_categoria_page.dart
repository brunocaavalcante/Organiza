import 'package:app/pages/categoria/cadastro_categoria_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/widget_ultil.dart';
import '../../models/categoria.dart';
import '../../models/custom_exception.dart';
import '../../services/categoria_service.dart';
import '../../services/usuario_service.dart';

class SelectCategoriaPage extends StatefulWidget {
  const SelectCategoriaPage({super.key});

  @override
  State<SelectCategoriaPage> createState() => _SelectCategoriaPageState();
}

class _SelectCategoriaPageState extends State<SelectCategoriaPage> {
  List<Categoria> categorias = [];
  UserService? auth;

  @override
  void initState() {
    super.initState();
    carregarDados().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<UserService>(context);
    return Scaffold(
        appBar: WidgetUltil.barWithArrowBackIos(context, "Categorias", null),
        body: containerMenu(),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              var item = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CadastroCategoriaPage()));
              setState(() {
                categorias.add(item);
              });
            },
            tooltip: 'Add Categoria',
            child: const Icon(Icons.add)));
  }

  containerMenu() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height,
        margin: const EdgeInsets.only(left: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.82,
            child: itemHistorico(),
          )
        ]));
  }

  itemHistorico() {
    return ListView.builder(
        itemCount: categorias.length,
        itemBuilder: (context, index) {
          var item = categorias[index];
          return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: WidgetUltil.returnDimissibleExcluir(
                  cardItem(item), dismissExcluirItem(item)));
        });
  }

  Future<void> carregarDados() async {
    await carregaCategoriasGerais();
    await carregaCategoriaUsuario();
  }

  Future<void> carregaCategoriaUsuario() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categorias-user')
        .doc(auth!.auth.currentUser!.uid)
        .collection("categorias")
        .orderBy('descricao')
        .get();

    List<Categoria> categoriasCollection1 = querySnapshot.docs.map((document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      var item = Categoria().toEntity(data);
      item.id = document.id;
      return item;
    }).toList();

    categorias.addAll(categoriasCollection1);
  }

  Future<void> carregaCategoriasGerais() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categorias')
        .orderBy('descricao')
        .get();

    List<Categoria> categoriasCollection2 = querySnapshot.docs.map((document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      var item = Categoria().toEntity(data);
      item.id = document.id;
      return item;
    }).toList();

    categorias.addAll(categoriasCollection2);
  }

  cardItem(Categoria item) {
    return Card(
        shadowColor: Theme.of(context).colorScheme.primary,
        elevation: 5,
        surfaceTintColor: Theme.of(context).colorScheme.background,
        child: ListTile(
            onTap: () async {
              Navigator.pop(context, item);
            },
            contentPadding: const EdgeInsets.all(10),
            leading: Container(
                width: 50,
                height: 50,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Icon(
                  IconData(item.icon ?? 984979,
                      fontFamily: item.fontFamily ?? "MaterialIcons"),
                  size: 35,
                  color: Color(item.color),
                )),
            title: Text(item.descricao.toString(),
                textAlign: TextAlign.start,
                style: const TextStyle(fontSize: 20))));
  }

  Function(DismissDirection)? dismissExcluirItem(Categoria item) {
    return (_) async {
      try {
        await Provider.of<CategoriaService>(context, listen: false)
            .excluir(item.id);
      } on CustomException catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    };
  }
}
