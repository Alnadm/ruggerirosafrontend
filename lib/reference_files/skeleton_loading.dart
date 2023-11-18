import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonLoadingList extends StatefulWidget {
  @override
  _SkeletonLoadingListState createState() => _SkeletonLoadingListState();
}

class _SkeletonLoadingListState extends State<SkeletonLoadingList> {
  bool _contentLoaded = false;

  @override
  void initState() {
    super.initState();

    // Simulating loading content after 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _contentLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E),
      body: ListView.builder(
        itemCount: 5, // Adjust the number of items as needed
        itemBuilder: (context, index) {
          return PulsatingListItem(
            contentLoaded: _contentLoaded,
          );
        },
      ),
    );
  }
}

class PulsatingListItem extends StatelessWidget {
  final bool contentLoaded;

  PulsatingListItem({required this.contentLoaded});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !contentLoaded,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        period: Duration(milliseconds: 1000),
        child: Container(
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.grey[300],
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[300],
              radius: 30,
            ),
            title: Container(
              height: 20,
              width: 100,
              color: Colors.grey[300],
            ),
            subtitle: Container(
              height: 15,
              width: 200,
              color: Colors.grey[300],
            ),
          ),
        ),
      ),
    );
  }
}
