class Endpoints {
  String enviaCSV = "http://localhost:8081/remoto";
  String recebeComunicadosPaginacao(int page, int size) {
    return "http://localhost:8081/remoto/todos?page=$page&size=$size";
  }

  String recebeUmComunicado = "http://localhost:8081/remoto/token";

  //   String enviaCSV = "https://aliancajuridico.rj.r.appspot.com/remoto";
  // String recebeComunicadosPaginacao(int page, int size) {
  //   return "https://aliancajuridico.rj.r.appspot.com/remoto/todos?page=$page&size=$size";
  // }

  // String recebeUmComunicado = "https://aliancajuridico.rj.r.appspot.com/remoto/token";
}
