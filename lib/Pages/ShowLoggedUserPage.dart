import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heiserver_connector/Implementation/FollowUser.dart';
import 'package:heiserver_connector/Implementation/User.dart';
import 'package:heiserver_connector/Structure/TagClass.dart';
import 'package:heiserver_connector/Structure/UserClass.dart';
import 'package:heiserver_connector/Utility/LocalLoginData.dart';
import 'package:hey_flutter/Widget/AccountImage.dart';
import 'package:hey_flutter/Widget/BordedButton.dart';
import 'package:hey_flutter/Widget/GetListEvent.dart';
import 'package:hey_flutter/Widget/MyBehavior.dart';
import 'package:hey_flutter/Widget/StatusBarCleaner.dart';
import 'package:hey_flutter/UtilityClass/UtilityTools.dart';
import 'package:intl/intl.dart';
import '../Widget/DinoAppBar.dart';
import '../Widget/Theme.dart';

class ShowLoggedUserPage extends StatefulWidget{

  @override
  ShowLoggedUserPageState createState() => ShowLoggedUserPageState();
}

class ShowLoggedUserPageState extends State<ShowLoggedUserPage> {

  var buildcontext;

  @override
  Widget build(BuildContext context) {
    return StatusBarCleaner(
      color: MoobTheme.darkBackgroundColor,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(MoobTheme.radius),
          topRight: const Radius.circular(MoobTheme.radius),
        ),
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: FutureBuilder<UserClass>(
            future: LocalLoginData.getAllLoggedUserData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return getUserPage(snapshot.data);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // Di default mostra un CircularProgressIndicator
              return Padding(
                padding: const EdgeInsets.only(top:48.0),
                child: Center(child:Container(child:CircularProgressIndicator(),)),
              );
            },
          ),
    ),
      )
    );
  }

  getUserPage(UserClass user){
    return CustomScrollView(
      slivers: [
      // Richiamo l'AppBar che presenta un pulsante per tornare indietro e uno per le impostazioni
        BackSetting_Appbar_LoggedUser(color:MoobTheme.darkBackgroundColor,),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              ProfileImageAndLittleMore(user),
              SocialNumberBar(user),
              DettailOfUser(user),
              CreatedEvent(user)
              ]
          )
        )
      ]
    );
  }
}

ProfileImageAndLittleMore(UserClass user){
  return Container(
    color: Colors.transparent,
    height:120+2*MoobTheme.paddingHorizontal,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: MoobTheme.paddingHorizontal,vertical: MoobTheme.paddingHorizontal),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1/1,
            child: AccountImage(photo: user.photo,),
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: MoobTheme.paddingHorizontal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Flexible(flex:1,child: Container(),),
                  AutoSizeText("${user.name} ${user.surname}", style: TextStyle(color: Colors.white, fontSize: 24), maxLines: 1,),
                  Text("@${user.username}", style: TextStyle(fontSize: 15,color: Colors.white),),
                  Flexible(flex:4,child: Container(),),
                  Center(
                    child: BordedButton(
                      strokeWidth: 2,
                      radius: 24,
                      child: Text("Modifica profilo",style: TextStyle(color: Colors.white,fontSize: 14),),
                      gradient: MoobTheme.primaryGradient,
                      onPressed: (){},
                    )
                  ),
                  Flexible(flex:1,child: Container(),),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

SocialNumberBar(UserClass user) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 45.0,),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          width: 100,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder(
                  future: User().getCreatedEventNumber(user.username),
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      return Text(snapshot.data.toString(),style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),);
                    }else{
                      return Center(child:Container(child:CircularProgressIndicator(),));
                    }
                  },
                )
              ),
              Text("Eventi",style: TextStyle(color: Colors.white, fontSize: 14), )
            ],
          ),
        ),
        Container(
          width: 100,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder(
                  future: FollowUser().getFollowingNumber(user.username),
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      return Text(snapshot.data.toString(),style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),);
                    }else{
                      return Center(child:Container(child:CircularProgressIndicator(),));
                    }
                  },
                )
              ),
              Text("Segui",style: TextStyle(color: Colors.white, fontSize: 14), )
            ],
          ),
        ),
        Container(
          width: 100,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder(
                  future: FollowUser().getFollowerNumber(user.username),
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      return Text(snapshot.data.toString(),style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),);
                    }else{
                      return Center(child:Container(child:CircularProgressIndicator(),));
                    }
                  },
                )
              ),
              Text("Ti Seguono",style: TextStyle(color: Colors.white, fontSize: 14), )
            ],
          ),
        ),
      ],
    ),
  );
}

