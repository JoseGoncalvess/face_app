import 'package:face_app/src/contacts/contact_view_model.dart';
import 'package:flutter/material.dart';
import 'package:face_app/core/utils/const.dart';

class ContactView extends ContactViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: !isLoading
            ? Center(child: CircularProgressIndicator())
            : _buildUserList(),
      ),
      floatingActionButton: isInSelectionMode
          ? FloatingActionButton(
              onPressed: () => selectAllUserForDelete(),
              child: Icon(Icons.checklist_rounded),
            )
          : null,
    );
  }

  AppBar _buildAppBar() {
    if (isInSelectionMode) {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.close, color: secundaryColor),
          onPressed: clearSelection,
        ),
        title: Text(
          '${selectedUsers.length} selecionado(s)',
          style: TextStyle(color: backgroudColor, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: selectedUsers.isNotEmpty ? Colors.red[700] : Colors.grey,
            ),
            onPressed: selectedUsers.isNotEmpty ? deleteSelectedUsers : null,
          ),
        ],
      );
    } else {
      return AppBar(
        title: const Text(
          'Saved Users',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 1,
        actions: [
          if (users.isNotEmpty)
            IconButton(
              onPressed: enterEditMode,
              icon: const Icon(Icons.edit_note_outlined, color: Colors.white),
            ),
        ],
      );
    }
  }

  Widget _buildUserList() {
    if (users.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum usuário salvo.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final isSelected = selectedUsers.contains(user);

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            selected: isSelected,
            selectedTileColor: primaryColor.withOpacity(0.1),

            onTap: () => handleItemTap(user),

            onLongPress: () => handleLongPress(user),

            leading: isInSelectionMode
                ? Checkbox(
                    value: isSelected,
                    onChanged: (val) => handleItemTap(user),
                    activeColor: primaryColor,
                  )
                : (widget.isconnectState
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(user.picture.medium),
                        )
                      : CircleAvatar(
                          backgroundColor: secundaryColor,
                          child: Icon(
                            Icons.person,
                            size: 20,
                            color: primaryColor,
                          ),
                        )),

            title: Text(
              user.fullName,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(user.phone),

            trailing: isInSelectionMode
                ? null
                : const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
          ),
        );
      },
    );
  }
}
