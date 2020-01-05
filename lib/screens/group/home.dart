import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ringl8/components/loading.dart';
import 'package:ringl8/components/square_menu_button.dart';
import 'package:ringl8/main.dart';
import 'package:ringl8/models/group.dart';
import 'package:ringl8/routes/app_state.dart';
import 'package:ringl8/services/group.dart';

class GroupHome extends StatelessWidget {
  final application = sl.get<AppState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final childRatio = (size.width / size.height) * 2.5;
    return StreamBuilder<Group>(
      stream: GroupService().group,
      builder: (BuildContext context, AsyncSnapshot<Group> snapshot) {
        if (!snapshot.hasData) return Loading();
        application.currentGroup = snapshot.data;
        application.currentGroupUID = snapshot.data.uid;
        return Scaffold(
          appBar: AppBar(
            title: Text(application.currentGroup.name),
            centerTitle: true,
            elevation: 0.0,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(25),
                  child: GridView.count(
                    shrinkWrap: true,
                    childAspectRatio: childRatio,
                    crossAxisCount: 2,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    children: [
                      SquareMenuButton(
                        icon: FontAwesomeIcons.calendarDay,
                        text: 'Today',
                        navigateTo: '/today',
                      ),
                      SquareMenuButton(
                        icon: Icons.chat,
                        text: 'Chat',
                        navigateTo: '/chat',
                      ),
                      SquareMenuButton(
                        icon: Icons.group,
                        text: 'Manage Members',
                        navigateTo: '/members',
                      ),
                      SquareMenuButton(
                        icon: FontAwesomeIcons.cogs,
                        text: 'Customize',
                        navigateTo: '/customize',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
