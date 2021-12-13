import 'package:flame/extensions.dart';

class VectorAI extends Vector2{

  VectorAI(): super.zero();

  VectorAI limit(double value){
    if (value == 0.0) {
      setZero();
    } else {
      var l = length;
      if (l == 0.0) {
        return this;
      }
      l = value / l;
      storage[0] *= l;
      storage[1] *= l;
    }
    return this;
  }
}