import 'package:flutter/material.dart';
import 'package:keep_on_track/components/lecture/lectrue_row.dart';
import 'package:keep_on_track/screens/lecture/lecture.dart';
import 'package:keep_on_track/services/database/lecture.dart';

import '../../components/drawer.dart';
import '../../data/model/lecture.dart';

class Lectures extends StatefulWidget {
  const Lectures({super.key});

  @override
  State<Lectures> createState() => _LecturesState();
}

class _LecturesState extends State<Lectures> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vorlesungen'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => LectureScreen(lecture: null, deleteLecture: () => {},)));
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
      drawer: const CustomDrawer(),
      body: FutureBuilder<List<Lecture>?>(
        future: LectureDatabaseHelper.getAll(),
        builder: (context, AsyncSnapshot<List<Lecture>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Fehler beim Laden: ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data != null) {
              return ListView.builder(
                itemBuilder: (context, index) => LectureRow(
                  deleteLecture: () => {
                    setState(() {
                      snapshot.data!.remove(snapshot.data![index]);
                    })
                  },
                    lectures: snapshot.data,
                    index: index,
                    lecture: snapshot.data![index]
                ),
                itemCount: snapshot.data!.length,
              );
            } else {
              return const Center(
                child: Text("Data null"),
              );
            }
          } else {
            return const Center(
              child: Text("Juhu, es gibt keine Vorlesungen :D"),
            );
          }
        },
      ),
    );
  }
}
