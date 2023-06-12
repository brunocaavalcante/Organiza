import 'package:flutter/material.dart';
import '../../../core/widgets/widget_ultil.dart';

class ExibirComprovanteWidget extends StatelessWidget {
  final String url;

  ExibirComprovanteWidget({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WidgetUltil.barWithArrowBackIos(
            context, "Exibir Comprovante", null),
        body: FutureBuilder<ImageProvider>(
            future: Future.value(Image.network(url).image),
            builder:
                (BuildContext context, AsyncSnapshot<ImageProvider> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Erro ao carregar a imagem'));
              } else {
                return Center(child: Image(image: snapshot.data!));
              }
            }));
  }
}
