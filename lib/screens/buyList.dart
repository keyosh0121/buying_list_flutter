import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tokyo_stroll/services/auth.dart';
import 'package:tokyo_stroll/services/auth.dart';
import 'package:tokyo_stroll/models/buyListItem.dart';
import 'package:tokyo_stroll/services/database.dart';
import 'package:tokyo_stroll/models/user.dart';
import 'package:provider/provider.dart';
import 'package:overlay_support/overlay_support.dart';


class BuyList extends StatefulWidget {
  @override
  _BuyListState createState() => _BuyListState();
}

class _BuyListState extends State<BuyList> {

  final AuthService _auth = AuthService();
  List<BuyListItem> buyList = [];

  @override

  formatNumberToCurrency(price){
    return NumberFormat.currency().format(price);
  }
  updateBuyList(String name, int amount, String uid) async{
    if (uid != null) {
      await DatabaseService(uid).updateBuyList(name, amount);
      print('updated document');
    }
  }
  

  Future<List> createListAddDialog(BuildContext context){

    TextEditingController nameInputController = TextEditingController();
    TextEditingController amountInputController = TextEditingController();

    return showDialog(context: context, builder: (context){
      return AlertDialog(
        backgroundColor: Colors.grey[100],
        elevation:10.0,
        title: Text("買い物リストに追加"),
        content: 
          Container(
            height: 150.0,
            child: Column(
              children:[
                Container(
                  padding: EdgeInsets.all(4.0),
                  child: TextField(
                    controller: nameInputController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      icon: Icon(Icons.search),
                      labelText: "名称",
                      isDense: true,
                      labelStyle: TextStyle(fontSize: 12.0),
                      // border: OutlineInputBorder(
                      //     borderRadius: BorderRadius.zero,
                      //     borderSide: BorderSide(width:0.1)
                      //   ) 
                      ),
                    ),
                  ),
                Container(
                  padding: EdgeInsets.all(4.0),
                  child: TextField(
                    controller: amountInputController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      icon: Icon(Icons.attach_money),
                      labelText: "金額",
                      isDense: true,
                      labelStyle: TextStyle(fontSize: 12.0),
                      // border: OutlineInputBorder(
                      //     borderSide: BorderSide(width:1.0)
                      //   ) 
                      ),
                    )
                )
              ]
            )
          ),
        actions: <Widget>[
          MaterialButton(
            child: Text("キャンセル"),
            onPressed: (){Navigator.of(context).pop();},
          ),
          RaisedButton(
            elevation: 5.0,
            color: Colors.green,
            textColor: Colors.white,
            child: Text("完了"),
            onPressed: (){
              Navigator.of(context).pop([nameInputController.text.toString(),amountInputController.text.toString()]);
            },
          )
        ],
        
      );
    });
  }

  String formatPrice({int price}){
    return NumberFormat.currency(locale: 'ja_JP',symbol: "¥").format(price).toString();
  }

  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    setState(() {
      dynamic list = Provider.of<List<BuyListItem>>(context);
      if(list != null) { //Providerで
        buyList = list;
      }
      
    });
    
    

    return OverlaySupport(
      child: Scaffold(
        appBar: AppBar(
          title: Text("買い物リスト"),
          backgroundColor: Colors.black87,
          actions: <Widget>[
            FlatButton.icon(
              
              icon: Icon(Icons.supervised_user_circle,color: Colors.white), 
              label: Text("ログアウト",style: TextStyle(color: Colors.white)),
              onPressed: () async {
                await _auth.signOut();
              }, 
            )
          ],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,  
          decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: FractionalOffset.topLeft,
                        end: FractionalOffset.bottomRight,
                        colors: [
                          const Color(0xffe4a972).withOpacity(0.8),
                          const Color(0xff9941d8).withOpacity(0.8),
                        ],
                        stops: const [
                          0.0,
                          1.0,
                        ],
                      ),
                    ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: buyList.length,
                  itemBuilder: (context, i){
                    return Dismissible(
                      key: ValueKey(buyList[i].documentId),
                      child: BuyListItemCard(item: buyList[i]),
                      onDismissed: (dir) => DatabaseService(user.uid).deleteItem(buyList[i].documentId),
                      background: Container(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding:EdgeInsets.all(20),
                          child:Icon(Icons.delete))
                      ),
                    );
                  }
                ),
              ),
              SizedBox(height:24),
              Container(child: BuyListAddButton(user.uid)),
              SizedBox(height:12)
            ]
          ),
        )
      ),
    );
  }


  Widget BuyListItemCard({item,delete}){
    return Card(
      margin: EdgeInsets.all(4.0),
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal:16.0,vertical:30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Text(item.name, overflow: TextOverflow.ellipsis)
            ),
            Expanded(
              flex: 2,
              child: Text(formatPrice(price: item.price),textAlign: TextAlign.end,)
            )
          ],
        ),
      ) 
    );
  }
  Widget BuyListAddButton(String uid) => RaisedButton.icon(
    padding: EdgeInsets.all(8.0),
    label: Text("買い物リストに追加",style: TextStyle(fontSize:16)),
    onPressed: () {
      
      createListAddDialog(context)
        .then((list){setState(() {
          BuyListItem item = BuyListItem(name: list[0], price: int.parse(list[1]) );
          updateBuyList(item.name, item.price, uid);
          showSimpleNotification(
            Text("Successfully added buying list!"),
            background: Colors.green,
            autoDismiss: false,
            trailing: Builder(builder: (context) {
              return FlatButton(
                  textColor: Colors.yellow,
                  onPressed: () {
                    OverlaySupportEntry.of(context).dismiss();
                  },
                  child: Text('Dismiss'));
            })
          );
        });}); 
    },
    color: Colors.green,
    textColor: Colors.white,
    icon: Icon(Icons.plus_one)
  );
  
  
}
