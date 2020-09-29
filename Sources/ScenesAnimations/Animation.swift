/*
 ScenesAnimations provides support for creating and running animations.
 ScenesAnimations runs on top of Scenes and IGIS.
 Copyright (C) 2020 Camden Thomson
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

/// Defines the timings for animating an `Interpolatable` element.
public class Animation : Equatable {
    private static var nextAnimationId : Int = 0

    internal var animationController : AnimationController?
    internal var state : AnimationState = .idle
    internal var completedDelay : Bool = false
    internal var time : Double = 0

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
    /// The time, in seconds, to delay the animation from the time it begins and the beginning of the animation sequence.
    public private(set) var delay : Double
    /// The `EasingStyle` to apply to the animation.
    public private(set) var ease : EasingStyle
    /// The current elapsed time for the animation.
    public private(set) var elapsedTime : Double = 0
    
    /// The playback direction for the animation.
    public var direction : Direction = .normal
    /// The repeat style for the animation.
    public var repeatStyle : RepeatStyle = .none
    
    /// Describes whether or not animation is currently in reverse.
    public private(set) var isReversed : Bool = false
    /// The current number of completed animation cycles.
    public private(set) var cycle : Int = 0

    internal init(delay: Double, duration: Double, ease: EasingStyle) { 
        self.animationId = Animation.nextAnimationId
        Animation.nextAnimationId += 1

        self.delay = delay
        self.duration = duration
        self.ease = ease
    }

    internal func registerToAnimationController(animationController: AnimationController) {
        self.animationController = animationController
    }

    internal func update(deltaTime: Double) {
        guard isPlaying || isPaused else {
            return
        }

        elapsedTime += deltaTime
        
        if state == .pending {
            // keep time within time bounds
            time = max(0, min(delay, time + deltaTime))

            if time >= delay {
                state = .playing
                time = isReversed
                  ? duration
                  : 0
                completedDelay = true
            }
        } else if state == .playing {
            time = max(0, min(duration, time + (isReversed ? -deltaTime : deltaTime)))

            if !isReversed && time >= duration || isReversed && time <= 0 {
                if repeatStyle.shouldRepeat(for: cycle) {
                    cycle += 1
                    isReversed = direction.shouldPlayReversed(isReversed: isReversed)
                    time = isReversed
                      ? duration
                      : 0
                } else if state == .playing {
                    state = .completed
                }
            } else if state == .idle && time >= duration {
                state = .completed
            }
        }
    }

    internal func reset() {
        completedDelay = false
        time = 0
        elapsedTime = 0
        state = .idle
        cycle = 0
        isReversed = direction.shouldStartReversed()
    }

    /// Specifies if the `Animation` is currently completed.
    public var isCompleted : Bool {
        return state == .completed
    }

    /// Specifies if the `Animation` is currently paused.
    public var isPaused : Bool {
        return state == .paused
    }

    /// Specifies if the `Animation` is currently playing.
    public var isPlaying : Bool {
        return state == .pending || state == .playing
    }

    /// Plays the animation from the beginning of its sequence.
    ///
    /// If animation is already playing, it will restart.
    public func play() {
        guard let controller = animationController else {
            return
        }

        reset()
        state = .pending
        controller.run(animation: self)
    }

    /// Stops and resets the animation.
    public func stop() {
        terminate()
    }

    /// Pauses the animation where it is.
    public func pause() {
        if isPlaying {
            state = .paused
        }
    }

    /// Resumes the animation from where it left off.
    public func resume() {
        if isPaused {
            state = completedDelay
              ? .playing
              : .pending
        }
    }

    /// Restarts the animation from the beginning.
    public func restart() {
        play()
    }

    /// Stops the animation.
    public func terminate() {
        guard let animationController = animationController else {
            return
        }
        
        reset()
        animationController.remove(animation: self)
    }

    /// Equivalence operator for two `Animation`s.
    public static func == (left: Animation, right: Animation) -> Bool {
        return left.animationId == right.animationId
    }
}
