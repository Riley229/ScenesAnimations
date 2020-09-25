import Foundation
import Igis
// References:
// - https://easings.net/
// - https://developer.mozilla.org/en-US/docs/Web/CSS/easing-function

/// Used to specify the rate of change of a parameter over time.
public enum EasingStyle {
    /// Moves at a constant speed in a straight linear line.
    case linear

    /// Divides the domain of output values into a series of equidistant steps.
    /// - Parameter count: The number of steps to take.
    case steps(count: Int)

    /// Passes progress value through provided function to calculate interpolant.
    /// - Parameter interpolant: A function returning the interpolant value for a given progress value.
    case custom(interpolant: (Double) -> Double)

    /// Defines and uses a cubic bezier curve for the acceleration and decceleration.
    /// - Parameters:
    ///   - controlPoint1: The first controlPoint, or abscissus.  Values should be between 0 and 1.
    ///   - controlPoint2: The second controlPoint, or abscissus.  Values should be between 0 and 1.
    case bezier(controlPoint1: DoublePoint, controlPoint2: DoublePoint)

    /// Configurable exponential ease with in direction.
    /// - Parameter exponent: The exponent to use (ex: 2 would return a quadratic ease).
    case inPow(exponent: Double)
    /// Configurable exponential ease with out direction.
    /// - Parameter exponent: The exponent to use (ex: 2 would return a quadratic ease).
    case outPow(exponent: Double)
    /// Configurable exponential ease with inOut direction.
    /// - Parameter exponent: The exponent to use (ex: 2 would return a quadratic ease).
    case inOutPow(exponent: Double)

    case inSine
    case outSine
    case inOutSine

    case inExpo
    case outExpo
    case inOutExpo

    case inBack
    case outBack
    case inOutBack
    
    case inCirc
    case outCirc
    case inOutCirc
    
    case inBounce
    case outBounce
    case inOutBounce
    
    case inElastic
    case outElastic
    case inOutElastic

    /// Identical to `.linear`: moves at a constant speed in a straight linear line.
    public static var none = EasingStyle.linear

    public static var inQuad = EasingStyle.inPow(exponent: 2)
    public static var outQuad = EasingStyle.outPow(exponent: 2)
    public static var inOutQuad = EasingStyle.inOutPow(exponent: 2)

    public static var inCubic = EasingStyle.inPow(exponent: 3)
    public static var outCubic = EasingStyle.outPow(exponent: 3)
    public static var inOutCubic = EasingStyle.inOutPow(exponent: 3)

    public static var inQuart = EasingStyle.inPow(exponent: 4)
    public static var outQuart = EasingStyle.outPow(exponent: 4)
    public static var inOutQuart = EasingStyle.inOutPow(exponent: 4)

    public static var inQuint = EasingStyle.inPow(exponent: 5)
    public static var outQuint = EasingStyle.outPow(exponent: 5)
    public static var inOutQuint = EasingStyle.inOutPow(exponent: 5)

