import 'package:flutter/material.dart';

class ReusableListTileWidgetUserScreen extends StatelessWidget {

  const ReusableListTileWidgetUserScreen(
      {super.key, required this.titleString,  this.subTitleString = '', required this.leadingIconName, required this.onTap});
  final String titleString;
  final String subTitleString;
  final IconData leadingIconName;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap:onTap,
      leading: Icon(leadingIconName,
        color: Theme.of(context).iconTheme.color,
      ),
      title: Text(titleString,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      // subtitle: Text(subTitleString,
      //   style: Theme.of(context).textTheme.labelMedium,),
      trailing:  Icon(Icons.arrow_forward_ios_outlined,
      color: Theme.of(context).iconTheme.color,
      ),
    );
  }


}
