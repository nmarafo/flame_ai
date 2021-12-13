/* {@code GroupBehavior} is the base class for the steering behaviors that take into consideration the agents in the game world
 * that are within the immediate area of the owner. This immediate area is defined by a {@link Proximity} that is in charge of
 * finding and processing the owner's neighbors through the given {@link ProximityCallback}.
 *
 * @param <T> Type of vector, either 2D or 3D, implementing the {@link Vector} interface
 *
 * @author davebaol */
import 'package:flame/extensions.dart';
import 'package:flame_ai/steer/proximity.dart';
import 'package:flame_ai/steer/steerable.dart';
import 'package:flame_ai/steer/steering_behavior.dart';

abstract class GroupBehavior extends Vector2 implements SteeringBehavior {

  /* The proximity decides which agents are considered neighbors. */
  late Proximity proximity;

  /* Creates a GroupBehavior for the specified owner and proximity.
   * @param owner the owner of this behavior.
   * @param proximity the proximity to detect the owner's neighbors */
  factory GroupBehavior (Steerable owner, Proximity proximity) =>GroupBehavior(owner, proximity);


  /* Returns the proximity of this group behavior */
  Proximity getProximity () {
    return proximity;
  }

  /* Sets the proximity of this group behavior
   * @param proximity the proximity to set */
  void setProximity (Proximity proximity) {
    this.proximity = proximity;
  }

}