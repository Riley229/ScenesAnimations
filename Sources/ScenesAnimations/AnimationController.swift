import Foundation
import Scenes

public class AnimationController : EventHandlerShell, FrameUpdateHandler {
    private var runningAnimations : [Animation]
    private var currentTime : Date
    private var isRunning : Bool
    private static var activeControllers : [String : AnimationController] = [:]

    internal init() {
        runningAnimations = [Animation]()
        currentTime = Date()
        isRunning = false

        super.init(name: "AnimationController")
    }

    public func register(animation: Animation) {
        animation.registerAnimationController(self)
    }

    public func onFrameUpdate(framesPerSecond: Int) {
        if isRunning {
            // calculate time since last frame update.
            let newTime = Date()
            let frameTime = newTime.timeIntervalSince(currentTime)
            currentTime = newTime
            
            for animation in runningAnimations {
                animation.update(deltaTime: frameTime)
            }
        }
    }

    internal func remove(animation: Animation) {
        // removes all occurences of an animation (should only be one)
        runningAnimations.removeAll() {
            animation == $0
        }

        if runningAnimations.isEmpty {
            pause()
        }
    }

    internal func run(animation: Animation) {
        guard !runningAnimations.contains(animation) else {
            print("WARNING: Animation \(animation.animationId) tried to play, but is already running.")
            return
        }
        runningAnimations.append(animation)
        
        if !isRunning {
            resume()
        }
    }

    internal func pause() {
        isRunning = false
    }

    internal func resume() {
        isRunning = true
        currentTime = Date()
    }

    internal static func forDirector(_ director: Director) -> AnimationController {
        if let animationController = activeControllers[director.name] {
            return animationController
        } else {
            let animationController = AnimationController()
            activeControllers[director.name] = animationController
            director.dispatcher.registerFrameUpdateHandler(handler: animationController)
            return animationController
        }
    }
}
