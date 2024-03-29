import 'package:flutter/material.dart';

import 'package:duration_picker_dialog_box/duration_picker_dialog_box.dart';
import 'package:speech_balloon/speech_balloon.dart';

import 'package:gym_pal/widgets/header.dart';
import 'package:gym_pal/widgets/sidenav.dart';

class CounterWidget extends StatefulWidget {
  String _title = "Count";
  int _count = 0;

  CounterWidget({Key? key, String title = "Title", int start = 0})
      : super(key: key) {
    _title = title;
    _count = start;
  }
  @override
  State<StatefulWidget> createState() => _EditCounterWidgetState();
}

class _EditCounterWidgetState extends State<CounterWidget> {
  late int _count = widget._count;

  void _incrementCount() {
    setState(() {
      _count++;
      widget._count = _count;
    });
  }

  void _decrementCount() {
    setState(() {
      if (_count > 0) {
        _count--;
        widget._count = _count;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              fit: FlexFit.loose,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(widget._title),
                  const SizedBox(width: 30),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "${widget._count}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: IconButton(
                      onPressed: _incrementCount,
                      icon: const Icon(Icons.arrow_drop_up),
                      tooltip: "More",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: IconButton(
                      onPressed: _decrementCount,
                      icon: const Icon(Icons.arrow_drop_down),
                      tooltip: "Less",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Entry {
  final bool timed;
  final String title;
  final int sets;
  final int reps;
  final Duration duration;

  Entry({
    required this.timed,
    required this.title,
    required this.sets,
    required this.reps,
    required this.duration,
  });
}

class ViewEditWorkoutWidget extends StatefulWidget {
  late Entry lastEntry;
  ViewEditWorkoutWidget(Entry e, {Key? key}) : super(key: key) {
    lastEntry = e;
  }

  @override
  State<StatefulWidget> createState() => _ViewEditWorkoutWidgetState();
}

class _ViewEditWorkoutWidgetState extends State<ViewEditWorkoutWidget>
    with TickerProviderStateMixin {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _scrollController = ScrollController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _titleController.text = lastEntry.title;
    _tabController.index = (lastEntry.timed == true) ? 1 : 0;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  late Entry lastEntry = widget.lastEntry;

  late final int _sets = lastEntry.sets;
  late final int _reps = lastEntry.reps;

  late final CounterWidget _setsCounter =
      CounterWidget(title: "Sets: ", start: _sets);
  late final CounterWidget _repsCounter =
      CounterWidget(title: "Reps: ", start: _reps);

  late Duration _duration = lastEntry.duration;

  @override
  Widget build(BuildContext context) {
    lastEntry = widget.lastEntry;

    return Scaffold(
      appBar: header(context, isAppTitle: false, titleText: 'Add Workout'),
      drawer: Drawer(
        child: sidenav(context),
      ),
      body: DefaultTabController(
        length: 2,
        child: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.deepPurpleAccent[700],
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                  color: Colors.white,
                ),
                actions: <Widget>[
                  // Save
                  IconButton(
                    onPressed: () {
                      var k1 = _formKey1.currentState;
                      var k2 = _formKey2.currentState;
                      int index = _tabController.index;
                      if (index == 0) {
                        if (k1 != null) {
                          if (k1.validate()) {
                            final workout = Entry(
                              timed: false,
                              title: _titleController.text,
                              sets: _setsCounter._count,
                              reps: _repsCounter._count,
                              duration: const Duration(),
                            );
                            Navigator.pop(context, workout);
                          }
                        }
                      }
                      if (index == 1) {
                        if (k2 != null) {
                          if (k2.validate()) {
                            final workout = Entry(
                              timed: true,
                              title: _titleController.text,
                              sets: 0,
                              reps: 0,
                              duration: _duration,
                            );
                            Navigator.pop(context, workout);
                          }
                        }
                      }
                    },
                    icon: const Icon(Icons.check),
                    color: Colors.white,
                  ),
                ],
                bottom: TabBar(
                  controller: _tabController,
                  tabs: [
                    const Tab(text: "REPETITIVE"),
                    const Tab(text: "TIMED"),
                  ],
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: [
                  /*
                  * TAB 1
                  *
                  */
                  SingleChildScrollView(
                    controller: _scrollController,
                    child: Form(
                      key: _formKey1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                                decoration: const InputDecoration(
                                  hintText: "Title",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(),
                                  ),
                                ),
                                controller: _titleController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Title cannot be empty!";
                                  }
                                  return null;
                                }),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Customize your workout! Is it repetitive?",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Center(
                            child: Column(
                              children: <Widget>[
                                _setsCounter,
                                _repsCounter,
                                const SizedBox(
                                  height: 20,
                                ),
                                const SpeechBalloon(
                                  nipHeight: 24,
                                  borderRadius: 20,
                                  width: 400,
                                  height: 70,
                                  color: Colors.deepPurpleAccent,
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Text(
                                      "Hey pal! I'll be counting reps live\n to help you train!",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "McLaren",
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  //flex: 6,
                                  child: Image.asset(
                                      'assets/images/panda-victorious.png'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  /*
                  * TAB 2
                  *
                  */
                  SingleChildScrollView(
                    controller: _scrollController,
                    child: Form(
                      key: _formKey2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                                decoration: const InputDecoration(
                                  hintText: "Title",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(),
                                  ),
                                ),
                                controller: _titleController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Title cannot be empty!";
                                  }
                                  return null;
                                }),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Customize your workout! How much time will you exercise?",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Center(
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  width: 300,
                                  child: DurationPicker(
                                    duration: _duration,
                                    onChange: (value) {
                                      setState(() {
                                        _duration = value;
                                      });
                                    },
                                    durationPickerMode:
                                        DurationPickerMode.Minute,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const SpeechBalloon(
                                  nipHeight: 24,
                                  borderRadius: 20,
                                  width: 400,
                                  height: 70,
                                  color: Colors.deepPurpleAccent,
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Text(
                                      "Hey pal! I'll be timing you \n to help you train!",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "McLaren",
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  //flex: 6,
                                  child: Image.asset(
                                      'assets/images/panda-victorious.png'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
