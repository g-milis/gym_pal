import 'package:flutter/material.dart';

import 'package:gym_pal/widgets/header.dart';
import 'package:gym_pal/widgets/sidenav.dart';
import 'package:gym_pal/widgets/bottom.dart';
import 'package:gym_pal/widgets/timer.dart';
import 'package:gym_pal/views/workouts/workouts.dart';

bool volumeClick = true;
bool isRunning = false;

class TimedSession extends StatefulWidget {
  late Workout wk;
  TimedSession(Workout w,{Key? key}) : super(key: key){ this.wk = w;}
  @override
  _TimedSession createState() => _TimedSession();
}


class _TimedSession extends State<TimedSession> {
  late Duration d = Duration();
  late String ?title;
  late CountdownPage tmr;
  @override
  Widget build(BuildContext context) {
    if(widget.wk.duration != null) d= widget.wk.duration!;
    title = widget.wk.title;
    tmr = new CountdownPage(d);
    return Scaffold(
      appBar: header(context, isAppTitle: false, titleText: '${title} Session'),
      drawer: Drawer(
      child: sidenav(context),
      ),
      body: Center(
        child: Column(
          children:<Widget>[
            SizedBox(
              height:20, 
              width : 20,
              child: tmr,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:<Widget>[
                SizedBox(
                  width: 200,
                  child:Image.asset('assets/images/panda1-250.png'),
                ),
                SizedBox( 
                  child: IconButton(
                    icon: Icon((volumeClick == false)?(Icons.volume_up): Icons.volume_off),

                    onPressed: (){
                      setState(() {
                        volumeClick = ! volumeClick;
                      });
                    },

                  ),)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:<Widget>[
              SizedBox(
              width: 120,
               child: TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent[700]),
                ),
                onPressed: () { tmr.a.reset(); },
                child: Text('RESET'),
                ),
                ),
                SizedBox(
              width: 120,
               child: TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent[700]),
                ),
                onPressed: () {
                  setState(() {
                        isRunning = ! isRunning;
                      });
                  if (isRunning == true) tmr.a.startTimer();
                  else tmr.a.stopTimer();
                },
                child: Text(isRunning == true?'PAUSE':'PLAY'),
                ),
                ),
                SizedBox(
              width: 120,
               child: TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent[700]),
                ),
                onPressed: () { Navigator.of(context).pop; },
                child: Text('STOP'),
                ),
                ),
              ],
            ),
          ],
        ),
      ),
        bottomNavigationBar: bottom(context)
      );
  }
}
