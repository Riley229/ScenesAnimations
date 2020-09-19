/// Any element that conforms to `Tweenable` can be utilized in a `Tween`.
public protocol Tweenable {
    /// Calculates a new element of certain percentage between this element and another.
    /// - Parameters:
    ///   - target: the target element of which to calculate the new element between.
    ///   - percent: value between 0 and 1 representing percentage.
    /// - Returns: A new element of percent between this element and a target element.
    func lerp(to target: Self, percent: Double) -> Self

    /// Calculates the interval between this element and another.
    /// - Parameters:
    ///   - target: The target element of which to calculate the interval.
    /// - Returns: The distance to a target element.
    func interval(to target: Self) -> Double
}
