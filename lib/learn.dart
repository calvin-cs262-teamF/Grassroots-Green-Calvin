/*  learn.dart
*
* A class used to display LEARN content
*
*/
import 'package:flutter/material.dart';
import 'Hyperlink.dart';

class Learn {
  static Container getLearn(BuildContext context){
    return Container(
      child: Stack(
        children: <Widget>[
          Column(
            children:<Widget> [
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Column(
                      children: <Widget>[
                        Container(
                            height: 90,
                            width: 400,
                            color: Theme.of(context).accentColor,
                            alignment: Alignment.topCenter,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Hyperlink('https://navs-online.org/articles/veganism-animal-rights/', 'Animal Rights')
                        ),
                      ]
                  )),
              Column(
                  children: <Widget>[
                    Container(
                        height: 90,
                        width:400,
                        color: Theme.of(context).accentColor,
                        alignment: Alignment.topCenter,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Hyperlink('https://www.globalchange.gov/climate-change', 'Climate Change')),
                  ]
              ),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Column(
                      children: <Widget>[
                        Container(
                            height: 90,
                            width: 400,
                            color: Theme.of(context).accentColor,
                            alignment: Alignment.topCenter,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Hyperlink('http://eices.columbia.edu/2018/08/16/veganism-and-sustainability/', 'Sustainability')
                        ),
                      ]
                  )),
              Column(
                  children: <Widget>[
                    Container(
                        height: 90,
                        width: 400,
                        color: Theme.of(context).accentColor,
                        alignment: Alignment.topCenter,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Hyperlink('http://socialjusticestories.leadr.msu.edu/2016/03/19/human-rights-abuses-in-u-s-meat-packing-industry/', 'Workers\' Rights')
                    ),
                  ]
              ),

              Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Column(
                      children: <Widget>[
                        Container(
                            height: 90,
                            width: 400,
                            color: Theme.of(context).accentColor,
                            alignment: Alignment.topCenter,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Hyperlink('https://www.health.harvard.edu/staying-healthy/becoming-a-vegetarian','Health Benefits')
                        ),
                      ]
                  )),
            ],),
        ],),);
  }
}