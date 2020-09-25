/// Allows the animation of `Interpolatable` elements.
public class Animation : Equatable {
    private static var nextAnimationId : Int = 0
    
    internal var state : AnimationState = .idle
    internal var time : Double = 0

    /// A unique identifying number for the animation.
    public let animationId : Int
    let tween : InternalTweenProtocol

    /// The time, in seconds, the animation will take to complete one cycle.
    public var duration : Double = 1 {
        didSet {
            if duration <= 0 {
                duration = 0.001
            }
        }
    }
    /// The amount of time, in seconds, to delay the animation from the time it begins and the beginning of the animation sequence.
    public var delay : Double = 0
    /// The playback direction of the animation.
    public var direction : Direction = .normal
    /// The repeat style for the animation.
    public var repeatStyle : RepeatStyle = .none
    /// Describes whether or not animation is currently in reverse.
    public private(set) var isReversed : Bool = false
    /// The current number of completed animation cycles.
    public private(set) var cycle : Int = 0

    /// The current elapsed time for the animation.
    public private(set) var elapsedTime : Double = 0

    public init(tween: TweenProtocol) {
        guard let tween = tween as? InternalTweenProtocol else {
            fatalError("")
        }
        self.tween = tween
        
        self.animationId = Animation.nextAnimationId
        Animation.nextAnimationId += 1
    }

    internal func update(frameTime: Double) {
        guard !isPaused() else {
            return
        }

        if state == .pending {
            time = max(0, min(delay, time + frameTime))
            elapsedTime += frameTime

            if time >= delay {
                state = .playing
                if [.reverse, .alternateReverse].contains(direction) {
                    time = duration
                } else {
                    time = 0
                }
            }
        } else if state == .playing {
            time += isReversed ? -frameTime : frameTime
            time = max(0, min(duration, time))
            elapsedTime += frameTime

            if !isReversed && time >= duration || isReversed && time <= 0 {
                if repeatStyle.shouldRepeat(for: cycle) {
                    cycle += 1
                    isReversed = direction.isReversed(isReversed: isReversed)
                    if !isReversed {
                        time = 0
                    } else {
                        time = duration
                    }
                } else {
                    if state == .playing {
                        state = .completed
                    }
                }
            } else if state == .idle && time >= duration {
                state = .completed
            }
            
            tween.update(progress: time / duration)
        }
    }

    /// Specifies if `Animation` is paused.
    /// - Returns: True if animation is currently in a paused state.
    public func isPaused() -> Bool {
        return state == .paused
    }

    public func play() {
        self.state = .pending
        if [.reverse, .alternateReverse].contains(direction) {
            isReversed = true
        } else {
            isReversed = false
        }
    }

    /// Equivalence operator for two `Animation`s.
    public static func == (left: Animation, right: Animation) -> Bool {
        return left.animationId == right.animationId
    }

    // UNTOUCHED (YET)
    // private let tween : InternalTweenProtocol
    // private var elapsedTime = 0.0

    // internal func updateFrame(frameRate: Double) {
    //     // if animation has been queued, begin playing
    //     if state == .pending {
    //         state = .playing
    //     }
        
    //     if state == .playing {
    //         let percent = elapsedTime / duration
    //         tween.update(progress: percent)

    //         if isReversed && percent <= 0 {
    //             if loop {
    //                 restart()
    //             } else {
    //                 state = .completed
    //             }
    //         } else if !isReversed && percent >= 1 {
    //             if reverse {
    //                 isReversed = true
    //             } else if loop {
    //                 restart()
    //             } else {
    //                 state = .completed
    //             }
    //         }

    //         elapsedTime += isReversed ? -frameRate : frameRate
    //     }
    // }

    // /// returns true if the animation was completed or cancelled
    // ///
    // /// NB: will only return true for one frame when animation is completed
    // public var isCompleted : Bool {
    //     return state == .completed || state == .cancelled
    // }

    // /// returns true if the animation is currently paused
    // public var isPaused : Bool {
    //     return state == .paused
    // }

    // /// returns true if the animation is currently playing
    // public var isPlaying : Bool {
    //     return state == .playing || state == .pending
    // }

    // /// returns true if the animation isPlaying, isPaused, or isCompleted.
    // public var isQueued : Bool {
    //     return state != .idle
    // }

    
    // /// Stops the animation and removes it from the 'AnimationManager'
    // public func terminate() {
    //     if isQueued {
    //         state = .cancelled
    //     }
    // }

    // /// Pauses the animation
    // public func pause() {
    //     if isPlaying {
    //         state = .paused
    //     }
    // }

    // /// Plays the animation
    // ///
    // /// NB: Only plays if already added to 'AnimationManager'
    // public func play() {
    //     if !isCompleted && !isPlaying {
    //         if isQueued {
    //             state = .playing
    //         } else {
    //             state = .pending
    //         }
    //     }
    // }

    // /// Restarts the animation to the initial value as specified in the 'Tween'.
    // public func restart() {
    //     if isPlaying {
    //         state = .playing
    //     } else {
    //         state = .idle
    //     }
    //     self.elapsedTime = 0
    // }
}
