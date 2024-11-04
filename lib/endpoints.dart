class Endpoints {
  // String enviaCSV = "http://localhost:8081/remoto";
  // String recebeComunicadosPaginacao(int page, int size) {
  //   return "http://localhost:8081/remoto/todos?page=$page&size=$size";
  // }

  // String recebeUmComunicado = "http://localhost:8081/remoto/token";
  // String autenticaLogin = "http://localhost:8081/auth/authenticate";
  // String validaToken = "http://localhost:8081/validateToken";

  String enviaCSV = "https://aliancadevelopers.com/sistemajuridico/remoto";
  String recebeComunicadosPaginacao(int page, int size) {
    return "https://aliancadevelopers.com/sistemajuridico/remoto/todos?page=$page&size=$size";
  }

  String recebeUmComunicado =
      "https://aliancadevelopers.com/sistemajuridico/remoto/token";
  String autenticaLogin =
      "https://aliancadevelopers.com/sistemajuridico/auth/authenticate";
  String validaToken =
      "https://aliancadevelopers.com/sistemajuridico/validateToken";
  String updateComunicado =
      "https://aliancadevelopers.com/sistemajuridico/updateAndRetry";

  // String enviaCSV =
  //     "https://production-api-dot-aliancajuridico.rj.r.appspot.com/remoto";
  // String recebeComunicadosPaginacao(int page, int size) {
  //   return "https://production-api-dot-aliancajuridico.rj.r.appspot.com/remoto/todos?page=$page&size=$size";
  // }

  // String recebeUmComunicado =
  //     "https://production-api-dot-aliancajuridico.rj.r.appspot.com/remoto/token";
  // String autenticaLogin =
  //     "https://production-api-dot-aliancajuridico.rj.r.appspot.com/auth/authenticate";
  // String validaToken =
  //     "https://production-api-dot-aliancajuridico.rj.r.appspot.com/validateToken";
}
