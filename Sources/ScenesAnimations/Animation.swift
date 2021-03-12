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

import Scenes

/// Defines the timings for animating an `Interpolatable` element.
public class Animation : IdentifiableObject {
    internal var animationController : AnimationController?
    internal var state : AnimationState = .idle
    internal var completedDelay : Bool = false
    internal var time : Double = 0

    /// The time, in seconds, the animation will take to complete one cycle.
    public internal(set) var duration : Double {
        didSet {
            if duration <= 0 {
                duration = 0.001
            }
        }
    }
    /// The time, in seconds, to delay the animation from the time it begins and the beginning of the animation sequence.
    public internal(set) var delay : Double
    
    /// The `EasingStyle` to apply to the animation.
    public private(set) var ease : EasingStyle
    /// The current elapsed time for the animation.
    public private(set) var elapsedTime : Double = 0
    
    /// The playback direction for the animation.
    public var direction : Direction = .normal
    /// The time, in seconds, to delay the animation between cycles.
    public var repeatDelay : Double = 0 {
        didSet {
            if repeatDelay < 0 {
                repeatDelay = 0
            }
        }
    }
    /// The repeat style for the animation.
    public var repeatStyle : RepeatStyle = .count(1)
    
    /// Describes whether or not animation is currently in reverse.
    public private(set) var isReversed : Bool = false
    /// The current number of completed animation cycles.
    public private(set) var cycle : Int = 0

    // Type of handler for animation completion
    public typealias CompletionHandler = (_ animation:Animation) -> Void

    /// Stores the handler to be used when animation completes
    public var completionHandler : CompletionHandler?

    internal init(delay: Double, duration: Double, ease: EasingStyle) { 
        self.delay = delay
        self.duration = duration
        self.ease = ease

        super.init(name: "Animation")
    }

    internal func registerToAnimationController(controller: AnimationController) {
        guard animationController != controller else {
            fatalError("Unable to register specified animation '\(name)' because it is already registered.")
        }
        animationController = controller
    }

    internal func unregisterToAnimationController(controller: AnimationController) {
        guard animationController == controller else {
            fatalError("Unable to unregister specified animation '\(name)' because it isn't registered to an AnimationController.")
        }
        animationController = nil
    }

    public func update(deltaTime: Double) {
        guard isPlaying || isPaused else {
            return
        }

        elapsedTime += deltaTime
        
        if state == .pending {
            let currentDelay = (cycle == 0) ? delay : repeatDelay
            // keep time within time bounds
            time = max(0, min(currentDelay, time + deltaTime))

            if time >= currentDelay {
                state = .playing
                time = isReversed
                  ? duration
                  : 0
                completedDelay = true
            }
        } else if state == .playing {
            let progress = (isReversed ? duration - time : time) / duration
            guard repeatStyle.shouldContinue(count: Double(cycle) + progress) else {
                complete()
                return
            }

            seek(progress: time / duration)

            time = max(0, min(duration, time + (isReversed ? -deltaTime : deltaTime)))
            if !isReversed && time >= duration || isReversed && time <= 0 {
                cycle += 1
                isReversed = (direction.alternates ? !isReversed : isReversed)
                if repeatDelay != 0 {
                    state = .pending
                    time = 0
                    completedDelay = false
                } else {
                    time = isReversed
                      ? duration
                      : 0
                }
            } else if state == .idle && time >= duration {
                complete()
            }
        }
    }

    internal func seek(progress: Double) {
        fatalError("seek method invoked on Animation.")
    }

    internal func complete() {
        terminate()
        state = .completed
        
        if let completionHandler = completionHandler {
            completionHandler(self)
        }
    }

    internal func reset() {
        completedDelay = false
        time = 0
        elapsedTime = 0
        state = .idle
        cycle = 0
        isReversed = direction.startInReverse
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
    /// If animation is already playing, it won't affect it.
    public func play() {
        if let animationController = animationController,
           !isPlaying {
            reset()
            state = .pending
            animationController.run(animation: self)
        }
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
        reset()
        play()
    }

    /// Stops the animation.
    public func terminate() {
        if let animationController = animationController {
            reset()
            animationController.remove(animation: self)
        }
    }
}
