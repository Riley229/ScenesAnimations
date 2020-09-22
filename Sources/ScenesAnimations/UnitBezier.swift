import Foundation
import Igis
// Reference: https://opensource.apple.com/source/WebCore/WebCore-955.66/platform/graphics/UnitBezier.h

internal struct UnitBezier {
    var pointA : DoublePoint
    var pointB : DoublePoint
    var pointC : DoublePoint

    init(controlPoint1: DoublePoint, controlPoint2: DoublePoint) {
        pointC = DoublePoint(x: controlPoint1.x * 3, y: controlPoint1.y * 3)
        pointB = DoublePoint(x: controlPoint2.x * 3, y: controlPoint2.y * 3) - pointC - pointC
        pointA = DoublePoint(x: 1, y: 1) - pointC - pointB
    }

    func sampleCurveX(time: Double) -> Double {
        return pointA.x * pow(time, 3) + pointB.x * pow(time, 2) + pointC.x * time
    }

    func sampleCurveY(time: Double) -> Double {
        return pointA.y * pow(time, 3) + pointB.y * pow(time, 2) + pointC.y * time
    }

    func sampleCurveDerivativeX(time: Double) -> Double {
        return 3 * pointA.x * pow(time, 2) + 2 * pointB.x * time + pointC.x
    }

    func solveCurveX(x: Double) -> Double {
        // Firstly try a few iterations of Newton's method -- normally very fast.
        do {
            var time = x
            for _ in 0..<8 {
                let sampleX = sampleCurveX(time: time) - x
                if abs(sampleX) < 1e-4 {
                    return time
                }

                let sampleDerivativeX = sampleCurveDerivativeX(time: time)
                if abs(sampleX) < 1e-6 {
                    break
                }
                
                time = time - sampleX / sampleDerivativeX
            }
        }

        // Fall back to the bisection method for reliability.
        do {
            var time0 = 0.0
            var time1 = 1.0
            var time = x

            if time < time0 {
                return time0
            } else if time > time1 {
                return time1
            }

            while time0 < time1 {
                let sampleX = sampleCurveX(time: time)
                if abs(sampleX - x) < 1e-4 {
                    return time
                } else if x > sampleX {
                    time0 = time
                } else {
                    time1 = time
                }

                time = (time1 - time0) * 0.5 + time0
            }

            // Failure.
            return time
        }
    }
    
    func solve(for progress: Double) -> Double {
        return sampleCurveY(time: solveCurveX(x: progress))
    }
}
