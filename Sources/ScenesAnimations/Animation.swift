/// An `Animation` is used to animate elements.
public class Animation : Equatable {
    enum State {
        case notQueued
        case pending
        case playing
        case paused
        case completed
        case cancelled
    }
    internal var state = State.notQueued
    internal var isReversed = false

    private let tween : InternalTweenProtocol
    private var elapsedTime = 0.0

    /// Specifies whether or not to loop the animation over and over again until 'terminate()' is called.
    public var loop = false
    /// Specifies whether or not to reverse the animation after the animation is completete.
    public var reverse = false

    public var duration : Double

    /// Creates a new 'Animation' from the specified 'Tween'
    /// - Parameters:
    ///   - tween: The 'Tween'
    public init(tween: TweenProtocol) {
        guard let tween = tween as? InternalTweenProtocol else {
            fatalError("tween doesn't conform to InternalTweenProtocol.")
        }
        self.tween = tween
        self.duration = tween.duration
    }

    internal init(tween: InternalTweenProtocol) {
        self.tween = tween
        self.duration = tween.duration
    }

    internal func updateFrame(frameRate: Double) {
        // if animation has been queued, begin playing
        if state == .pending {
            state = .playing
        }
        
        if state == .playing {
            let percent = elapsedTime / duration
            tween.update(progress: percent)

            if isReversed && percent <= 0 {
                if loop {
                    restart()
                } else {
                    state = .completed
                }
            } else if !isReversed && percent >= 1 {
                if reverse {
                    isReversed = true
                } else if loop {
                    restart()
                } else {
                    state = .completed
                }
            }

            elapsedTime += isReversed ? -frameRate : frameRate
        }
    }

    /// returns true if the animation was completed or cancelled
    ///
    /// NB: will only return true for one frame when animation is completed
    public var isCompleted : Bool {
        return state == .completed || state == .cancelled
    }

    /// returns true if the animation is currently paused
    public var isPaused : Bool {
        return state == .paused
    }

    /// returns true if the animation is currently playing
    public var isPlaying : Bool {
        return state == .playing || state == .pending
    }

    /// returns true if the animation isPlaying, isPaused, or isCompleted.
    public var isQueued : Bool {
        return state != .notQueued
    }

    @available(swift, obsoleted: 5.2.4, message: "No Longer Available")
    public var inverse : Animation {
        return self
    }

    /// Stops the animation and removes it from the 'AnimationManager'
    public func terminate() {
        if isQueued {
            state = .cancelled
        }
    }

    /// Pauses the animation
    public func pause() {
        if isPlaying {
            state = .paused
        }
    }

    /// Plays the animation
    ///
    /// NB: Only plays if already added to 'AnimationManager'
    public func play() {
        if !isCompleted && !isPlaying {
            if isQueued {
                state = .playing
            } else {
                state = .pending
            }
        }
    }

    /// Restarts the animation to the initial value as specified in the 'Tween'.
    public func restart() {
        if isPlaying {
            state = .playing
        } else {
            state = .notQueued
        }
        self.elapsedTime = 0
    }

    /// Equivalence operator for two 'Animation's.
    static public func == (lhs:Animation, rhs:Animation) -> Bool {
        return lhs === rhs
    }
}
