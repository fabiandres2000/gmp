import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gmp/src/screens/notificaciones/shimmer_item.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:gmp/src/settings/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'componentes/vistacomentarios.dart';

class ComentariosPage extends StatefulWidget {
  final idproyect;
  final valortop;
  final valorbottom;
  ComentariosPage({Key key, this.idproyect, this.valortop, this.valorbottom})
      : super(key: key);

  @override
  _ComentariosPageState createState() => _ComentariosPageState();
}

TextEditingController txtenviar = new TextEditingController();

class _ComentariosPageState extends State<ComentariosPage> {
  SharedPreferences spreferences;
  String bd;
  String empresa;
  String id_user;
  List comentarios;
  //String txtenviar;
  int isloading = 0;
  int iscomentando = 0;

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Size size = MediaQuery.of(context).size;
    SizeConfig _sc = SizeConfig();
    return Scaffold(
      body:Container(
        height: size.height - widget.valortop,
        margin: EdgeInsets.only(top: 50),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: size.height * 0.007,
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[400]),
                      child: Padding(
                        padding: const EdgeInsets.only(top: defaultpadding),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: _sc.getProportionateScreenHeight(10),
                ),
                loading == false? Expanded(
                  child: ListView.builder(
                    //physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        comentarios == null ? 0 : comentarios.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return VistaComentario(
                        comentarios: comentarios,
                        sc: _sc,
                        size: size,
                        index: index,
                        mres: "si",
                        tam: 0.75,
                        tipo: "proyecto",
                        idProyecto: widget.idproyect
                      );
                    }),
                ): ShimmerItem(),
                SizedBox(
                  height: _sc.getProportionateScreenHeight(15),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              width: size.width,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border()
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            controller: txtenviar,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Escribe tu comentario aquí'),
                          ),
                        ),
                      ),
                      Container(
                        width: size.width * 0.15,
                        child: isloading == 0
                            ? GestureDetector(
                                onTap: () {
                                  this.setState(() {
                                    isloading = 1;
                                  });
                                  enviarcomentario();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(),
                                    child:
                                        Icon(Icons.send, color: Colors.blue[700]),
                                  ),
                                ),
                              )
                            : Center(
                              child: CircularProgressIndicator(
                                
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blue[900]),
                                  strokeWidth: 3,
                                  
                                ),
                            ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );
  }

  @override
  void initState() {
    super.initState();
    instanciar_sesion();
  }

  Future<String> listarcomentarios() async {
    setState(() {
      loading = true;
    });
    var response = await http.get(
        Uri.parse(
            '${URL_SERVER}comentarios_proyectos?bd=${bd}&id_con=${widget.idproyect}'),
        headers: {"Accept": "application/json"});

    final reponsebody = json.decode(response.body);

    this.setState(() {
      comentarios = reponsebody['comentarios'];
      isloading = 0;
      loading = false;
    });
    return "Success!";
  }

  Future<String> enviarcomentario() async {
    var response = await http.get(
        Uri.parse(
            '${URL_SERVER}comentario_proyectos/guardar?bd=${bd}&id_con=${widget.idproyect}&id_usu=${id_user}&response=0&comentario=${txtenviar.text}'),
        headers: {"Accept": "application/json"});
    txtenviar.text = "";

    this.setState(() {
      isloading = 0;
    });
    listarcomentarios();

    return "Success!";
  }

  instanciar_sesion() async {
    spreferences = await SharedPreferences.getInstance();
    bd = spreferences.getString("bd");
    empresa = spreferences.getString("empresa");
    id_user = spreferences.getString("id");
    listarcomentarios();
  }
}
