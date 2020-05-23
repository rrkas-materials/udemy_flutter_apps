class Transaction {
  String id;
  String title;
  double amount;
  DateTime date;

  Transaction({
    this.amount,
    this.date,
    this.title,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'amount': amount,
      'date': date,
    };
  }

  Transaction.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    amount = map['amount'];
    date = map['date'];
  }
}