    /// Applies the progress value to `EasingStyle` and generates an interpolant value.
    /// - Parameter progress: The progress value to apply.
    /// - Returns: An interpolant represented by the specified `EasingStyle`.
    public func apply(progress: Double) -> Double {
        var progress = progress

        if progress <= 0 {
            return 0
        } else if progress >= 1 {
            return 1
        }

        switch self {
        case .linear:
            return progress

        case .steps(let count):
            return progress - progress.truncatingRemainder(dividingBy: 1 / Double(count))

        case .custom(let interpolant):
            return interpolant(progress)

        case .bezier(let controlPoint1, let controlPoint2):
            let bezier = UnitBezier(controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            return bezier.solve(for: progress)

        case .inPow(let exponent):
            return pow(progress, exponent)
        case .outPow(let exponent):
            return 1 - pow(1 - progress, exponent)
        case .inOutPow(let exponent):
            progress *= 2
            return progress < 1
              ? pow(progress * 2, exponent) / 2
              : 1 - pow(2 - progress * 2, exponent) / 2

        case .inSine:
            return 1 - cos(progress * Double.pi / 2)
        case .outSine:
            return sin(progress * Double.pi / 2)
        case .inOutSine:
            return (1 - cos(Double.pi * progress)) / 2

        case .inExpo:
            return pow(1024, progress - 1)
        case .outExpo:
            return 1 - pow(2, -10 * progress)
        case .inOutExpo:
            progress *= 2
            return progress < 1
              ? pow(1024, progress - 1) / 2
              : (-pow(2, -10 * (progress - 1)) + 2) / 2

        case .inBack:
            return pow(progress, 2) * (2.7 * progress - 1.7)
        case .outBack:
            return pow(progress - 1, 2) * (2.7 * (progress - 1) + 1.7) + 1
        case .inOutBack:
            progress *= 2
            return progress < 1
              ? (pow(progress, 2) * (3.5925 * (progress) - 2.5925)) / 2
              : (pow(progress - 2, 2) * (3.5925 * (progress - 2) + 2.5925)) / 2 + 1

        case .inCirc:
            return 1 - sqrt(1 - pow(progress, 2))
        case .outCirc:
            return sqrt(1 - pow(progress - 1, 2))
        case .inOutCirc:
            progress *= 2
            return progress < 1
              ? -(sqrt(1 - pow(progress, 2)) - 1) / 2
              : (sqrt(1 - pow(-progress + 2, 2)) + 1) / 2

        case .inBounce:
            return 1 - EasingStyle.outBounce.apply(progress: 1 - progress)
        case .outBounce:
            if progress < 1 / 2.75 {
                return 7.5625 * pow(progress, 2)
            } else if progress < 2 / 2.75 {
                return 7.5625 * pow(progress - 1.5 / 2.75, 2) + 0.75
            } else if progress < 2.5 / 2.75 {
                return 7.5625 * pow(progress - 2.25 / 2.75, 2) + 0.9375
            } else {
                return 7.5625 * pow(progress - 2.625 / 2.75, 2) + 0.984375
            }
        case .inOutBounce:
            progress *= 2
            return progress < 1
              ? EasingStyle.inBounce.apply(progress: progress) / 2
              : EasingStyle.outBounce.apply(progress: progress - 1) / 2 + 0.5
 
        case .inElastic:
            return -pow(2, 10 * progress - 10) * sin((progress * 10 - 10.75) * ((2 * Double.pi) / 3))
        case .outElastic:
            return pow(2, -10 * progress) * sin((progress * 10 - 0.75) * ((2 * Double.pi) / 3)) + 1
        case .inOutElastic:
            progress *= 2
            return progress < 1
              ? -(pow(2, 10 * progress - 10) * sin((10 * progress - 11.125) * ((Double.pi * 2) / 4.5))) / 2
              : (pow(2, -10 * progress + 10) * sin((10 * progress - 11.125) * ((Double.pi * 2) / 4.5))) / 2 + 1
        }
    }

    // ******** MARK: deprecated properties. ********
    @available(*, deprecated, renamed: "inPow")
    public static func configureInPow(exponent: Double) -> EasingStyle {
        return EasingStyle.inPow(exponent: exponent)
    }

    @available(*, deprecated, renamed: "outPow")
    public static func configureOutPow(exponent: Double) -> EasingStyle {
        return EasingStyle.outPow(exponent: exponent)
    }
    
    @available(*, deprecated, renamed: "inOutPow")
    public static func configureInOutPow(exponent: Double) -> EasingStyle {
        return EasingStyle.inOutPow(exponent: exponent)
    }

    @available(*, deprecated, renamed: "inExpo")
    public static let inExponential = EasingStyle.inExpo
    @available(*, deprecated, renamed: "outExpo")
    public static let outExponential = EasingStyle.outExpo
    @available(*, deprecated, renamed: "inOutExpo")
    public static let inOutExponential = EasingStyle.inOutExpo
}
