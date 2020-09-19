/// A `TweenSequence` is used to sequence different `Tween`s.
public class TweenSequence : InternalTweenProtocol, TweenProtocol {
    private var tweens : [InternalTweenProtocol] = []

    /// The total amout of time taken, in seconds.
    public let duration : Double

    public convenience init(delay: Double = 0, tweens: TweenProtocol...) {
        self.init(delay: delay, tweens: tweens)
    }

    /// Creates a new `TweenSequence` from the specified parameters.
    /// - Parameters:
    ///   - delay: the delay, in seconds, to add between each `Tween`.
    ///   - tweens: the tweens to sequence, one at a time.
    public init(delay: Double = 0, tweens: [TweenProtocol]) {
        var duration = 0.0
        
        for (index, tween) in tweens.enumerated() {
            guard let tween = tween as? InternalTweenProtocol else {
                fatalError("tween doesn't conform to InternalTweenProtocol.")
            }
            
            if index == 0 || delay == 0 {
                self.tweens.append(tween)
                duration += tween.duration
            } else {
                self.tweens.append(DelayTween(duration: delay))
                self.tweens.append(tween)
                duration += (delay + tween.duration)
            }
        }
        
        self.duration = duration
    }

    internal init(tweens: [InternalTweenProtocol]) {
        var duration = 0.0
        
        for tween in tweens {
            self.tweens.append(tween)
            duration += tween.duration
        }
        
        self.duration = duration
    }

    @available(swift, obsoleted: 5.2.4, message: "No longer available")
    internal var inverse : InternalTweenProtocol {
        return self
    }

    internal func update(progress: Double) {
        let timeElapsed = duration * progress
        var timeToCurrentTween = 0.0
        if let tween = findCurrentTween(timeElapsed: timeElapsed, timeToCurrentTween: &timeToCurrentTween) {
            let tweenTimeElapsed = timeElapsed - timeToCurrentTween
            tween.update(progress: tweenTimeElapsed/tween.duration)
        }
    }

    private func findCurrentTween(timeElapsed: Double, timeToCurrentTween: inout Double) -> InternalTweenProtocol? {
        for tween in tweens {
            if timeToCurrentTween + tween.duration < timeElapsed {
                timeToCurrentTween += tween.duration
            } else {
                return tween
            }
        }
        return nil
    }
}
