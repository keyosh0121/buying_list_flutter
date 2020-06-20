import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tokyo_stroll/models/buyListItem.dart';


class DatabaseService {

  final String uid;
  DatabaseService(this.uid);

  final CollectionReference buylistCollection = Firestore.instance.collection('buylists');

  updateBuyList(String name, int amount) async{
    try{
      return await buylistCollection.document(uid).collection("buylist").add({
        'name': name,
        'amount': amount 
      });
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  deleteItem(String documentId) async{
    return await buylistCollection.document(uid).collection("buylist").document(documentId).delete();
  }

  Stream<List<BuyListItem>> get buylist {
    return buylistCollection.document(uid).collection("buylist").snapshots()
      .map(_buyListItemsFromSnapShot);
  }

  List<BuyListItem> _buyListItemsFromSnapShot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return BuyListItem(
        documentId: doc.documentID,
        name: doc.data["name"] ?? '',
        price: doc.data["amount"] ?? 0
      );
    }).toList();
  }
}
