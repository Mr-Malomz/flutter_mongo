import 'package:flutter/material.dart';
import 'package:flutter_mongo/phone_service.dart';
import 'package:flutter_mongo/screens/create.dart';
import 'package:flutter_mongo/screens/detail.dart';
import 'package:flutter_mongo/utils.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<PhoneBook> contacts;
  bool _isLoading = false;
  bool _isError = false;

  @override
  void initState() {
    getContacts();
    super.initState();
  }

  getContacts() {
    setState(() {
      _isLoading = true;
    });

    PhoneService().getPhoneContacts().then((value) {
      setState(() {
        contacts = value;
        _isLoading = false;
      });
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(
            color: Colors.blue,
          ))
        : _isError
            ? const Center(
                child: Text(
                  'Error getting phone contacts',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  title: const Text('Phonebook'),
                  backgroundColor: Colors.black,
                ),
                body: ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Detail(id: contacts[index].id!),
                          ),
                        );
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: .5, color: Colors.grey),
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    contacts[index].fullname,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(contacts[index].phonenumber.toString())
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(height: 10.0),
                                Icon(Icons.arrow_forward_ios_rounded)
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Create(),
                      ),
                    );
                  },
                  backgroundColor: Colors.black,
                  tooltip: 'Create contact',
                  child: const Icon(Icons.add),
                ),
              );
  }
}
