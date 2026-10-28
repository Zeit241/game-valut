import 'package:flutter/material.dart';
import 'package:game_shelf/ui/core/theme/app_colors.dart';
import 'package:game_shelf/utils/router.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CustomNavigationBar extends StatefulWidget {
  final int selectedIndex;

  const CustomNavigationBar({super.key, required this.selectedIndex});

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    final goRouter = GoRouter.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(thickness: 0.5, height: 1, color: AppColors.getColorFormHex("#2A303D")),
        NavigationBar(
          onDestinationSelected: (int index) {
            final String path = RouterUtils.getPathByIndex(index);
            goRouter.go(path);
          },
          selectedIndex: widget.selectedIndex,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(LucideIcons.compass),
              label: 'Explore',
            ),
            NavigationDestination(
              icon: Icon(LucideIcons.search),
              label: 'Search',
            ),
            NavigationDestination(
              icon: Icon(LucideIcons.library),
              label: 'My Library',
            ),
      
          ],
        ),
      ],
    );
  }
}
