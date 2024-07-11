import 'package:flutter/material.dart';
import 'package:flutter_application_99/menu/menu_items.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final controller = MenuItems();
  int currentIndex = 0;
  bool selectedItem = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          background(
            Column(
              children: [
                const Icon(
                  Icons.computer_rounded,
                ),
                Expanded(
                  flex: 3,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.items.length,
                    itemBuilder: (context, index) {
                      selectedItem = currentIndex == index;
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: selectedItem
                              ? Colors.blue.shade300
                              : Colors.transparent,
                        ),
                        child: ListTile(
                          onTap: () {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                          title: Text(
                            controller.items[index].title,
                          ),
                          leading: Icon(
                            controller.items[index].icon,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.logout,
                        ),
                        title: Text("Logout"),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: PageView.builder(
              itemCount: controller.items.length,
              onPageChanged: (value) {
                setState(() {
                  currentIndex = value;
                });
              },
              itemBuilder: (context, index) {
                return SizedBox(
                  child: controller.items[currentIndex].page,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget background(Widget child) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 10.0,
      ),
      width: 200.0,
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          const BoxShadow(
            // color: Colors.grey.withOpacity(8),
            blurRadius: 1,
            spreadRadius: 0,
          )
        ],
        color: Colors.white,
      ),
      child: child,
    );
  }
}
