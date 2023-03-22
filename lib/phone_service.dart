import 'dart:convert';

import 'package:flutter_mongo/utils.dart';
import 'package:dio/dio.dart';

class PhoneService {
  final dio = Dio();
  final String _dataSource = "Cluster0";
  final String _database = "phonebook";
  final String _collection = "phonebookCollection";
  final String _endpoint = "<REPLACE WITH THE ENDPOINT URL>";
  static const _apiKey = "REPLACE WITH THE API KEY";

  var headers = {
    "content-type": "application/json",
    "apiKey": _apiKey,
  };

  Future<List<PhoneBook>> getPhoneContacts() async {
    var response = await dio.post(
      "$_endpoint/action/find",
      options: Options(headers: headers),
      data: jsonEncode(
        {
          "dataSource": _dataSource,
          "database": _database,
          "collection": _collection,
          "filter": {},
        },
      ),
    );

    if (response.statusCode == 200) {
      var respList = response.data['documents'] as List;
      var phoneList = respList.map((json) => PhoneBook.fromJson(json)).toList();
      return phoneList;
    } else {
      throw Exception('Error getting phone contacts');
    }
  }

  Future<PhoneBook> getSinglePhoneContact(String id) async {
    var response = await dio.post(
      "$_endpoint/action/find",
      options: Options(headers: headers),
      data: jsonEncode(
        {
          "dataSource": _dataSource,
          "database": _database,
          "collection": _collection,
          "filter": {
            "_id": {"\$oid": id}
          },
        },
      ),
    );

    if (response.statusCode == 200) {
      var resp = response.data['documents'][0];
      var contact = PhoneBook.fromJson(resp);
      return contact;
    } else {
      throw Exception('Error getting phone contact');
    }
  }

  Future updatePhoneContact(String id, String fullname, int phonenumber) async {
    var response = await dio.post(
      "$_endpoint/action/updateOne",
      options: Options(headers: headers),
      data: jsonEncode(
        {
          "dataSource": _dataSource,
          "database": _database,
          "collection": _collection,
          "filter": {
            "_id": {"\$oid": id}
          },
          "update": {
            "\$set": {"fullname": fullname, "phonenumber": phonenumber}
          }
        },
      ),
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Error getting phone contact');
    }
  }

  Future createPhoneContact(String fullname, int phonenumber) async {
    var response = await dio.post(
      "$_endpoint/action/insertOne",
      options: Options(headers: headers),
      data: jsonEncode(
        {
          "dataSource": _dataSource,
          "database": _database,
          "collection": _collection,
          "document": {"fullname": fullname, "phonenumber": phonenumber}
        },
      ),
    );

    if (response.statusCode == 201) {
      return response.data;
    } else {
      throw Exception('Error creating phone contact');
    }
  }

  Future deletePhoneContact(String id) async {
    var response = await dio.post(
      "$_endpoint/action/deleteOne",
      options: Options(headers: headers),
      data: jsonEncode(
        {
          "dataSource": _dataSource,
          "database": _database,
          "collection": _collection,
          "filter": {
            "_id": {"\$oid": id}
          },
        },
      ),
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Error deleting phone contact');
    }
  }
}