Widget getTagCips(List<Tag> tags){
  List<Widget> tagcips = [];
  for (Tag elmnt in tags){
    tagcips.add(
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(MoobTheme.radius))
            ),
            child: Text(elmnt.tag, style: TextStyle(fontWeight: FontWeight.bold, color: MoobTheme.middleBackgroundColor),),
          ),
        )
    );
  }
  return Padding(
    padding: const EdgeInsets.only(top: MoobTheme.paddingHorizontal),
    child: Row(children: tagcips),
  );
}

DettailOfUser(UserClass user) {
  var birthDate;
  try{
    birthDate = new DateFormat("dd/MM/yyyy").parse(user.birth);
  }
  catch(e){
    birthDate = new DateFormat("dd/MM/yyyy").parse("1/1/1901");
  }

  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(MoobTheme.radius),topRight: Radius.circular(MoobTheme.radius),),
      border: Border.all(color: MoobTheme.middleBackgroundColor,width: 0),
      color: MoobTheme.middleBackgroundColor,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top:MoobTheme.paddingHorizontal*2,left: MoobTheme.paddingHorizontal),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.calendar_today, color: Colors.white, size: 26,),
              Container(
                width: MoobTheme.paddingHorizontal,
              ),
              Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("${birthDate.day} ${UtilityTools.MonthNumberToLongString(birthDate.month)} ${birthDate.year}", style: TextStyle(color: Colors.white,fontSize: 16),),
                    Text("Data di Nascita", style: TextStyle(color: Colors.white,fontSize: 10),),
                  ],
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top:MoobTheme.paddingHorizontal,left: MoobTheme.paddingHorizontal),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.place, color: Colors.white, size: 26,),
              Container(
                width: MoobTheme.paddingHorizontal,
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("${user.place}", style: TextStyle(color: Colors.white,fontSize: 16),),
                  Text("Località", style: TextStyle(color: Colors.white,fontSize: 10),),
                ],
              ),
            ],
          ),
        ),
//        Padding(
//          padding: const EdgeInsets.only(top:MoobTheme.paddingHorizontal,left: MoobTheme.paddingHorizontal*2),
//          child: Row(
//            mainAxisSize: MainAxisSize.max,
//            crossAxisAlignment: CrossAxisAlignment.center,
//            children: <Widget>[
//              Flexible(
//                flex: 1,
//                child:Icon(Icons.star, color: Colors.white, size: 26,),
//              ),
//              Container(
//                width: MoobTheme.paddingHorizontal,
//              ),
//              Flexible(
//                flex: 3,
//                child: Column(
//                  mainAxisSize: MainAxisSize.max,
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                  children: <Widget>[
//                    Text(tagString, style: TextStyle(color: Colors.white,fontSize: 16),),
//                    Text("Preferenze", style: TextStyle(color: Colors.white,fontSize: 10),),
//                  ],
//                ),
//              )
//            ],
//          ),
//        ),
        user.preference.length!=0?Padding(
          padding: const EdgeInsets.only(left: MoobTheme.paddingHorizontal),
          child: getTagCips(user.preference),
        ):Container(),
        user.bio!=null?Padding(
          padding: const EdgeInsets.only(top: MoobTheme.paddingHorizontal*2, left: MoobTheme.paddingHorizontal, right: MoobTheme.paddingHorizontal),
          child: Text("Biografia", style: TextStyle(fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold)),
        ):Container(),
        user.bio!=null?Padding(
          padding: const EdgeInsets.only(top: 8.0, left: MoobTheme.paddingHorizontal, right: MoobTheme.paddingHorizontal),
          child: Text(user.bio,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.6)),
              textAlign: TextAlign.justify
          ),
        ):Container(),
      ],
    ),
  );
}

CreatedEvent(UserClass user){
  return Container(
    color: MoobTheme.middleBackgroundColor,
    alignment: Alignment.topCenter,
    padding: EdgeInsets.symmetric(vertical: MoobTheme.paddingHorizontal*2, horizontal: MoobTheme.paddingHorizontal),
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<Widget>(
            future: GetListEvent().user(user.username),
            builder: (context, snapshot){
              if (snapshot.hasData){
                return snapshot.data;
              }else{
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
      ]
    )
  );
}
