import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Chats History"),
        elevation: .3,
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, i){
          return Slidable(
            key: ValueKey(i),
            endActionPane: ActionPane(
              // A motion is a widget used to control how the pane animates.
              motion: const ScrollMotion(),
              // A pane can dismiss the Slidable.
              dismissible: DismissiblePane(onDismissed: () {}),
              // All actions are defined in the children parameter.
              children: const [
                // A SlidableAction can have an icon and/or a label.
                SlidableAction(
                  onPressed: null,
                  backgroundColor: Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: const ListTile(
              isThreeLine: true,
              leading: CircleAvatar(backgroundImage: AssetImage("assets/images/ChatGpt-Logo-black_white.png"), radius: 16,),
              title: Text("GPT-4", style: TextStyle(fontWeight: FontWeight.w500),),
              subtitle: Text("lorem ChatGpt-Logo-black_white ChatGpt-Logo-black_white"),
            ),
          );
        },
      ),
    );
  }
}