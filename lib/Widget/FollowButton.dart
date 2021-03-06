import 'package:flutter/material.dart';
import 'package:heiserver_connector/Implementation/FollowEvent.dart';
import 'package:hey_flutter/Widget/GenerateToast.dart';

class FollowButton extends StatefulWidget{
  final int event_id;

  const FollowButton({Key key,
    @required this.event_id,
  });

  @override
  FollowButtonState createState() => FollowButtonState();
}

class FollowButtonState extends State<FollowButton>{
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FollowEvent().isfollower(widget.event_id),
        builder: (context, snapshot){
          if (snapshot.hasData){
            return SizedBox(
              width: 48,
              height: 48,
              child: RawMaterialButton(
                onPressed: () async {
                  if (snapshot.data)
                    FollowEvent().unfollow(widget.event_id).then((value){
                      if (value==0)
                        GenerateToast("Hai smesso di seguire questo evento");
                      else
                        GenerateToast("Qualcosa è andato storto \n Riprova più tardi");
                      setState(() {});
                    });
                  else
                    FollowEvent().follow(widget.event_id).then((value){
                      if (value==0)
                        GenerateToast("Hai iniziato a seguire questo evento");
                      else
                        GenerateToast("Qualcosa è andato storto \n Riprova più tardi");
                      setState(() {});
                    });

                },
                fillColor: Colors.grey,
                child: snapshot.data?Icon(
                  Icons.star,
                  size: 24.0,
                  color: Colors.white,
                ):Icon(
                  Icons.star_border,
                  size: 24.0,
                  color: Colors.white,
                ),
                shape: CircleBorder(),
              ),
            );
          }else{
            return SizedBox(
              width: 48,
              height: 48,
              child: RawMaterialButton(
                onPressed: () async {
                  await FollowEvent().isfollower(widget.event_id);
                },
                fillColor: Colors.grey,
                shape: CircleBorder(),
              ),
            );
          }
        }
    );
  }
}