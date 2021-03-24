import 'package:flutter/material.dart';

class AlbumsWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    print('[Products Widget] build()');
    return Column(
          children: <Widget>[
            Text('Albums'),
            Row(
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FittedBox(
                        fit: BoxFit.fill, // otherwise the logo will be tiny
                        child: Image.asset('assets/sample-01.jpg'),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FittedBox(
                        fit: BoxFit.fill, // otherwise the logo will be tiny
                        child: Image.asset('assets/sample-02.jpg'),
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