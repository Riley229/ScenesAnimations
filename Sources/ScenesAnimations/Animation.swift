/// An `Animation` is used to animate elements.
public class Animation : Equatable {
    enum State {
        case notQueued
        case queued
        case playing
        case playingInReverse
        case paused
        case pausedInReverse
        case completed
        case cancelled
    }
    internal var state = State.notQueued

    private let tween : InternalTweenProtocol
    private var elapsedTime = 0.0

    /// Specifies whether or not to loop the animation over and over again until 'terminate()' is called.
    public var loop = false
    /// Specifies whether or not to reverse the animation after the animation is completete.
    public var reverse = false

    /// Creates a new 'Animation' from the specified 'Tween'
    /// - Parameters:
    ///   - tween: The 'Tween'
    public init(tween: TweenProtocol) {
        guard let tween = tween as? InternalTweenProtocol else {
            fatalError("tween doesn't conform to InternalTweenProtocol.")
        }
        self.tween = tween
    }

    internal init(tween: InternalTweenProtocol) {
        self.tween = tween
    }

    internal func updateFrame(frameRate: Double) {
        // if animation has been queued, begin playing
        if state == .queued {
            state = .playing
        }
        
        if state == .playing {
            let percent = elapsedTime / tween.duration
            tween.update(progress: percent)
            
            if percent >= 1 {
                if reverse {
                    state = .playingInReverse
                } else if loop {
                    restart()
                } else {
                    state = .completed
                }
            }
            
            elapsedTime += frameRate
        } else if state == .playingInReverse {
            let percent = elapsedTime / tween.duration
            tween.update(progress: percent)
            
            if percent <= 0 {
                if loop {
                    restart()
                } else {
                    state = .completed
                }
            }
            
            elapsedTime -= frameRate
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
        return state == .paused || state == .pausedInReverse
    }

    /// returns true if the animation is currently playing
    public var isPlaying : Bool {
        return state == .playing || state == .playingInReverse || state == .queued
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
            if state == .playingInReverse {
                state = .pausedInReverse
            } else {
                state = .paused
            }
        }
    }

    /// Plays the animation
    ///
    /// NB: Only plays if already added to 'AnimationManager'
    public func play() {
        if !isCompleted && !isPlaying {
            if isQueued {
                if state == .pausedInReverse {
                    state = .playingInReverse
                } else {
                    state = .playing
                }
            } else {
                state = .queued
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
