# ScenesAnimations

## To Do
- [ ] Redesign `Tweenable` for uniformity and accuracy.
  - [x] Redo `Tweenable` protocol.
  - [ ] Complete conformance for new protocol.
- [ ] Improve `EasingStyle` and add more styles.
  - [ ] Internal calculation changes.
  - [ ] Implement new easing styles.
- [ ] Improve animation state system.
- [ ] Add delay to `Animation` (and remove delay tween).

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
- added new `steps`, `custom`, and `cubicBezier` easing styles.

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
