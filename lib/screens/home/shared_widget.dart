import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

class SharedWidget extends StatelessWidget {
  final arrayData;
  SharedWidget({this.arrayData});

  @override
  Widget build(BuildContext context) {
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
        Container(
          height: 200,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(8),
              itemCount: arrayData.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                    child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/photos');
                  },
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Image.network(
                            "${DotEnv.env['DATABASE_URL']}/img/" +
                                arrayData[index]['cover'],
                            height: 150,
                            width: 150,
                            fit: BoxFit.fill),
                        Text(
                          arrayData[index]["label"],
                        ),
                      ],
                    ),
                  ),
                ));
              }),
        )
      ],
    );
  }
}
