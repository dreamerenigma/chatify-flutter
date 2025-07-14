import 'package:flutter/widgets.dart';

class ChatifyNavigatorObserver extends NavigatorObserver {
  final ValueNotifier<bool> showBackButtonNotifier;

  ChatifyNavigatorObserver(this.showBackButtonNotifier);

  void _update(Route? route) {
    showBackButtonNotifier.value = route?.isFirst == false;
  }

  @override
  void didPush(Route route, Route? previousRoute) => _update(route);
  @override
  void didPop(Route route, Route? previousRoute) => _update(previousRoute);
  @override
  void didReplace({Route? newRoute, Route? oldRoute}) => _update(newRoute);
}

class BackButtonObserver extends NavigatorObserver {
  final ValueNotifier<bool> backButtonNotifier;

  BackButtonObserver(this.backButtonNotifier);

  void _updateBackButton(NavigatorState navigator) {
    backButtonNotifier.value = navigator.canPop();
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _updateBackButton(navigator!);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _updateBackButton(navigator!);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    _updateBackButton(navigator!);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    _updateBackButton(navigator!);
  }
}

class RouteNotifierObserver extends NavigatorObserver {
  final ValueNotifier<String?> currentRouteNotifier;

  RouteNotifierObserver(this.currentRouteNotifier);

  void _update(Route? route) {
    final routeName = route?.settings.name;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      currentRouteNotifier.value = routeName;
    });
  }

  @override
  void didPush(Route route, Route? previousRoute) => _update(route);
  @override
  void didPop(Route route, Route? previousRoute) => _update(previousRoute);
  @override
  void didReplace({Route? newRoute, Route? oldRoute}) => _update(newRoute);
}
