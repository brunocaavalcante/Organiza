enum Status { Pago, Pendente, PendenteAprovacao, Recusada }

const List<String> statusDescricoes = [
  'Pago',
  'Pendente',
  'Pendente Aprovação',
  'Recusada'
];

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
