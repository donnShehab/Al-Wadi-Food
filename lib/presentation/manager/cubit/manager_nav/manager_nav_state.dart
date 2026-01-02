abstract class ManagerNavState {
  final int index;
  const ManagerNavState(this.index);
}

class ManagerNavInitial extends ManagerNavState {
  const ManagerNavInitial() : super(0);
}

class ManagerNavChanged extends ManagerNavState {
  const ManagerNavChanged(int index) : super(index);
}
