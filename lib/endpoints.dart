class Endpoints {
  String enviaCSV = "https://aliancajuridico.rj.r.appspot.com/remoto";
  String recebeComunicadosPaginacao(int page, int size) {
    return "https://aliancajuridico.rj.r.appspot.com/remoto/todos?page=$page&size=$size";
  }

  String recebeUmComunicado =
      "https://aliancajuridico.rj.r.appspot.com/remoto/token";
}
