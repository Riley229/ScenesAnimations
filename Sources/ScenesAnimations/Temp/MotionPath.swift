import Igis

public class MotionPath {
    enum Component {
        case move(to: Point)
        case line(from: Point, to: Point)
        case quadraticCurve(from: Point, control: Point, to: Point)
        case bezierCurve(from: Point, control1: Point, control2: Point, to: Point)
    }
    var pathComponents : [Component] = []
    
    public init(path: Path) {
        var previousPoint = Point()
        var originPoint = Point()
        
        for action in path.actions {
            switch action {
            case .beginPath:
                break
            case .moveTo(let point):
                pathComponents.append(.move(to: point))
                previousPoint = point
            case .lineTo(let point):
                pathComponents.append(.line(from: previousPoint, to: point))
                previousPoint = point
            case .rect(let rect):
                pathComponents.append(.move(to: rect.topLeft))
                pathComponents.append(.line(from: rect.topLeft, to: rect.bottomLeft))
                pathComponents.append(.line(from: rect.bottomLeft, to: rect.bottomRight))
                pathComponents.append(.line(from: rect.bottomRight, to: rect.topRight))
                pathComponents.append(.line(from: rect.topRight, to: rect.topLeft))
                previousPoint = rect.topLeft
            // case .arc(let center, let radius, let startAngle, let endAngle, let antiClockwise):
            //     print("arc not yet convertible")
            // case .arcTo(let controlPoint1, let controlPoint2, let radius):
            //     print("arcTo not yet convertible")
            case .quadraticCurveTo(let controlPoint, let endPoint):
                pathComponents.append(.quadraticCurve(from: previousPoint, control: controlPoint, to: endPoint))
                previousPoint = endPoint
            case .bezierCurveTo(let controlPoint1, let controlPoint2, let endPoint):
                pathComponents.append(.bezierCurve(from: previousPoint, control1: controlPoint1, control2: controlPoint2, to: endPoint))
                previousPoint = endPoint
            case .closePath:
                pathComponents.append(.line(from: previousPoint, to: originPoint))
                previousPoint = originPoint
            default:
                break
            }
        }

        while case .move = pathComponents.first {
            pathComponents.removeFirst()
        }
    }
}
// public struct BezierCurve {
//     var controlPoints: [DoublePoint]

//     public init(controlPoints: [DoublePoint]) {
//         self.controlPoints = controlPoints
//     }

//     public func solve(for progress: Double) -> DoublePoint {
//         let count = Double(controlPoints.count)
//         var outputPoint = DoublePoint(x: 1 * pow(progress, count), y: 1 * pow(progress, count))

//         print("yay")
//         for (index, point) in controlPoints.enumerated() {
//             let multiplier = (count / Double(index)) * pow(1 - progress, count - Double(index)) * pow(progress, Double(index))
//             outputPoint += DoublePoint(x: point.x * multiplier, y: point.y * multiplier)
//         }

//         print("nay")
//         return outputPoint
//     }
// }
