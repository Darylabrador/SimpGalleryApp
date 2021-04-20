import 'package:flutter/material.dart';

class ShareSettings extends StatelessWidget {
  ShareSettings({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

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
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute<void>(
                    builder: (BuildContext context) {
                      return Scaffold(
                        appBar: AppBar(
                          title: const Text('Next page'),
                        ),
                        body: const Center(
                          child: Text(
                            'This is the next page',
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      );
                    },
                  ));
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          title: const Text('SimpGalleryApp'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add_alert),
              tooltip: 'Show Snackbar',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('This is a snackbar')));
              },
            ),
            IconButton(
              icon: const Icon(Icons.navigate_next),
              tooltip: 'Go to the next page',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return Scaffold(
                      appBar: AppBar(
                        title: const Text('Next page'),
                      ),
                      body: const Center(
                        child: Text(
                          'This is the next page',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    );
                  },
                ));
              },
            ),
          ],
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Partagé avec moi', style: TextStyle(height: 3.0, fontSize: 15.2, fontWeight: FontWeight.bold,)),


    Expanded(child:Container(
      child:ListView.builder(

          itemCount: 4,
          itemBuilder: (context, index) {
            return Card(
              clipBehavior: Clip.antiAlias,
              child: Container(
                height: 120,
                padding: const EdgeInsets.all(0),
                child: Row(children: [
                  Expanded(
                    flex: 6,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/sample-01.jpg'),
                          fit: BoxFit.fill)),
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                Expanded(
                flex: 14,
                child: Container(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[ElevatedButton(
                    onPressed: null,
                    child: Text("Rejoindre",
                      style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5),)
                ),
                  SizedBox(width: 200),
                  ElevatedButton(
                      onPressed: null,
                      child: Text("Quitter",
                        style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5),)
                  ),


                ],
                ),
                ),
                ),
                ]),
              ),
            );
          }),
        ),
      ),
    ]),
    );
  }
}