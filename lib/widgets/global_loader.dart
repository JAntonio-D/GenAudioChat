import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/loader_controller.dart';

class GlobalLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoaderController>(
      builder: (context, loaderController, _) {
        if (!loaderController.isLoading) return SizedBox.shrink();

        return Stack(
          children: [
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
