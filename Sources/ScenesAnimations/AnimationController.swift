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

import Foundation
import Scenes

/// Responsible for updating all running `Animation`s.
public class AnimationController : EventHandler, FrameUpdateHandler {
    private var runningAnimations : [Animation]
    private var currentTime : Date
    private var isRunning : Bool
    private static var activeControllers : [String:AnimationController] = [:]

    // ********************************************************************************
    // Functions for internal use
    // ********************************************************************************
    
    internal init() {
        runningAnimations = [Animation]()
        currentTime = Date()
        isRunning = false

        super.init(name: "AnimationController")
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
        // check that animation isn't already running.
        guard !runningAnimations.contains(animation) else {
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

    // Finds the animationController assigned to the specified director.
    internal static func findAnimationController(forDirector director: Director) -> AnimationController {
        if let animationController = activeControllers[director.name] {
            return animationController
        } else {
            let animationController = AnimationController()
            activeControllers[director.name] = animationController
            director.dispatcher.registerFrameUpdateHandler(handler: animationController)
            return animationController
        }
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

    // ********************************************************************************
    // API FOLLOWS
    // ********************************************************************************

    /// Registers an `Animation` to the AnimationController so it can recieve updates.
    /// - Parameter animation: The `Animation` to register.
    public func register(animation: Animation) {
        animation.registerToAnimationController(animationController: self)
    }

    /// Registers an array of `Animation`s to the AnimationController so they can recieve updates.
    /// - Parameter animations: The `Animation`s to register.
    public func register(animations: [Animation]) {
        for animation in animations {
            animation.registerToAnimationController(animationController: self)
        }
    }

    /// Registers a list of `Animation`s to the AnimationController so they can recieve updates.
    /// - Parameter animations: The `Animation`s to register.
    public func register(animations: Animation...) {
        register(animations: animations)
    }

    /// Invokes terminate() on all running `Animation`s.
    public func terminateAll() {
        for animation in runningAnimations {
            animation.terminate()
        }
    }

    /// Invokes pause() on all running `Animation`s.
    public func pauseAll() {
        for animation in runningAnimations {
            animation.pause()
        }
    }

    /// Invokes play() on all running `Animation`s.
    public func playAll() {
        for animation in runningAnimations {
            animation.play()
        }
    }

    /// Invokes restart() on all running `Animation`s.
    public func restartAll() {
        for animation in runningAnimations {
            animation.restart()
        }
    }
}
