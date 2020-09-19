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

// ******** MARK: integer type conformance ********
// NOT YET IMPLEMENTED.

// ******** MARK: Igis conformance ********
// NOT YET IMPLEMENTED.
