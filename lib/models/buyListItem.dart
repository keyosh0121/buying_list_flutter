
class BuyListItem {
  String documentId;
  String name;
  int price;
  Function delete;
  Function add;
  BuyListItem({this.documentId,this.name, this.price, this.delete, this.add});
}