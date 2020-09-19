# Changelog

## External Changes

### AnimationManager
- getValue() was deprecated. To access `EasingStyle` calculations, use the apply() method available through `EasingStyle` instead.

### Animation:
- inverse was deprecated due to extremely specialized applications.

### EasingStyle
- inverse was deprecated due to extremely specialized applications.

### Interpolatable (Tweenable)
- Tweenable has been renamed `Interpolatable` for conciseness.
- lerp() function replaced the "percent" parameter with "interpolant" for conciseness.
- Conformance now requires vectorize() and normalize() methods instead of lerp() and interval() methods.  This allows for more uniform interpolations.

### Tween
- inverse was deprecated due to extremely specialized applications.

### TweenSequence
- inverse was deprecated due to extremely specialized applications.


## Internal Changes

### AnimationManager
- removed reference to `Director` for easier compatability with other graphics libraries.
- Calculates frame rate instead of assuming desired frame rate (from director class) for smoother animations compatible with server latency.

### InternalTweenProtocol
- no longer requires conformance to `inverse` variable.

### DelayTween
- inverse was deprecated due to extremely specialized applications.
