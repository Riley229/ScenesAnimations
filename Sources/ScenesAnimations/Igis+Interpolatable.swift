import Igis

// ******** MARK: Floating point type conformance ********
extension BinaryFloatingPoint {
    public func vectorize() -> [Double] {
        return [Double(self)]
    }

    public static func normalize(from vectors: [Double]) -> Self {
        return Self(vectors[0])
    }
}

extension Float : Interpolatable {}
extension Double : Interpolatable {}

// ******** MARK: Integer type conformance ********
extension BinaryInteger {
    public func vectorize() -> [Double] {
        return [Double(self)]
    }

    public static func normalize(from vectors: [Double]) -> Self {
        return Self(vectors[0])
    }
}

extension Int : Interpolatable {}
extension Int64 : Interpolatable {}
extension Int32 : Interpolatable {}
extension Int16 : Interpolatable {}
extension Int8 : Interpolatable {}
extension UInt : Interpolatable {}
extension UInt64 : Interpolatable {}
extension UInt32 : Interpolatable {}
extension UInt16 : Interpolatable {}
extension UInt8 : Interpolatable {}

// ******** MARK: Igis conformance ********
extension Point : Interpolatable {
    public func vectorize() -> [Double] {
        return x.vectorize() + y.vectorize()
    }

    public static func normalize(from vectors: [Double]) -> Point {
        return Point(x: Int.normalize(from: [vectors[0]]), y: Int.normalize(from: [vectors[1]]))
    }
}

extension DoublePoint : Interpolatable {
    public func vectorize() -> [Double] {
        return x.vectorize() + y.vectorize()
    }

    public static func normalize(from vectors: [Double]) -> DoublePoint {
        return DoublePoint(x: Double.normalize(from: [vectors[0]]), y: Double.normalize(from: [vectors[1]]))
    }
}

extension Size : Interpolatable {
    public func vectorize() -> [Double] {
        return width.vectorize() + height.vectorize()
    }

    public static func normalize(from vectors: [Double]) -> Size {
        return Size(width: Int.normalize(from: [vectors[0]]), height: Int.normalize(from: [vectors[1]]))
    }
}

extension Rect : Interpolatable {
    public func vectorize() -> [Double] {
        return topLeft.vectorize() + size.vectorize()
    }

    public static func normalize(from vectors: [Double]) -> Rect {
        return Rect(topLeft: Point.normalize(from: Array(vectors[0...1])), size: Size.normalize(from: Array(vectors[2...3])))
    }
}
