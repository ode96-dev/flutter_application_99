import 'package:flutter/material.dart';
import 'package:flutter_application_99/components/button.dart';
import 'package:flutter_application_99/components/input.dart';
import 'package:flutter_application_99/data/account_json.dart';
import 'package:flutter_application_99/sqlite/database_helper.dart';

class Accounts extends StatefulWidget {
  const Accounts({super.key});

  @override
  State<Accounts> createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  late DatabaseHelper handler;
  late Future<List<AccountsJson>>? accounts;

  final db = DatabaseHelper();

  @override
  void initState() {
    handler = db;
    accounts = handler.getAccounts();

    handler.init().whenComplete(() {});

    super.initState();
  }

  Future<List<AccountsJson>> getAllRecords() async {
    return await handler.getAccounts();
  }

  Future<void> _onRefresh() async {
    setState(() {
      accounts = getAllRecords();
    });
  }

  Future<List<AccountsJson>> filter() async {
    return await handler.filter(searchController.text);
  }

  final accHolder = TextEditingController();
  final accName = TextEditingController();
  final searchController = TextEditingController();
  bool isSearchOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addDialog();
          accHolder.clear();
          accName.clear();
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
        title: isSearchOn
            ? Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                width: MediaQuery.of(context).size.width * 0.4,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400,
                      blurRadius: 1,
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      accounts = filter();
                    });
                  },
                  controller: searchController,
                  decoration: InputDecoration(
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                searchController.clear();
                                _onRefresh();
                              });
                            },
                            icon: const Icon(
                              Icons.clear,
                              size: 17.0,
                            ),
                          )
                        : const SizedBox(),
                    border: InputBorder.none,
                    hintText: "Search accounts here...",
                    icon: const Icon(
                      Icons.search,
                    ),
                  ),
                ),
              )
            : const Text(
                "Accounts",
              ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: IconButton(
              onPressed: () {
                setState(() {
                  isSearchOn = !isSearchOn;
                });
              },
              icon: const Icon(
                Icons.search,
              ),
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: accounts,
        builder:
            (BuildContext context, AsyncSnapshot<List<AccountsJson>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No accounts found"),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            final items = snapshot.data ?? <AccountsJson>[];
            return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 20.0,
                      child: Text(
                        items[index].accHolder[0],
                      ),
                    ),
                    title: Text(
                      items[index].accHolder,
                    ),
                    subtitle: Text(
                      items[index].accName,
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          deleteAccount(
                            items[index].accId,
                          );
                        });
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red.shade400,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        updateDialog(items[index].accId);

                        accHolder.text = items[index].accHolder;
                        accName.text = items[index].accName;
                      });
                    },
                  );
                });
          }
        },
      ),
    );
  }

  void addDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add a new account"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InputField(
                  hint: 'Account Holder',
                  icon: Icons.person,
                  controller: accHolder,
                ),
                InputField(
                  hint: 'Account Name',
                  icon: Icons.account_circle_rounded,
                  controller: accName,
                ),
              ],
            ),
            actions: [
              Button(
                  label: "Add account",
                  press: () {
                    Navigator.pop(context);
                    addAccount();
                  })
            ],
          );
        });
  }

//update
  void updateDialog(id) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Edit account"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InputField(
                  hint: 'Account Holder',
                  icon: Icons.person,
                  controller: accHolder,
                ),
                InputField(
                  hint: 'Account Name',
                  icon: Icons.account_circle_rounded,
                  controller: accName,
                ),
              ],
            ),
            actions: [
              Button(
                  label: "Update account",
                  press: () {
                    Navigator.pop(context);
                    updateAccount(id);
                  })
            ],
          );
        });
  }

  void addAccount() async {
    var res = await handler.insertAccount(
      AccountsJson(
        accHolder: accHolder.text,
        accName: accName.text,
        accStatus: 1,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );

    if (res > 0) {
      setState(() {
        _onRefresh();
      });
    }
  }

  void updateAccount(accId) async {
    var res = await handler.updateAccount(accHolder.text, accName.text, accId);

    if (res > 0) {
      setState(() {
        _onRefresh();
      });
    }
  }

  void deleteAccount(id) async {
    var res = await handler.deleteAccount(id);

    if (res > 0) {
      setState(() {
        _onRefresh();
      });
    }
  }
}
