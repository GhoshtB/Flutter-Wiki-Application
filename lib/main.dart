import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app_wiki/db/db_helper.dart';
import 'package:flutter_app_wiki/model/search_results.dart';

import 'bloc/repos_bloc.dart';
import 'connection/my_connectivity.dart';
import 'repos/Repository.dart';
import 'util/constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePages(),
    );
  }
}

class MyHomePages extends StatefulWidget {
  @override
  State createState() {
    return MyHomePageStates();
  }
}

class MyHomePageStates extends State<MyHomePages> {
  SearchResults values;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DBHelper dbHelper;
  ConnectivityResult connectivityResult;
  Map _source = {ConnectivityResult.mobile: false};
  MyConnectivity _connectivity = MyConnectivity.instance;
  var isConnection=false;

  @override
  Widget build(BuildContext context) {
    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.none:
        isConnection=true;
        break;
      case ConnectivityResult.mobile:
        isConnection=false;
        break;
      case ConnectivityResult.wifi:
        isConnection=false;
    }
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[200],
        body: Padding(
          padding: EdgeInsets.all(7),
          child: Material(
            elevation: 2,
            color: Colors.white,
            shadowColor: Colors.grey[200],
            child: Column(
              children: <Widget>[
                Container(
                  height: 50,
                  margin: EdgeInsets.only(top: 30, left: 10, right: 10),
                  child: TextFormField(
                    cursorColor: Colors.grey,
                    onChanged: (value) async {
                      if (value.length > 2) {
                        bloc.getReposData(value);
                      }
                    },
                    style: new TextStyle(color: Colors.black, fontSize: 14),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Search ',
                        hintStyle: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1)),
                        enabledBorder: OutlineInputBorder(
//              borderRadius: BorderRadius.circular(borderRadius),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1))),
                  ),
                ),
                Flexible(
                  flex: 4,
                  child: StreamBuilder(
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Pages>> snapshot) {
                      if (isConnection) {
                        SchedulerBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text(
                            "Internet Connection Not Available",
                            style: TextStyle(color: Colors.red, fontSize: 18),
                          )));
                        });
                      }
                      if (snapshot.hasData) {
                        saveData(snapshot.data);
                        return ListView.builder(
                          itemBuilder: (_, index) => Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
//        side: BorderSide(color: Colors.red)
                            ),
                            child: ListTile(
                              leading: snapshot
                                          .data[index]?.thumbnail?.source !=
                                      null
                                  ? Image.network(
                                      snapshot.data[index].thumbnail?.source)
                                  : CircleAvatar(
                                      radius: 30,
                                      child: Icon(
                                        Icons.search_off_sharp,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                      backgroundColor: Colors.amber[300],
                                    ),
                              title: Padding(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  snapshot.data[index].title ?? "",
                                  style: titlestyle,
                                ),
                              ),
                              subtitle: Padding(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  snapshot.data[index].terms?.description ==
                                          null
                                      ? ""
                                      : snapshot
                                          .data[index].terms.description[0],
                                  style: othertyle,
                                ),
                              ),
                              trailing: Padding(
                                padding: EdgeInsets.all(5),
                                child: Icon(Icons.arrow_forward_ios),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ResultDetailPage(
                                            snapshot.data[index])));
                              },
                            ),
                          ),
                          itemCount: snapshot.data.length,
                        );
                      }
                      /*else if(snapshot.hasError){
                        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Internet Connection Not Available",style: TextStyle(color: Colors.red,fontSize: 18),)));
                      }*/
                      else {
                        if (connectivityResult == ConnectivityResult.none) {
                          return Center(
                            child: Column(
                              children: [
                                Text("Internet Connection Not Available",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 18)),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: CircularProgressIndicator(),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }
                    },
                    stream: bloc.repoSubject.stream,
                  ),
                )
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _connectivity.disposeStream();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    Future.delayed(Duration(seconds: 3), () {
      bloc.getDataFromDb();
    });
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });
    checkConn();
  }

  void saveData(List<Pages> data) {
    Future.delayed(Duration(seconds: 3), () {
// data.map((e) => dbHelper.save(e));
      for (int i = 0; i < data.length; i++) {
        dbHelper.save(data[i]);
      }
    });
  }

  void checkConn() async {
    connectivityResult = await new Connectivity().checkConnectivity();
  }
}

class ResultDetailPage extends StatefulWidget {
  Pages pages;

  ResultDetailPage(this.pages);

  @override
  State createState() {
    return ResultDetailPageState();
  }
}

class ResultDetailPageState extends State<ResultDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.pages?.title ?? "",
          style: TextStyle(
              fontSize: 21, color: Colors.white, fontFamily: "Castoro"),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: widget.pages?.thumbnail?.source != null
                      ? Image.network(widget.pages.thumbnail?.source,fit: BoxFit.cover,)
                      : CircleAvatar(
                          radius: 80,
                          child: Icon(
                            Icons
                                .signal_cellular_connected_no_internet_4_bar_sharp,
                            color: Colors.redAccent,
                            size: 25,
                          ),
                          backgroundColor: Colors.amber[300],
                        ),
                ),
                flex: 2,
              ),
              Flexible(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      widget.pages.terms?.description == null
                          ? ""
                          : widget.pages?.terms?.description[0],
                      style: othertyle,
                    ),
                  ),
                ),
                flex: 4,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
