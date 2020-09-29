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

// ********************************************************************************
// AnimationController
// ********************************************************************************

@available(swift, obsoleted: 5.2, renamed: "AnimationController")
public class AnimationManager {}

extension AnimationController {
    @available(swift, obsoleted: 5.2, message: "To use easing calculations, use the apply() method available through EasingStyle.")
    public func getValue(ease: EasingStyle, percent: Double) -> Double {
        return 0
    }

    @available(swift, obsoleted: 5.2, message: "To run an animation, register it to animation controller with register() method, then play it from the animation directly using play() method.")
    public func run(animation: Animation, autoPlay: Bool = true) {}
}

extension Director {
    @available(swift, obsoleted: 5.2, renamed: "animationController")
    public var animationManager : AnimationController {
        return AnimationController()
    }
}

extension Scene {
    @available(swift, obsoleted: 5.2, renamed: "animationController")
    public var animationManager : AnimationController {
        return AnimationController()
    }
}

extension Layer {
    @available(swift, obsoleted: 5.2, renamed: "animationController")
    public var animationManager : AnimationController {
        return AnimationController()
    }
}

extension RenderableEntity {
    @available(swift, obsoleted: 5.2, renamed: "animationController")
    public var animationManager : AnimationController {
        return AnimationController()
    }
}

// ********************************************************************************
// Animation
// ********************************************************************************

extension Animation {
    @available(swift, obsoleted: 5.2, message: "Animations don't need to be directly initialized, instead register the `Tween` directly with the `AnimationController`.")
    public convenience init(tween: Animation) {
        self.init(delay: 0, duration: 0, ease: .linear)
    }

    @available(swift, obsoleted: 5.2, message: "`inverse` is no longer available as an attribute of `Animation`.")
    public var inverse : Animation {
        return self
    }

    @available(swift, obsoleted: 5.2, message: "`isQueued` is no longer available as an attribute of `Animation`.")
    public var isQueued : Bool {
        return false
    }
}

// ********************************************************************************
// Tween
// ********************************************************************************

@available(swift, obsoleted: 5.2, message: "No longer needed as a wrapper for `Tween`, instead use `Animation` directly.")
public protocol TweenProtocol {}

// ********************************************************************************
// Interpolatable
// ********************************************************************************

@available(swift, obsoleted: 5.2, renamed: "Interpolatable")
public protocol Tweenable {}

extension Interpolatable {
    @available(swift, obsoleted: 5.2, message: "`percent` parameter changed to `progress`.")
    public func lerp(to target: Self, percent: Double) -> Self {
        return self.lerp(to: target, progress: percent)
    }
}

// ********************************************************************************
// EasingStyle
// ********************************************************************************

extension EasingStyle {
    @available(swift, obsoleted: 5.2, message: "`inverse` is no longer an available attribute of `EasingStyle`.")
    public var inverse : EasingStyle {
        return .linear
    }

    @available(swift, obsoleted: 5.2, renamed: "inPow")
    public static func configureInPow(exponent: Double) -> EasingStyle {
        return EasingStyle.inPow(exponent: exponent)
    }
    @available(swift, obsoleted: 5.2, renamed: "outPow")
    public static func configureOutPow(exponent: Double) -> EasingStyle {
        return EasingStyle.outPow(exponent: exponent)
    }
    @available(swift, obsoleted: 5.2, renamed: "inOutPow")
    public static func configureInOutPow(exponent: Double) -> EasingStyle {
        return EasingStyle.inOutPow(exponent: exponent)
    }

    @available(swift, obsoleted: 5.2, renamed: "inExpo")
    public static let inExponential = EasingStyle.inExpo
    @available(swift, obsoleted: 5.2, renamed: "outExpo")
    public static let outExponential = EasingStyle.outExpo
    @available(swift, obsoleted: 5.2, renamed: "inOutExpo")
    public static let inOutExponential = EasingStyle.inOutExpo
}
