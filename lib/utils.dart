class PhoneBook {
  String? id;
  String fullname;
  int phonenumber;

  PhoneBook({
    this.id,
    required this.fullname,
    required this.phonenumber,
  });

  Map<dynamic, dynamic> toJson() {
    return {
      "fullname": fullname,
      "phonenumber": phonenumber,
    };
  }

  factory PhoneBook.fromJson(Map<dynamic, dynamic> json) {
    return PhoneBook(
      id: json['_id'],
      fullname: json['fullname'],
      phonenumber: json['phonenumber'],
    );
  }
}
