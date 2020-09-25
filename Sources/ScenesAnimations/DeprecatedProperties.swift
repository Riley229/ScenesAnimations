extension Animation {
    @available(swift, obsoleted: 5.2, message: "`inverse` is no longer available as an attribute of `Animation`.")
    public var inverse : Animation {
        return self
    }
}

extension EasingStyle {
    @available(swift, obsoleted: 5.2, message: "`inverse` is no longer available as an attribute of `EasingStyle`.")
    public var inverse : EasingStyle {
        return .linear
    }
}

@available(swift, obsoleted: 5.2, renamed: "Interpolatable")
public protocol Tweenable {}

extension Interpolatable {
    @available(*, deprecated, message: "`percent` parameter renamed to `interpolant`.")
    public func lerp(to target: Self, percent: Double) -> Self {
        return self.lerp(to: target, interpolant: percent)
    }
}
