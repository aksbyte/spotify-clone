import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constant/app_export.dart';

class BottomNavigationBarWidget extends ConsumerWidget {
  final int selectedIndex;
  final ValueChanged onTap;

  const BottomNavigationBarWidget(
      {super.key, required this.selectedIndex, required this.onTap});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
            icon: Image.asset(
              selectedIndex == 0
                  ? AppVector.homeFilled
                  : AppVector.homeUnFilled,
              color: selectedIndex == 0
                  ? AppColor.whiteColor
                  : AppColor.inactiveBottomBarItemColor,
            ),
            label: 'Home'),
        BottomNavigationBarItem(
            icon: Image.asset(
              AppVector.library,
              color: selectedIndex == 1
                  ? AppColor.whiteColor
                  : AppColor.inactiveBottomBarItemColor,
            ),
            label: 'Library'),
      ],
    );
  }
}
