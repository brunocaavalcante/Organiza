import 'package:app/models/report/report.dart';
import 'package:app/pages/reports/filter_report_page.dart';
import 'package:app/pages/reports/reports_generate_page.dart';
import 'package:app/services/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/report/tipo_report.dart';

class HomeReportPage extends StatefulWidget {
  const HomeReportPage({super.key});

  @override
  State<HomeReportPage> createState() => _HomeReportPageState();
}

class _HomeReportPageState extends State<HomeReportPage> {
  UserService? auth;
  int month = DateTime.now().month;
  List<Report> list = [];
  bool selected = false;

  @override
  void initState() {
    inicializaListaReports();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<UserService>(context);

    return Scaffold(body: ListView(children: [body()]));
  }

  inicializaListaReports() {
    List<TipoReport> tipoReports = [
      TipoReport(1, "Pizza", Icons.pie_chart, ""),
      TipoReport(2, "Barras", Icons.bar_chart, ""),
      TipoReport(3, "Linhas", Icons.line_axis, "")
    ];
    var reportsCategoria = Report(1, "Relatórios por Categorias", tipoReports);
    var reportsDespesa =
        Report(2, "Relatórios Depesas X Receitas", tipoReports);
    var reportsOperacao = Report(3, "Relatórios por Operações", tipoReports);

    list.add(reportsCategoria);
    list.add(reportsDespesa);
    list.add(reportsOperacao);
  }

  body() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          list[index].isExpanded = !isExpanded;
        });
      },
      children: list.map<ExpansionPanel>((Report item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              selectedColor: Theme.of(context).colorScheme.primary,
              selected: isExpanded,
              title: Text(item.name ?? "",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20)),
            );
          },
          body: Column(children: [
            for (var i = 0; i < item.tipoReports!.length; i++)
              ListTile(
                  leading: Icon(item.tipoReports![i].icon),
                  title: Text(item.tipoReports![i].name),
                  trailing: const Icon(Icons.download),
                  onTap: () {
                    item.tipo = item.tipoReports![i];
                    if (item.id == 3) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => FilterReportPage())));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) =>
                                  ReportGeneratePage(report: item))));
                    }
                  })
          ]),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}
