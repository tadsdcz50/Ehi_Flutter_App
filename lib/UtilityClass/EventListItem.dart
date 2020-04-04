import 'package:flutter/material.dart';
import 'package:hey_flutter/Widget/Theme.dart';
import 'package:hey_flutter/UtilityClass/UtilityTools.dart';

import 'EventClass.dart';


class EventListItem extends StatelessWidget{
  final EventClass event;

  const EventListItem({Key key, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //TODO: Route to EventPage
        //showFlushbar(context:context,title:"TODO",message:"Aggiungere route a EventPage",icon:Icons.code,color: Colors.green);
      },
      child: AspectRatio(
        aspectRatio: 2.5/1,
        child: Container(
          decoration: BoxDecoration(
            color: MoobTheme.lightBackgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(MoobTheme.radius)),
            image: DecorationImage(image: NetworkImage(event.photo),fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.9), BlendMode.dstATop),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(MoobTheme.radius)),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.9)]),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(MoobTheme.radius),
                    child: InkWell(
                      onTap: (){},
                      child: ListView.builder(
                        // This next line does the trick.
                        scrollDirection: Axis.horizontal,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: event.tags.length,
                        itemBuilder: (context,index){
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                                child: Icon(UtilityTools.TagToIcons(event.tags[index]),color: Colors.white,size: 24,)),
                          );
                        },
                      )
                      ,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(MoobTheme.radius),
                    child: InkWell(
                      onTap: (){},
                      child: Icon(Icons.star_border,color: Colors.white,size: 24,),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(MoobTheme.radius),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(Icons.place,color: Colors.white, size: 10,),
                            Padding(padding: const EdgeInsets.only(right: 3),),
                            Text(event.place,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.white),),
                          ],
                        ),
                        Text(event.name,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),),
                        Text(
                          "${event.date.day} ${UtilityTools.MonthNumberToLongString(event.date.month)}  -  ${event.date.hour}:${event.date.minute.toString().padLeft(2, '0')}",
                          style: TextStyle(color: MoobTheme.mainColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}