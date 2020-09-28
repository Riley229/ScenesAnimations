# ScenesAnimations

ScenesAnimations is a library built on top of Igis and Scenes which adds support for creating and running animations.

## To Do List
- Add Interpolatable support for characters and strings.
- Make Color HSB Interpolatable.
- Add repeatDelay to Animation.
- Add support for animating along a path.
- Add simplified declarative syntax for animating properties.
- Add support for fractional repeatStyle counts and function checkers.
- Add Animation Timelines

## Changelog

### External Changes

#### AnimationManager
- getValue() was deprecated. To access `EasingStyle` calculations, use the apply() method available through `EasingStyle` instead.

#### Animation:
- inverse was deprecated due to extremely specialized applications.

#### EasingStyle
- inverse was obsoleted due to extremely specialized applications.
- `none` is now available as an alternative to `linear`.
- all configurable pow eases have been renamed to allow for uniformity in naming conventions.
- all exponential eases have been renamed to allow for uniformity in naming conventions.
- added new `steps`, `custom`, and `bezier` easing styles.

#### Interpolatable (Tweenable)
- Tweenable has been renamed `Interpolatable` for conciseness.
- The lerp() function replaced "percent" parameter with "interpolant" for conciseness.
- Conformance now requires vectorize() and normalize() methods instead of lerp() and interval() methods.  This allows for more uniform interpolations.
- All integer and floating point types now conform to interpolatable.
- DoublePoint and Rect now conform to interpolatable.

#### Tween
- inverse was deprecated due to extremely specialized applications.

#### TweenSequence
- inverse was deprecated due to extremely specialized applications.


### Internal Changes

#### AnimationManager
- removed reference to `Director` for easier compatability with other graphics libraries.
- Calculates frame rate instead of assuming desired frame rate (from director class) for smoother animations compatible with server latency.

#### Animation
- Improved state system and internal update calculations.

#### InternalTweenProtocol
- no longer requires conformance to `inverse` variable.

#### DelayTween
- inverse was deprecated due to extremely specialized applications.
