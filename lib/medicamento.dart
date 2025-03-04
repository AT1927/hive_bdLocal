class Medicamento {
  String title;
  int quantity;
  String hour;
  bool isCompleted;

  Medicamento({
    required this.title,
    required this.quantity,
    required this.hour,
    this.isCompleted = false,
  });

  // Convert a Medicamento into a Map. The keys must correspond to the names of the fields.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'quantity': quantity,
      'hour': hour,
      'isCompleted': isCompleted,
    };
  }

  // Extract a Medicamento object from a Map.
  factory Medicamento.fromMap(Map<String, dynamic> map) {
    return Medicamento(
      title: map['title'],
      quantity: map['quantity'],
      hour: map['hour'],
      isCompleted: map['isCompleted'],
    );
  }
}
