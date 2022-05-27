import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmp/src/providers/push_notification_provider.dart';
import 'package:gmp/src/screens/detalle_contratos/detallecontratos.dart';
import 'package:gmp/src/screens/detalle_proyectos/detalleproyectos.dart';
import 'package:gmp/src/screens/notificaciones/shimmer.dart';
import 'package:gmp/src/settings/constantes.dart';
import 'package:gmp/src/settings/size_config.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class NotificacionesPage extends StatefulWidget {
  NotificacionesPage({Key key}) : super(key: key);

  @override
  _NotificacionesPageState createState() => _NotificacionesPageState();
}

class _NotificacionesPageState extends State<NotificacionesPage> {
  SharedPreferences spreferences;
  bool notificaciones = false;
  List notificacionesLista;
  List notificacionesListaNoLeidas;
  bool cargando = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig _sc = SizeConfig();
    return Container(
      child: Scaffold(
          body:cargando == false? DefaultTabController(
          length: 2,
          child: Column(
            children: <Widget>[
              Container(
                constraints: BoxConstraints.expand(height: 50, width: 250),
                child: TabBar(tabs: [
                  Tab(text: "Todas ("+notificacionesLista.length.toString()+")"),
                  Tab(text: "No leídas("+notificacionesListaNoLeidas.length.toString()+")"),
                ],
                labelColor: kazul,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 30),
                  child: TabBarView(children: [
                    Container(
                      child: ListView.builder(
                        //physics: const NeverScrollableScrollPhysics(),
                        itemCount: notificacionesLista == null ? 0 : notificacionesLista.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: notificacionesLista[index]['estado'] == 1? Color.fromARGB(255, 96, 161, 221): Color.fromARGB(255, 199, 214, 228),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: defaultpadding,
                                          backgroundImage: NetworkImage(notificacionesLista[index]['imagen'] ==
                                                  "noimage"
                                              ? '$URL_SERVER/images/foto/${notificacionesLista[index]['imagen']}.png'
                                              : '$URL_SERVER/images/foto/${notificacionesLista[index]['imagen']}'),
                                        ),
                                        SizedBox(width: _sc.getProportionateScreenWidth(10)),        
                                        Expanded(
                                          child: Text(notificacionesLista[index]['mensaje']+"en el "+(notificacionesLista[index]['tipo_respuesta_comentario'] == 1? "proyecto" : "contrato")+", "+ notificacionesLista[index]['detalle'][0]["nombre"], maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 14, fontWeight: notificacionesLista[index]['estado'] == 1? FontWeight.bold: FontWeight.normal)
                                          ),
                                        ),
                                      ]
                                    ),
                                    SizedBox(height: 5),
                                    Container(
                                      padding: EdgeInsets.only(right: 5),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          Text(calcularFechas(notificacionesLista[index]['fecha'])+"A las ", style: TextStyle(fontStyle: FontStyle.italic)),
                                          Text(notificacionesLista[index]['hora'], style: TextStyle(fontStyle: FontStyle.italic))
                                        ],
                                      ),
                                    )
                                    
                                  ],
                                ) 
                              ) 
                            ),
                            onTap: (){
                              if(notificacionesLista[index]['tipo_respuesta_comentario'] == 1){
                                verProyecto(notificacionesLista[index]['detalle'][0]['id_proyect'], notificacionesLista[index]['bd'], notificacionesLista[index]['id']);
                              }else{
                                verContrato(notificacionesLista[index]['detalle'][0]['id_contrato'].toString(), notificacionesLista[index]['bd'], notificacionesLista[index]['id']);
                              }
                            },
                          ); 
                        }
                      )
                    ),
                    Container(
                      child: ListView.builder(
                        itemCount: notificacionesListaNoLeidas == null ? 0 : notificacionesListaNoLeidas.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            child:  Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: notificacionesListaNoLeidas[index]['estado'] == 1? Color.fromARGB(255, 96, 161, 221): Color.fromARGB(255, 199, 214, 228),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: defaultpadding,
                                          backgroundImage: NetworkImage(notificacionesListaNoLeidas[index]['imagen'] ==
                                                  "noimage"
                                              ? '$URL_SERVER/images/foto/${notificacionesListaNoLeidas[index]['imagen']}.png'
                                              : '$URL_SERVER/images/foto/${notificacionesListaNoLeidas[index]['imagen']}'),
                                        ),
                                        SizedBox(width: _sc.getProportionateScreenWidth(10)),        
                                        Expanded(
                                          child: Text(notificacionesListaNoLeidas[index]['mensaje']+"en el "+(notificacionesListaNoLeidas[index]['tipo_respuesta_comentario'] == 1? "proyecto" : "contrato")+", "+ notificacionesLista[index]['detalle'][0]["nombre"], maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 14, fontWeight: notificacionesListaNoLeidas[index]['estado'] == 1? FontWeight.bold: FontWeight.normal)
                                          ),
                                        ),
                                      ]
                                    ),
                                    SizedBox(height: 5),
                                    Container(
                                      padding: EdgeInsets.only(right: 5),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          Text(calcularFechas(notificacionesListaNoLeidas[index]['fecha'])+"A las ", style: TextStyle(fontStyle: FontStyle.italic)),
                                          Text(notificacionesListaNoLeidas[index]['hora'], style: TextStyle(fontStyle: FontStyle.italic))
                                        ],
                                      ),
                                    )
                                    
                                  ],
                                ) 
                              ) 
                            ),
                            onTap: (){
                              if(notificacionesLista[index]['tipo_respuesta_comentario'] == 1){
                                verProyecto(notificacionesLista[index]['detalle'][0]['id_proyect'], notificacionesLista[index]['bd'], notificacionesListaNoLeidas[index]['id']);
                              }else{
                                verContrato(notificacionesLista[index]['detalle'][0]['id_contrato'].toString(), notificacionesLista[index]['bd'], notificacionesListaNoLeidas[index]['id']);
                              }
                            },
                          );
                        }
                      )
                    ),
                  ]),
                ),
              )
            ],
          ),
        ): ShimmerList()
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    final pushProvidern = new PushNotificationProvider();
    pushProvidern.initNotificaciones();
    pushProvidern.mensajes.listen((event) {
      MotionToast(
        color: Colors.orange,
        description: event,
        icon: Icons.message,
      ).show(this.context);

      consultarNotificaciones();
    });
    iniciar();
    notificacionesLista = [];
    notificacionesListaNoLeidas = [];
    consultarNotificaciones();
  }

  calcularFechas(var fecha){
    DateTime fecha1 =  DateTime.parse(fecha);
    DateTime fecha2 =  DateTime.now();

    Duration _diastotales = fecha2.difference(fecha1);
    
    if(_diastotales.inDays == 0){
      return "Hoy ";
    }else{
      if (_diastotales.inDays == 1) {
        return "Ayer ";
      }else{
        return "Hace "+_diastotales.inDays.toString()+" dias ";
      }
    }
  }

  iniciar() async {
    spreferences = await SharedPreferences.getInstance();
    final pushProvider = new PushNotificationProvider();
    notificaciones = spreferences.getBool("notificaciones");
    if (notificaciones) {
      pushProvider.initNotificaciones();
      pushProvider.getToken();
    }
  }

  consultarNotificaciones() async {
    setState(() {
      cargando = true;
    });
    spreferences = await SharedPreferences.getInstance();
    var idUsu = int.parse(spreferences.getString("id"));
    
    var response = await http.get(
      Uri.parse('${URL_SERVER}notificaciones?id_usu=${idUsu}'),
      headers: {"Accept": "application/json"});

    var reponsebody = json.decode(response.body);
    var nt = reponsebody['notificaciones'];
    var ntl = await filtrarLeidas(nt);

    setState(() {
      notificacionesLista = nt;
      notificacionesListaNoLeidas = ntl;
      cargando = false;
    });
   
  }

  filtrarLeidas(List lista) async {
    var listaf = [];
    for (var item in lista) {
      if(item["estado"] == 1){
        listaf.add(item);
      }
    }
    return listaf;
  }

  verProyecto(int idP, String bd, int idNot) async {
    await cambiarEstado(idNot);
    spreferences = await SharedPreferences.getInstance();
    spreferences.setString("bd",bd);
    spreferences.setString("empresa", bd.split("_")[1]);
     Navigator.push(
      this.context,
      CupertinoPageRoute(
          builder: (context) => DetalleProyetcosPage(idproyect: idP.toString())),
    );
  }

  verContrato(String idCon,  String bd, int idNot) async {
    await cambiarEstado(idNot);
    spreferences = await SharedPreferences.getInstance();
    spreferences.setString("bd",bd);
    spreferences.setString("empresa", bd.split("_")[1]);
    Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => DetalleContratosPage(id_con: idCon)),
    );
  }

  cambiarEstado(int idNot) async {
    var res = await http.get(Uri.parse('${URL_SERVER}cambiar-estado-notificacion?id_not=${idNot}'),headers: {"Accept": "application/json"});
    print(res);
    setState(() {
      consultarNotificaciones();
    });
  }
}