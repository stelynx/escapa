part of 'game_bloc.dart';

@immutable
abstract class GameEvent {
  const GameEvent();
}

class MoveEnemies extends GameEvent {
  const MoveEnemies();
}

class UpdatePlayerPosition extends GameEvent {
  final Offset position;

  const UpdatePlayerPosition(this.position);
}

class UpdateIsPlayerDragging extends GameEvent {
  final bool value;

  const UpdateIsPlayerDragging(this.value);
}

class ToggleTimerPosition extends GameEvent {
  const ToggleTimerPosition();
}

class RestartGame extends GameEvent {
  const RestartGame();
}

class OrientationChanged extends GameEvent {
  final Orientation orientation;

  const OrientationChanged(this.orientation);
}
