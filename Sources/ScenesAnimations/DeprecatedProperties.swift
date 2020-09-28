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
// AnimationController
// ********************************************************************************

@available(swift, obsoleted: 5.2, renamed: "Interpolatable")
public protocol Tweenable {}

extension Interpolatable {
    @available(swift, obsoleted: 5.2, message: "`percent` parameter changed to `progress`.")
    public func lerp(to target: Self, percent: Double) -> Self {
        return self.lerp(to: target, progress: percent)
    }
}

// MARK: Animation
extension Animation {
    @available(swift, obsoleted: 5.2, message: "`inverse` is no longer available as an attribute of `Animation`.")
    public var inverse : Animation {
        return self
    }
}

// MARK: EasingStyle
extension EasingStyle {
    @available(swift, obsoleted: 5.2, message: "`inverse` is no longer available as an attribute of `EasingStyle`.")
    public var inverse : EasingStyle {
        return .linear
    }
}
