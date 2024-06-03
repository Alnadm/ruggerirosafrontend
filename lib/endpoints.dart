class Endpoints {
  String enviaCSV = "http://localhost:8081/remoto";
  String recebeComunicadosPaginacao(int page, int size) {
    return "http://localhost:8081/remoto/todos?page=$page&size=$size";
  }

  String recebeUmComunicado = "http://localhost:8081/remoto/token";
  String autenticaLogin = "http://localhost:8081/auth/authenticate";
  String validaToken = "http://localhost:8081/validateToken";

  // String enviaCSV = "http://34.132.194.110:80/remoto";
  // String recebeComunicadosPaginacao(int page, int size) {
  //   return "http://34.132.194.110:80/remoto/todos?page=$page&size=$size";
  // }

  // String recebeUmComunicado = "http://34.132.194.110:80/remoto/token";
  // String autenticaLogin = "http://34.132.194.110:80/auth/authenticate";
  // String validaToken = "http://34.132.194.110:80/validateToken";

  // String enviaCSV = "https://aliancajuridico.rj.r.appspot.com/remoto";
  // String recebeComunicadosPaginacao(int page, int size) {
  //   return "https://aliancajuridico.rj.r.appspot.com/remoto/todos?page=$page&size=$size";
  // }

  // String recebeUmComunicado =
  //     "https://aliancajuridico.rj.r.appspot.com/remoto/token";
  // String autenticaLogin =
  //     "https://aliancajuridico.rj.r.appspot.com/auth/authenticate";
  // String validaToken = "https://aliancajuridico.rj.r.appspot.com/validateToken";
}
