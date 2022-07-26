import 'package:flutter/material.dart';
import 'package:to_do_app/database_helper.dart';
import 'package:to_do_app/models/task.dart';
import 'package:to_do_app/screens/taskpages.dart';
import 'package:to_do_app/text.dart';

import '../widgets.dart';

class HomePages extends StatefulWidget {
  const HomePages({Key? key}) : super(key: key);

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        color: Color(ColorHome.background_color),
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 24.0,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(
                          bottom: 32.0,
                          top: 32.0,
                        ),
                        child:
                            Image(image: AssetImage('assets/images/logo.png'))),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                              left: kBottomNavigationBarHeight / 2),
                          child: Text(
                            "Sổ tay ghi chú",
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: FutureBuilder<List<Task>>(
                    initialData: [],
                    future: _dbHelper.getTask(),
                    builder: (context, snapshot) {
                      return ScrollConfiguration(
                        behavior: NoGlowBehaviour(),
                        child: ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TaskPage(
                                      task: snapshot.data?[index],
                                    ),
                                  ),
                                ).then(
                                  (value) {
                                    setState(() {});
                                  },
                                );
                              },
                              child: TaskCardWidget(
                                title: snapshot.data![index].title,
                                desc: snapshot.data![index].description,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
            Positioned(
              bottom: 24.0,
              right: 0.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskPage(
                        task: null,
                      ),
                    ),
                  ).then((value) {
                    setState(() {});
                  });
                },
                child: Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                      // color: Color(0xFF7349FE),
                      gradient: LinearGradient(
                        colors: [Color(0xFF7349FE), Color(0xFF643FDB)],
                        begin: Alignment(0.0, -1.0),
                        end: Alignment(0.0, 1.0),
                      ),
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Image(
                    image: AssetImage('assets/images/add_icon.png'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
