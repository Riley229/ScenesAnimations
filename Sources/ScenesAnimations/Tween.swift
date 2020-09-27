public class Tween<TweenElement: Interpolatable> : InternalTweenProtocol, TweenProtocol {
    private let startValue : TweenElement
    private let endValue : TweenElement

    public typealias UpdateHandler<TweenElement: Interpolatable> = (TweenElement) -> ()
    var updateHandler : UpdateHandler<TweenElement>

    /// Creates a new `Tween` from the specified parameters.
    /// - Parameters:
    ///   - from: The starting value.
    ///   - to: The ending value.
    ///   - update: The value to update.
    public init(from: TweenElement, to: TweenElement, update: @escaping UpdateHandler<TweenElement>) {
        self.startValue = from
        self.endValue = to
        self.updateHandler = update
    }

    // public convenience init(from: TweenElement, to: TweenElement, speed: Double, ease: EasingStyle = .linear, update: @escaping UpdateHandler<TweenElement>) {
    //     var interval = from.interval(to:to)
    //     if interval < 0 {
    //         assert(false, "Distance returned from interval() in \(type(of: from)) must be positive.")
    //         interval = -interval
    //     }

    //     self.init(from: from, to: to, duration: interval / speed, ease: ease, update: update)
    // }

    @available(swift, obsoleted: 5.2.4, message: "No longer available.")
    internal var inverse : InternalTweenProtocol {
        return self
    }
    
    internal func update(progress: Double) {
        let newValue = startValue.lerp(to: endValue, interpolant: progress)
        updateHandler(newValue)
    }
}
