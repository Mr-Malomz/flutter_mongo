import 'package:flutter/material.dart';
import 'package:flutter_mongo/phone_service.dart';
import 'package:flutter_mongo/screens/home.dart';
import 'package:flutter_mongo/utils.dart';

class Detail extends StatefulWidget {
  const Detail({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullname = TextEditingController();
  final TextEditingController _phonenumber = TextEditingController();
  late PhoneBook contact;
  bool _isLoading = false;
  bool _isSubmitting = false;
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

    PhoneService().getSinglePhoneContact(widget.id).then((value) {
      setState(() {
        contact = value;
        _isLoading = false;
      });
      _fullname.text = value.fullname;
      _phonenumber.text = value.phonenumber.toString();
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    });
  }

  updateContact(String fullname, int phonenumber) {
    setState(() {
      _isSubmitting = true;
    });

    PhoneService()
        .updatePhoneContact(widget.id, fullname, phonenumber)
        .then((value) {
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contact updated successfully!')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    }).catchError((onError) {
      setState(() {
        _isSubmitting = false;
        _isError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating contact!')),
      );
    });
  }

  deleteContact() {
    setState(() {
      _isSubmitting = true;
    });

    PhoneService().deletePhoneContact(widget.id).then((value) {
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contact deleted successfully!')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    }).catchError((onError) {
      setState(() {
        _isSubmitting = false;
        _isError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting contact!')),
      );
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
                  title: const Text("Details"),
                  backgroundColor: Colors.black,
                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 30.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Fullname',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.0,
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                TextFormField(
                                  controller: _fullname,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please input your fullname';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    hintText: "input name",
                                    fillColor: Colors.white,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.red),
                                    ),
                                  ),
                                  keyboardType: TextInputType.text,
                                  maxLines: null,
                                ),
                                const SizedBox(height: 30.0),
                                const Text(
                                  'Phone number',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.0,
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                TextFormField(
                                  controller: _phonenumber,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please input your phone number';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    hintText: "input phone number",
                                    fillColor: Colors.white,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.red),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 30.0),
                        SizedBox(
                          height: 45,
                          width: double.infinity,
                          child: TextButton(
                            onPressed: _isSubmitting
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      updateContact(
                                        _fullname.text,
                                        int.parse(_phonenumber.text),
                                      );
                                    }
                                  },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
                            ),
                            child: const Text(
                              'Update contact',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: _isSubmitting
                      ? null
                      : () {
                          deleteContact();
                        },
                  backgroundColor: Colors.red,
                  tooltip: 'Delete',
                  child: const Icon(Icons.delete),
                ),
              );
  }
}
