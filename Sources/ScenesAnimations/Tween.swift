public class Tween<TweenElement: Interpolatable> : Animation {
    private let startValue : TweenElement
    private let endValue : TweenElement

    public typealias UpdateHandler<TweenElement: Interpolatable> = (TweenElement) -> ()
    var updateHandler : UpdateHandler<TweenElement>

    /// Creates a new `Tween` from the specified parameters.
    /// - Parameters:
    ///   - from: The starting value.
    ///   - to: The ending value.
    ///   - update: The value to update.
    public init(from: TweenElement, to: TweenElement, delay: Double = 0, duration: Double = 1,
                ease: EasingStyle = .none, update: @escaping UpdateHandler<TweenElement>) {
        self.startValue = from
        self.endValue = to
        self.updateHandler = update
        super.init(delay: delay, duration: duration, ease: ease)
    }

    public convenience init(from: TweenElement, to: TweenElement, delay: Double = 0, speed: Double,
                            ease: EasingStyle = .none, update: @escaping UpdateHandler<TweenElement>) {
        var interval = from.interval(to: to)
        if interval < 0 {
            assert(false, "Distance returned from distance() in \(type(of: from)) must be positive.")
            interval = -interval
        }

        self.init(from: from, to: to, delay: delay, duration: interval / speed, ease: ease, update: update)
    }

    override func update(deltaTime: Double) {
        super.update(deltaTime: deltaTime)

        if state == .playing {
            let newValue = startValue.lerp(to: endValue, interpolant: ease.apply(progress: time / duration))
            updateHandler(newValue)
        }
    }
}
