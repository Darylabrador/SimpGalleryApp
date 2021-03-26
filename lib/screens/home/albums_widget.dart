import 'package:flutter/material.dart';

class AlbumsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('[Products Widget] build()');
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.all(15.0),
          child: Text(
            'Albums',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: SizedBox(
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Image.asset('assets/sample-01.jpg'),
                      Container(
                        padding: EdgeInsets.only(
                          left: 20,
                        ),
                        alignment: Alignment.topLeft,
                        child: Text('album 1'),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: 20,
                        ),
                        alignment: Alignment.topLeft,
                        child: Text('nb photo'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Image.asset('assets/sample-02.jpg'),
                      Container(
                        padding: EdgeInsets.only(
                          left: 20,
                        ),
                        alignment: Alignment.topLeft,
                        child: Text(
                          'album 1',
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: 20,
                        ),
                        alignment: Alignment.topLeft,
                        child: Text('nb photo'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
