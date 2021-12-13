/* A {@code Steerable} is a {@link Location} that gives access to the character's data required by steering system.
 * <p>
 * Notice that there is nothing to connect the direction that a Steerable is moving and the direction it is facing. For
 * instance, a character can be oriented along the x-axis but be traveling directly along the y-axis.
 *
 * @param <T> Type of vector, either 2D or 3D, implementing the {@link Vector} interface
 *
 * @author davebaol */

import 'package:flame/extensions.dart';
import 'package:flame_ai/utils/location.dart';
import 'limiter.dart';

abstract class Steerable implements Vector2,Location,Limiter {
/* Returns the vector indicating the linear velocity of this Steerable. */
Vector2? getLinearVelocity ();

/* Returns the float value indicating the the angular velocity in radians of this Steerable. */
double getAngularVelocity ();

/* Returns the bounding radius of this Steerable. */
double getBoundingRadius ();

/* Returns {@code true} if this Steerable is tagged; {@code false} otherwise. */
bool isTagged ();

/* Tag/untag this Steerable. This is a generic flag utilized in a variety of ways.
 * @param tagged the boolean value to set */
void setTagged (bool tagged);
}