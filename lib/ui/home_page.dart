import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:todo_notify/ui/widgets/date_utils.dart' as date_util;
import 'package:todo_notify/controllers/task_controller.dart';
import 'package:todo_notify/models/task.dart';
import 'package:todo_notify/services/notification_services.dart';
import 'package:todo_notify/services/theme_services.dart';
import 'package:todo_notify/ui/add_task_bar.dart';
import 'package:todo_notify/ui/theme.dart';
import 'package:todo_notify/ui/widgets/colors_utils.dart';
import 'widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDateIcon = DateTime.now();
  final _taskController = Get.put(TaskController());
  var notifyHelper = NotifyHelper();
  bool isSwitched = false;
  //variaveis para criar bolhas dos dias
  double width = 0.0;
  double height = 0.0;
  late ScrollController scrollController;
  List<DateTime> currentMonthList = List.empty();
  DateTime currentDateTime = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    currentMonthList = date_util.DateUtils.daysInMonth(currentDateTime);
    currentMonthList.sort((a, b) => a.day.compareTo(b.day));
    currentMonthList = currentMonthList.toSet().toList();
    scrollController =
        ScrollController(initialScrollOffset: 70.0 * currentDateTime.day);

    super.initState();

    //notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification;
    notifyHelper.requestIOSPermissions();
    _taskController
        .getTasks(); // se não carregar as tarefas salvas posso apagar
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.backgroundColor,
      body: Column(children: [
        _addTaskBar(),
        topView(),
        const SizedBox(
          height: 10,
        ),
        _showTasks(),
      ]),
    );
  }

  //Adiciona o mês como titulo
  Widget titleView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      child: Text(
        date_util.DateUtils.months[currentDateTime.month - 1] +
            ' ' +
            currentDateTime.year.toString(),
        style: TextStyle(
            color: Get.isDarkMode ? white : darkGreyClr,
            fontWeight: FontWeight.bold,
            fontSize: 20),
      ),
    );
  }

  //Container dos dias do mês
  Widget hrizontalCapsuleListView() {
    return Container(
      width: width,
      height: 110,
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: currentMonthList.length,
        itemBuilder: (BuildContext context, int index) {
          return capsuleView(index);
        },
      ),
    );
  }

  // personalização capsulas dos dias
  Widget capsuleView(int index) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: GestureDetector(
          onTap: () {
            setState(() {
              currentDateTime = currentMonthList[index];
              _selectedDateIcon =
                  currentDateTime; //ao clicar no dia muda junto a do calendario
            });
          },
          child: Container(
            width: 70,
            height: 140,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: (currentMonthList[index].day != currentDateTime.day)
                        ? [Colors.white, Colors.white, Colors.white]
                        : [
                            HexColor("4e5ae8"),
                            HexColor("4e5ae8"),
                            HexColor("4e5ae8")
                          ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(0.0, 1.0),
                    stops: const [0.0, 0.5, 1.0],
                    tileMode: TileMode.clamp),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(5, 5),
                    blurRadius: 6,
                    spreadRadius: 2,
                    color: Colors.black12,
                  )
                ]),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    currentMonthList[index].day.toString(),
                    style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color:
                            (currentMonthList[index].day != currentDateTime.day)
                                ? HexColor("9e9e9e")
                                : Colors.white),
                  ),
                  Text(
                    date_util.DateUtils
                        .weekdays[currentMonthList[index].weekday - 1],
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            (currentMonthList[index].day != currentDateTime.day)
                                ? HexColor("9e9e9e")
                                : Colors.white),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget topView() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: height * 0.22,
        width: width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Get.isDarkMode ? HexColor("272936") : HexColor("ffffff"),
                Get.isDarkMode ? HexColor("272936") : HexColor("ffffff"),
                Get.isDarkMode ? HexColor("272936") : HexColor("ffffff")
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.0, 1.0),
              stops: const [0.0, 0.5, 1.0],
              tileMode: TileMode.clamp),
          boxShadow: const [
            BoxShadow(
                blurRadius: 4,
                color: Colors.black12,
                offset: Offset(4, 4),
                spreadRadius: 2)
          ],
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              titleView(),
              hrizontalCapsuleListView(),
            ]),
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index) {
              Task task = _taskController.taskList[index];
              String dateFormat =
                  DateFormat('dd/MM/yyyy').format(DateTime.now());
              if (task.date == dateFormat.substring(2, 10) ||
                  task.date ==
                      DateFormat('dd/MM/yyyy').format(_selectedDateIcon)) {
                DateTime date =
                    DateFormat.Hm().parse(task.startTime.toString());
                var myTime = DateFormat("Hm").format(date);

                notifyHelper.scheduledNotification(
                    int.parse(myTime.toString().split(":")[0]),
                    int.parse(myTime.toString().split(":")[1]),
                    task);

                return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                          child: Row(children: [
                        GestureDetector(
                          onTap: (() {
                            _showBottomSheet(context, task);
                          }),
                          child: TaskTile(task),
                        )
                      ])),
                    ));
              } else {
                return Container();
              }
            });
      }),
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.only(top: 4),
      height: task.isCompleted == 1
          ? MediaQuery.of(context).size.height * 0.24
          : MediaQuery.of(context).size.height * 0.32,
      color: Get.isDarkMode ? darkGreyClr : Colors.white,
      child: Column(children: [
        //entalhe topo do container
        Container(
          height: 6,
          width: 120,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
        ),
        const Spacer(),
        task.isCompleted == 1
            ? Container()
            : _bottomSheetButton(
                label: "Tarefa completa",
                onTap: () {
                  _taskController.markTaskCompleted(task.id!);
                  Get.back();
                },
                clr: primaryClr,
                context: context),

        const SizedBox(
          height: 5,
        ),
        _bottomSheetButton(
            label: "Apagar tarefa",
            onTap: () {
              _taskController.delete(task);
              //_taskController.getTasks(); //atualiza a tela
              Get.back();
            },
            clr: Colors.redAccent,
            context: context),
        const SizedBox(
          height: 20,
        ),
        _bottomSheetButton(
            label: "Fechar",
            onTap: () {
              Get.back();
            },
            clr: Colors.redAccent,
            isClose: true,
            context: context),
        const SizedBox(
          height: 10,
        ),
      ]),
    ));
  }

  _bottomSheetButton(
      {required String label,
      required Function()? onTap,
      required Color clr,
      bool isClose = false,
      required BuildContext context}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
              width: 2,
              color: isClose == true
                  ? Get.isDarkMode
                      ? Colors.grey[600]!
                      : Colors.grey[300]!
                  : clr),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime(2222));

    if (_pickerDate != null) {
      setState(() {
        _selectedDateIcon = _pickerDate;
        currentDateTime = _pickerDate;
      });
    } else {
      print("Algo está errado");
    }
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('dd/MM/yyyy').format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  "Hoje",
                  style: headingStyle,
                )
              ],
            ),
          ),
          // Column(
          //   children: [
          //     Switch(
          //       value: isSwitched,
          //       onChanged: (value) {
          //         setState(() {
          //           isSwitched = value;
          //           print(isSwitched);
          //         });
          //       },
          //       activeTrackColor: bluishClr2,
          //       activeColor: bluishClr,
          //     ),
          //     Text(
          //       "Ver datas anteriores",
          //       style: subTitleStyle,
          //     )
          //   ],
          // ),
          // MyButton(
          //     label: "Adicionar tarefa",
          //     onTap: () async {
          //       await Get.to(() => const AddTaskPage());
          //       _taskController.getTasks();
          //     })
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
          onTap: (() {
            ThemeService().switchThemeMode();
            // notificação de alteração do tema
            notifyHelper.displayNotification(
                title: 'Tema alterado',
                body: Get.isDarkMode
                    ? 'Tema claro ativado'
                    : 'Tema escuro ativado');
            //notifyHelper.scheduledNotification();
          }),
          child: Icon(
              Get.isDarkMode
                  ? Icons.wb_sunny_outlined
                  : Icons.nights_stay_rounded,
              size: 25,
              color: Get.isDarkMode ? Colors.white : Colors.black)),
      actions: <Widget>[
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.calendar_today_outlined),
              color: Get.isDarkMode ? Colors.white : Colors.black,
              onPressed: () {
                _getDateFromUser();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.add_task,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
              onPressed: () async {
                await Get.to(() => const AddTaskPage());
                _taskController.getTasks();
              },
            ),
          ],
        )
      ],
    );
  }
}
