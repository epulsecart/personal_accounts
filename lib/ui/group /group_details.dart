import 'package:flutter/material.dart';

class GroupDetailScreen extends StatefulWidget {
  final String groupId ;
  const GroupDetailScreen({super.key, required this.groupId});

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
