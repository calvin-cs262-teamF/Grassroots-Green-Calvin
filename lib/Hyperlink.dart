/*  Hyperlink.dart
*
* A class used to allow URL's to be opened from the Grassroots Green Application
*
*/
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

//This class allows for text to become a hyperlink
//It was taken from https://dev.to/guimg/hyperlink-widget-on-flutter-4fa5

class Hyperlink extends StatelessWidget {
  final String _url;
  final String _text;

  Hyperlink(this._url, this._text);

  _launchURL() async {
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Text(
        _text,
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      onTap: _launchURL,
    );
  }
}