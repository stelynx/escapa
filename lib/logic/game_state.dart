part of 'game_bloc.dart';

enum GameStatus {
  initial,
  playing,
  gameOver,
}

@immutable
class GameState {
  final Player player;
  final List<Enemy> enemies;
  final FieldBorder border;
  final bool isPlayerDragging;
  final GameStatus gameStatus;
  final double deltaTime;
  final int tickCount;
  final int? startTimeInMs;
  final int? endTimeInMs;
  final bool showTimerOnLeft;
  final Orientation screenOrientation;

  const GameState({
    required this.player,
    required this.enemies,
    required this.border,
    required this.isPlayerDragging,
    required this.gameStatus,
    required this.deltaTime,
    required this.tickCount,
    required this.startTimeInMs,
    required this.endTimeInMs,
    required this.showTimerOnLeft,
    required this.screenOrientation,
  });

  factory GameState.initial({
    required Size screenSize,
    required Orientation screenOrientation,
    bool showTimerOnLeft = true,
  }) {
    final double fieldSize = min(screenSize.width, screenSize.height);
    final Offset fieldPosition = Offset(
      (screenSize.width - fieldSize) / 2,
      (screenSize.height - fieldSize) / 2,
    );

    return GameState(
      player: Player(
        position: Offset(screenSize.width / 2, screenSize.height / 2),
        size: fieldSize * 40.0 / 450.0,
      ),
      enemies: <Enemy>[
        Enemy(
          position: fieldPosition +
              Offset(fieldSize * 270.0 / 450.0, fieldSize * 60.0 / 450.0),
          width: fieldSize * 60.0 / 450.0,
          height: fieldSize * 50.0 / 450.0,
          step: const Offset(-10.0, 12.0),
        ),
        Enemy(
          position: fieldPosition +
              Offset(fieldSize * 300.0 / 450.0, fieldSize * 330.0 / 450.0),
          width: fieldSize * 100.0 / 450.0,
          height: fieldSize * 20.0 / 450.0,
          step: const Offset(-12.0, -20.0),
        ),
        Enemy(
          position: fieldPosition +
              Offset(fieldSize * 70.0 / 450.0, fieldSize * 320.0 / 450.0),
          width: fieldSize * 30.0 / 450.0,
          height: fieldSize * 60.0 / 450.0,
          step: const Offset(15, -13),
        ),
        Enemy(
          position: fieldPosition +
              Offset(fieldSize * 70.0 / 450.0, fieldSize * 70.0 / 450.0),
          width: fieldSize * 60.0 / 450.0,
          height: fieldSize * 60.0 / 450.0,
          step: const Offset(17.0, 11.0),
        ),
      ],
      border: FieldBorder(
        position: fieldPosition,
        size: fieldSize,
        width: fieldSize * 50.0 / 450.0,
      ),
      isPlayerDragging: false,
      gameStatus: GameStatus.initial,
      deltaTime: Config.tickEveryMilliseconds / 80.0,
      tickCount: 0,
      startTimeInMs: null,
      endTimeInMs: null,
      showTimerOnLeft: showTimerOnLeft,
      screenOrientation: screenOrientation,
    );
  }

  GameState copyWith({
    Player? player,
    List<Enemy>? enemies,
    FieldBorder? border,
    bool? isPlayerDragging,
    GameStatus? gameStatus,
    double? deltaTime,
    int? tickCount,
    int? startTimeInMs,
    int? endTimeInMs,
    bool? showTimerOnLeft,
    Orientation? screenOrientation,
  }) =>
      GameState(
        player: player ?? this.player,
        enemies: enemies ?? this.enemies,
        border: border ?? this.border,
        isPlayerDragging: isPlayerDragging ?? this.isPlayerDragging,
        gameStatus: gameStatus ?? this.gameStatus,
        deltaTime: deltaTime ?? this.deltaTime,
        tickCount: tickCount ?? this.tickCount,
        startTimeInMs: startTimeInMs ?? this.startTimeInMs,
        endTimeInMs: endTimeInMs ?? this.endTimeInMs,
        showTimerOnLeft: showTimerOnLeft ?? this.showTimerOnLeft,
        screenOrientation: screenOrientation ?? this.screenOrientation,
      );
}
