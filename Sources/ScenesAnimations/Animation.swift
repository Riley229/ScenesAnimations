/// Allows the animation of `Interpolatable` elements.
public class Animation : Equatable {
    private static var nextAnimationId : Int = 0
    
    internal var state : AnimationState = .idle
    internal var time : Double = 0
    internal var controller : AnimationController?

    /// A unique identifying number for the animation.
    public let animationId : Int

    /// The time, in seconds, the animation will take to complete one cycle.
    public private(set) var duration : Double {
        didSet {
            if duration <= 0 {
                duration = 0.001
            }
        }
    }
    /// The amount of time, in seconds, to delay the animation from the time it begins and the beginning of the animation sequence.
    public private(set) var delay : Double
    /// The playback direction of the animation.
    public var direction : Direction = .normal
    /// The repeat style for the animation.
    public var repeatStyle : RepeatStyle = .none
    public private(set) var ease : EasingStyle
    /// Describes whether or not animation is currently in reverse.
    public private(set) var isReversed : Bool = false
    /// The current number of completed animation cycles.
    public private(set) var cycle : Int = 0

    /// The current elapsed time for the animation.
    public private(set) var elapsedTime : Double = 0

    internal init(delay: Double, duration: Double, ease: EasingStyle) { 
        self.animationId = Animation.nextAnimationId
        Animation.nextAnimationId += 1

        self.delay = delay
        self.duration = duration
        self.ease = ease
    }

    internal func registerAnimationController(_ controller: AnimationController) {
        self.controller = controller
    }

    internal func update(deltaTime: Double) {
        guard !isPaused() else {
            return
        }

        if state == .pending {
            time = max(0, min(delay, time + deltaTime))
            elapsedTime += deltaTime

            if time >= delay {
                state = .playing
                if [.reverse, .alternateReverse].contains(direction) {
                    time = duration
                } else {
                    time = 0
                }
            }
        } else if state == .playing {
            time += isReversed ? -deltaTime : deltaTime
            time = max(0, min(duration, time))
            elapsedTime += deltaTime

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
        }
    }

    /// Specifies if `Animation` is paused.
    /// - Returns: True if animation is currently in a paused state.
    public func isPaused() -> Bool {
        return state == .paused
    }

    public func play() {
        guard let controller = controller else {
            return
        }
        
        self.state = .pending
        if [.reverse, .alternateReverse].contains(direction) {
            isReversed = true
        } else {
            isReversed = false
        }
        controller.run(animation: self)
    }

    /// Equivalence operator for two `Animation`s.
    public static func == (left: Animation, right: Animation) -> Bool {
        return left.animationId == right.animationId
    }
}
