import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:to_do_app/persistent/dao/hive_dao.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController taskController = TextEditingController();
  List<String> tasks = [];
  final _hiveDAO = HiveDAO();

  @override
  void initState() {
    tasks = _hiveDAO.getTasksList;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "To Do",
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 228, 147, 182)),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: SizedBox(
                      width: double.infinity,
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Add Task",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 228, 147, 182)),
                          ),
                          TextField(
                            controller: taskController,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                if (taskController.text.isNotEmpty) {
                                  setState(() {
                                    tasks.add(taskController.text);
                                    _hiveDAO.saveTaskList(tasks);
                                    taskController.clear();
                                  });

                                  Navigator.pop(context);
                                }
                              },
                              child: const Text(
                                "Ok",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 228, 147, 182)),
                              ))
                        ],
                      ),
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.add,
              ))
        ],
      ),
      body: tasks.isEmpty
          ? Center(
              child: Lottie.asset("assets/animations/no_task.json",
                  width: 220, height: 220))
          : Padding(
              padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
              child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 239, 229, 238)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.note_outlined),
                                const SizedBox(
                                  width: 25,
                                ),
                                Text(
                                  tasks[index],
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Color.fromARGB(255, 228, 147, 182)),
                                ),
                              ],
                            ),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    tasks.remove(tasks[index]);
                                    _hiveDAO.saveTaskList(tasks);
                                  });
                                },
                                child: const Icon(Icons.delete_outline)),
                          ],
                        ),
                      ),
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 20,
                      ),
                  itemCount: tasks.length),
            ),
    ));
  }
}
