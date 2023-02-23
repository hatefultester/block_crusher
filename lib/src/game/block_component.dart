// import 'dart:math';

// import 'package:block_crusher/src/play_session/game_controller.dart';
// import 'package:flame/collisions.dart';
// import 'package:flame/components.dart';
// import 'package:flame/events.dart';
// import 'package:flame/palette.dart';

// import '../collector_game.dart';

// class BlockComponent extends PolygonComponent
//     with HasGameRef<BlockCrusherGame>, CollisionCallbacks, Draggable, Tappable {
//   BlockComponent.relative(super.relation, {required super.parentSize})
//       : super.relative();

//   Vector2? dragDeltaPosition;
//   bool get isDragging => dragDeltaPosition != null;

//   int level = 0;
//   List<PaletteEntry> paints = [
//     BasicPalette.blue,
//     BasicPalette.red,
//     BasicPalette.green,
//     BasicPalette.pink,
//     BasicPalette.purple,
//     BasicPalette.orange,
//     BasicPalette.lightOrange,
//     BasicPalette.lightGreen,
//     BasicPalette.darkPink,
//     BasicPalette.white,
//   ];

//   _paint() {
//     if (level < paints.length) {
//       paint = paints[level].paint();
//     }
//   }

//   bool tapped = false;

//   @override
//   Future<void> onLoad() async {
//     super.onLoad();
//     int xMax = (gameRef.size.x - size.x).toInt();
//     position = Vector2((Random().nextInt(xMax) + 0), 0);

//     _paint();

//     await add(CircleHitbox()..shouldFillParent);
//   }

//   @override
//   update(double dt) {
//     super.update(dt);

//     if (!isDragging && !tapped) {
//       y += GameController.to.blockFallSpeed.value;
//     }

//     if (y > gameRef.size.y) {
//       GameController.to.blockRemoved();
//       removeFromParent();
//     }
//   }

//   @override
//   bool onDragStart(DragStartInfo info) {
//     dragDeltaPosition = info.eventPosition.game - position;
//     return false;
//   }

//   @override
//   bool onDragUpdate(DragUpdateInfo info) {
//     if (isDragging) {
//       final localCoords = info.eventPosition.game;
//       position = localCoords - dragDeltaPosition!;
//     }
//     return false;
//   }

//   @override
//   bool onDragEnd(DragEndInfo info) {
//     dragDeltaPosition = null;
//     return false;
//   }

//   @override
//   bool onDragCancel() {
//     dragDeltaPosition = null;
//     return false;
//   }

//   @override
//   void onCollisionStart(
//       Set<Vector2> intersectionPoints, PositionComponent other) {
//     super.onCollisionStart(intersectionPoints, other);

//     if (other is BlockComponent) {
//       switch (GameController.to.gameMode) {
//         case GameMode.dumb:
//           _dumbCollisionStartMethod(other);
//           break;
//         case GameMode.colorful:
//           _colorfulCollisionStartMethod(other);
//           break;

//         default:
//           return;
//       }
//     }
//   }

//   _colorfulCollisionStartMethod(BlockComponent other) {
//     if (y > 5 && isDragging && other.level == level) {
//       other.removeFromParent();
//       level++;
//       _paint();
//       GameController.to.collisionDetected();
//     }
//   }

//   _dumbCollisionStartMethod(PositionComponent other) {
//     if (y > 5) {
//       other.removeFromParent();
//       removeFromParent();
//       GameController.to.collisionDetected();
//     }
//   }

//   @override
//   bool onTapDown(TapDownInfo info) {
//     tapped = true;
//     return super.onTapDown(info);
//   }

//   @override
//   bool onTapCancel() {
//     tapped = false;
//     return super.onTapCancel();
//   }

//   @override
//   bool onTapUp(TapUpInfo info) {
//     tapped = false;
//     return super.onTapUp(info);
//   }
// }
