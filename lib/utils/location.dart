/* The {@code Location} interface represents any game object having a position and an orientation.
 *
 * @param <T> Type of vector, either 2D or 3D, implementing the {@link Vector} interface
 *
 * @author davebaol */


import 'package:flame/extensions.dart';

abstract class Location implements Vector2 {

/* Returns the vector indicating the position of this location. */
getPosition ();

/* Returns the float value indicating the orientation of this location. The orientation is the angle in radians representing
 * the direction that this location is facing. */
double getOrientation ();

/* Sets the orientation of this location, i.e. the angle in radians representing the direction that this location is facing.
 * @param orientation the orientation in radians */
void setOrientation (double orientation);

/* Returns the angle in radians pointing along the specified vector.
 * @param vector the vector */
double vectorToAngle (Vector2 vector);

/* Returns the unit vector in the direction of the specified angle expressed in radians.
 * @param outVector the output vector.
 * @param angle the angle in radians.
 * @return the output vector for chaining. */
Vector2? angleToVector (Vector2 outVector, double angle);

/* Creates a new location.
 * <p>
 * This method is used internally to instantiate locations of the correct type parameter {@code T}. This technique keeps the API
 * simple and makes the API easier to use with the GWT backend because avoids the use of reflection.
 * @return the newly created location. */
Location? newLocation ();
}