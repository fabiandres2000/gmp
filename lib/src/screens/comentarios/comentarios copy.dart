/*import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:gmp/src/settings/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'componentes/vistacomentarios.dart';

class ComentariosPage extends StatefulWidget {
  final idproyect;
  ComentariosPage({Key key, this.idproyect}) : super(key: key);

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
  int iscomentando=0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Size size = MediaQuery.of(context).size;
    SizeConfig _sc = SizeConfig();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF737373),
      ),
      /*bottomSheet: Container(
        width: double.infinity,
        decoration:
            BoxDecoration(border: Border(top: BorderSide(color: Colors.grey))),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: size.height * 0.05,
                  width: size.width * 0.8,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[300]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextFormField(
                      //controller: txtenviar,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Escribe tu comentario aquí'),
                    ),
                  )),
            ),
            isloading == 0
                ? GestureDetector(
                    onTap: () {
                      enviarcomentario();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: size.height * 0.04,
                        width: size.width * 0.1,
                        decoration: BoxDecoration(),
                        child: Icon(Icons.send, color: Colors.grey),
                      ),
                    ),
                  )
                : CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[900]),
                    strokeWidth: 2,
                  ),
          ],
        ),
      ),*/
      body: Stack(
        children: <Widget>[
          Container(
            color: Color(0xFF737373),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultpadding, vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      height: size.height * 0.007,
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[400]),
                      child: Padding(
                        padding: const EdgeInsets.only(top: defaultpadding),
                      ),
                    ),
                    SizedBox(
                      height: _sc.getProportionateScreenHeight(10),
                    ),
                    Expanded(
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
                                tipo: "proyecto");
                          }),
                    ),
                    SizedBox(
                      height: _sc.getProportionateScreenHeight(0),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      height: 500,
                      child: Container(
                          width: double.infinity,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(color: Colors.grey),),),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                        //width: size.width * 0.78,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.grey[300]),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: TextFormField(
                                            controller: txtenviar,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText:
                                                    'Escribe tu comentario aquí'),
                                          ),
                                        ),
                                      ),
                                  ),
                                  isloading == 0
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
                                              width: size.width * 0.1,
                                              decoration: BoxDecoration(),
                                              child: Icon(Icons.send,
                                                  color: Colors.blue[700]),
                                            ),
                                          ),
                                        )
                                      : CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.blue[900]),
                                          strokeWidth: 2,
                                        ),
                                ],
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    instanciar_sesion();
  }

  Future<String> listarcomentarios() async {
    //print(widget.idproyect);
    var response = await http.get(
        Uri.encodeFull(
            '${URL_SERVER}comentarios_proyectos?bd=${bd}&id_con=${widget.idproyect}'),
        headers: {"Accept": "application/json"});

    final reponsebody = json.decode(response.body);

    this.setState(() {
      comentarios = reponsebody['comentarios'];
      isloading = 0;
      //valur = (int.parse(reponsebody['rating']["total"]) / int.parse(reponsebody['rating']["todos"]));
    });
    return "Success!";
  }

  Future<String> enviarcomentario() async {
    //print('${URL_SERVER}comentario_proyectos/guardar?bd=${bd}&id_con=${widget.idproyect}&id_usu=${id_user}&response=0&comentario=${txtenviar.text}');
    var response = await http.get(
        Uri.encodeFull(
            '${URL_SERVER}comentario_proyectos/guardar?bd=${bd}&id_con=${widget.idproyect}&id_usu=${id_user}&response=0&comentario=${txtenviar.text}'),
        headers: {"Accept": "application/json"});
        txtenviar.text="";

this.setState(() {
      isloading = 0;
      //valur = (int.parse(reponsebody['rating']["total"]) / int.parse(reponsebody['rating']["todos"]));
    });
    //print('${URL_SERVER}comentario_proyectos?bd=${bd}&id_con=${widget.idproyect}&id_usu=${id_user}&response=0&comentario=${txtenviar.text}');
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
}*/
