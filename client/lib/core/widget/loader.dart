import '../constant/app_export.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    //return const Center(child: CircularProgressIndicator.adaptive());
    return const SpinKitThreeInOut(
      color: Colors.green,
      size: 50,
    );
  }
}
