import Foundation

/// Handles the queuing and updating of registered `Animation`s.
public class AnimationManager {
    private var runningAnimations : [Animation] = []
    private var animationsPendingRemoval : [Animation] = []
    private var currentTime = Date()

    public init() {
    }
    
    internal func remove(animation: Animation) {
        guard let index = runningAnimations.firstIndex(of: animation) else {
            assert(false, "Animation marked for removal is not registered to AnimationManager.")
        }
        
        runningAnimations.remove(at: index)
    }

    public func update() {
        // remove all completed animations.
        for _ in 0..<animationsPendingRemoval.count {
            remove(animation: animationsPendingRemoval.removeFirst())
        }
        
        // calculate time since last frame update.
        let newTime = Date()
        let frameTime = newTime.timeIntervalSince(currentTime)
        currentTime = newTime
        
        // if an animation is completed, append it to removal list, otherwise update it.
        for animation in runningAnimations {
            animation.update(frameTime: frameTime)
          
            if animation.state == .completed {
                animationsPendingRemoval.append(animation)
            }
        }
    }

    @available(*, deprecated, message: "Use `apply` method within `EasingStyle` instead.")
    public func getValue(ease: EasingStyle, percent: Double) -> Double {
        return ease.apply(progress: percent)
    }

    /// Adds a new `Animation` to running animations.
    /// - Parameters:
    ///   - animation: The `Animation` to run.
    ///   - autoPlay: Whether to automatically begin playing the animation upon registering or not.
    public func run(animation: Animation, autoPlay: Bool = true) {
        if animation.state == .completed {
            animation.state = .idle
        } else {
            // make sure animation isn't already registered.
            guard !runningAnimations.contains(animation) else {
                assert(false, "Cannot run an Animation already registered to AnimationManager.")
            }
        }
        runningAnimations.append(animation)
        
        if autoPlay {
            animation.play()
        }
    }

    // /// Invokes terminate() on all running `Animation`s.
    // public func terminateAll() {
    //     for animation in runningAnimations {
    //         animation.terminate()
    //     }
    // }

    // /// Invokes pause() on all running `Animation`s.
//     public func pauseAll() {
//         for animation in runningAnimations {
//             animation.pause()
//         }
//     }

//     /// Invokes play() on all running `Animation`s.
//     public func playAll() {
//         for animation in runningAnimations {
//             animation.play()
//         }
//     }

//     /// Invokes restart() on all running `Animation`s.
//     public func restartAll() {
//         for animation in runningAnimations {
//             animation.restart()
//         }
//     }
// }
}
