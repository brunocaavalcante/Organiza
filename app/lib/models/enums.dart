import 'package:app/models/report/report.dart';

enum Status { Pago, Pendente }

enum TipoOperacao { Nenhum, Despesa, Recibo, Emprestimo }

enum TipoFrequencia { Nunca, AnoTodo, Parcelado }

List<String> mes = [
  '',
  'Janeiro',
  'Fevereiro',
  'Março',
  'Abril',
  'Maio',
  'Junho',
  'Julho',
  'Agosto',
  'Setembro',
  'Outubro',
  'Novembro',
  'Dezembro'
];

List<String> mesesAbreviado = [
  '',
  'Jan',
  'Fev',
  'Mar',
  'Abr',
  'Mai',
  'Jun',
  'Jul',
  'Ago',
  'Set',
  'Out',
  'Nov',
  'Dez'
];
