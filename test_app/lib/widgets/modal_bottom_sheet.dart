import 'package:flutter/material.dart';

class ModalBottomSheet extends StatelessWidget {
  final Widget child;

  const ModalBottomSheet({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          child: const Icon(Icons.touch_app),
          onPressed: () => showModalBottomSheet(
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16))),
              context: context,
              builder: (context) {
                return FractionallySizedBox(heightFactor: 0.8, child: child);
              }),
        ),
      ),
    );
  }
}
