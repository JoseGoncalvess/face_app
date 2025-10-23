import 'package:flutter/material.dart';
import 'package:persona_app/core/utils/const.dart';
import 'package:persona_app/src/contacts/contact_view_model.dart';

class ContactView extends ContactViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contacts',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 1,
      ),
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: !isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) => ListTile(
                  onTap: () {},

                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(users[index].picture.medium),
                  ),
                  title: Text(
                    users[index].fullName,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(users[index].phone),
                  trailing: IconButton(
                    onPressed: () => {
                      deletUserForList(users[index]),
                      // removeList(),
                      // log(users[index].login.uuid),
                    },
                    icon: Icon(Icons.delete),
                  ),
                ),
              ),
      ),
    );
  }
}
