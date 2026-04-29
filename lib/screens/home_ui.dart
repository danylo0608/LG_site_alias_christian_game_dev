import 'package:flutter/material.dart';


import 'package:alias/resources_app/colors.dart';
import 'package:alias/resources_app/widgets_btn.dart';
import 'package:alias/screens/command_name_ui.dart';
import 'package:alias/screens/groups_list_ui.dart';


class HomeUi extends StatelessWidget {
  const HomeUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.green,
      body: Center(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Title program
              Container(
                width: 260,
                height: 260,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(24),
                child: const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Alias\nChristian\nGame",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 60,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const Spacer(),
              // Buttons (Play / Settings)
              MenuButton(
                text: "Грати",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CommandNameUi()),
                  );
                },
              ),
              const SizedBox(height: 20),
              MenuButton(
                text: "Перегляд слів",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GroupsListUi()),
                  );
                },
              ),
              const SizedBox(height: 20),

              // CommonButtons(
              //   text: "Вийти",
              //   onPressed: () async {
              //     bool? confirmExit = await showDialog<bool>(
              //       context: context,
              //       builder: (context) => AlertDialog(
              //         title: const Text("Підтвердження"),
              //         content: const Text("Ви дійсно хочете вийти?"),
              //         actions: [
              //           TextButton(
              //             onPressed: () => Navigator.pop(context, false),
              //             child: const Text("Ні"),
              //           ),
              //           TextButton(
              //             onPressed: () => Navigator.pop(context, true),
              //             child: const Text("Так"),
              //           ),
              //         ],
              //       ),
              //     );

              //     if (confirmExit == true) {
              //       // GoRouter автоматично знайде шлях '/', який ми прописали в main.dart
              //       context.go('/');
              //     }
              //   },
              // ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
