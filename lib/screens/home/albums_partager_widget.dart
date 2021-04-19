import 'package:flutter/material.dart';

class AlbumsPartagerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('[Products Widget] build()');
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.all(15.0),
          child: Text(
            'Partager avec moi',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: SizedBox(
                  child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/shared');
                },
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Image.asset('assets/sample-01.jpg',
                          height: 150, width: 150, fit: BoxFit.fill),
                      Text(
                        'album 1',
                      ),
                    ],
                  ),
                ),
              )),
            ),
            Expanded(
              child: SizedBox(
                  child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/shared');
                },
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Image.asset('assets/sample-02.jpg',
                          height: 150, width: 150, fit: BoxFit.fill),
                      Text(
                        'album 1',
                      ),
                    ],
                  ),
                ),
              )),
            ),
          ],
        )
      ],
    );
  }
}
