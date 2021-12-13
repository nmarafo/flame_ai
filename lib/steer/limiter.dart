/* A {@code Limiter} provides the maximum magnitudes of speed and acceleration for both linear and angular components.
 *
 * @author davebaol */
abstract class Limiter {

/* Returns the threshold below which the linear speed can be considered zero. It must be a small positive value near to zero.
 * Usually it is used to avoid updating the orientation when the velocity vector has a negligible length. */
double getZeroLinearSpeedThreshold ();

/* Sets the threshold below which the linear speed can be considered zero. It must be a small positive value near to zero.
 * Usually it is used to avoid updating the orientation when the velocity vector has a negligible length. */
void setZeroLinearSpeedThreshold (double value);

/* Returns the maximum linear speed. */
double getMaxLinearSpeed ();

/* Sets the maximum linear speed. */
void setMaxLinearSpeed (double maxLinearSpeed);

/* Returns the maximum linear acceleration. */
double getMaxLinearAcceleration ();

/* Sets the maximum linear acceleration. */
void setMaxLinearAcceleration (double maxLinearAcceleration);

/* Returns the maximum angular speed. */
double getMaxAngularSpeed ();

/* Sets the maximum angular speed. */
void setMaxAngularSpeed (double maxAngularSpeed);

/* Returns the maximum angular acceleration. */
double getMaxAngularAcceleration ();

/* Sets the maximum angular acceleration. */
void setMaxAngularAcceleration (double maxAngularAcceleration);
}