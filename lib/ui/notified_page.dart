import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_notify/ui/theme.dart';

class NotifiedPage extends StatelessWidget {
  final String label;
  const NotifiedPage({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.backgroundColor,
        leading: IconButton(
          onPressed: (() => Get.back()),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Get.isDarkMode ? Colors.white : Colors.grey,
          ),
        ),
        title: Text(
          label.toString().split("|")[0],
          style: TextStyle(
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label.toString().split("|")[0],
              style: TextStyle(
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                  fontSize: 25),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
                //height: 400,
                width: 300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Get.isDarkMode ? pinkClr : bluishClr),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '🗒️ ${label.toString().split("|")[1]}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 25),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          Text(
                            '🕒 ${label.toString().split("|")[2]}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 25),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
