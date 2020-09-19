/// A `Tween` is used to create animate `Tweenable` elements.
///
/// NB: update is a trailing [closure](https://docs.swift.org/swift-book/LanguageGuide/Closures.html).
///
/// ~~~
/// let tween = Tween(from: Point(), to: Point(x: 100, y: 100)) {
///     self.rectangle.rect.topLeft = $0
/// }
/// ~~~

public class Tween<TweenElement: Tweenable> : InternalTweenProtocol, TweenProtocol {
    private let startValue : TweenElement
    private let endValue : TweenElement

    /// The amount of time taken, in seconds.
    public let duration : Double
    /// The `EasingStyle` applied.
    public let ease : EasingStyle

    public typealias UpdateHandler<TweenElement: Tweenable> = (TweenElement) -> ()
    var updateHandler : UpdateHandler<TweenElement>

    /// Creates a new `Tween` from the specified parameters.
    /// - Parameters:
    ///   - from: The starting value.
    ///   - to: The ending value.
    ///   - duration: The amount of time to take.
    ///   - ease: The `EasingStyle` to apply.
    ///   - update: The value to update.
    public init(from: TweenElement, to: TweenElement, duration: Double = 1, ease: EasingStyle = .linear, update: @escaping UpdateHandler<TweenElement>) {
        self.startValue = from
        self.endValue = to
        self.duration = duration
        self.ease = ease
        self.updateHandler = update
    }

    /// Creates a new `Tween` from the specified parameters.
    /// - Parameters:
    ///   - from: The starting value.
    ///   - to: The ending value.
    ///   - speed: The speed to animate the element at (in pixels per second).
    ///   - ease: The `EasingStyle` to apply.
    ///   - update: The value to update.
    public convenience init(from: TweenElement, to: TweenElement, speed: Double, ease: EasingStyle = .linear, update: @escaping UpdateHandler<TweenElement>) {
        var interval = from.interval(to:to)
        if interval < 0 {
            assert(false, "Distance returned from interval() in \(type(of: from)) must be positive.")
            interval = -interval
        }

        self.init(from: from, to: to, duration: interval / speed, ease: ease, update: update)
    }

    @available(swift, obsoleted: 5.2.4, message: "No longer available.")
    internal var inverse : InternalTweenProtocol {
        return self
    }
    
    internal func update(progress: Double) {
        let easePercent = ease.apply(percent: progress)
        let newValue = startValue.lerp(to: endValue, percent: easePercent)
        updateHandler(newValue)
    }
}
