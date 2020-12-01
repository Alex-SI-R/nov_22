import 'package:aeyrium_sensor/aeyrium_sensor.dart';
import 'package:flutter/material.dart';

import 'package:all_sensors/all_sensors.dart';
import 'package:flutter/services.dart';

main() => runApp(TEP());

class TEP extends StatefulWidget {
  @override
  createState() => Estado();
}

class Estado extends State<TEP> {
  double escala = 1;
  double movp, movr, boundm, boudM;
  double ux,uy,uz;
  double px,py;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    accelerometerEvents.listen((event) {
      Future.delayed(const Duration(milliseconds: 50), () {
        setState(() {
          ux=event.x.roundToDouble();
          uy=event.z.roundToDouble();
          if(uy>=0){
            py=300-(uy*30);
          }else{
            py=300-(uy*20);
          }
          px=ux*15;
          px=-px;
        });
      });
    });
    accelerometerEvents.listen((event) {
      Future.delayed(const Duration(milliseconds: 50), () {
        setState(() {


        });
      });
    });






    AeyriumSensor.sensorEvents.listen((event) {
      boundm = 1;
      boudM = 91;
      movp = event.pitch *
          57.2958; //Aqui convertimos a grados el pitch que nos servira para la escala
      movp = movp +
          91; //Aqui sumamos 91 grados para generar la ecuación de nuestra recta de la cual depende la escala
      // La ecuación es escala=0.022222222222222223*movp+0.47777777777777786
      movr = event.roll * -57.2958;
      movr=movr.roundToDouble();
      //Aqui convertimos a grados
      /*Future.delayed(const Duration(seconds: 2), () {
        print(
            "Pitch ${movp.toStringAsFixed(2)} and Roll ${movr.toStringAsFixed(2)} and Scale ${escala.toStringAsFixed(2)}");
      });
       */
      setState(() {
        if (movp > boundm && movp < boudM) {
          escala = 0.022222222222222223 * movp + 0.47777777777777786;
        } else {
          escala = escala;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Stack(
        //fit: StackFit.expand,
        children: [
          Transform.rotate(
            angle: 3.141592,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: AssetImage("images/chido.gif"),
              )),
            ),
          ),
          Transform.translate(
            offset: Offset(px, py),
            child: Transform.scale(
              scale: escala,
              child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                image: AssetImage("images/navep.png"),
              ))),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Transform.scale(
              scale: 1,
              child: Card(
                  color:Colors.blueAccent,
                      child: Text("Valor de roll= ${movr}")),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Transform.scale(
              scale: 1,
              child: Card(
                  color:Colors.blueAccent,
                  child: Text("Valor de roll= ${movr}")),
            ),
          ),
        ],
        overflow: Overflow.clip,
      )));
}
