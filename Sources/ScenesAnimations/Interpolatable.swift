import Foundation
// Reference: https://en.wikipedia.org/wiki/Linear_interpolation

/// A type capable of being linearly interpolated between two values.
///
/// Types that conform to the `Interpolatable` protocol can be linearly interpolated between two
/// values using the lerp method.  Additionally, the interval method can be used to calculate the
/// interval (or distance) between two values.
///
/// Although the vectorize and normalize methods are also provided by conforming types, using them directly
/// is discouraged.
public protocol Interpolatable {
    /// Transforms this instance into an array of interpolatable vectors.
    /// - Returns: This instances interpolatable vectors.
    ///
    /// Calling this method directly is discouraged.
    func vectorize() -> [Double]

    /// Transforms an array of vectors into an instance of this type.
    /// - Parameter vectors: An array of vectors to normalize.
    /// - Returns: A new instance represented by the provided vectors.
    ///
    /// Calling this method directly is discouraged.
    static func normalize(from vectors: [Double]) -> Self
}

extension Interpolatable {
    /// Linearly interpolates this instance towards a target instance.
    /// - Parameters:
    ///   - target: The target instance.
    ///   - interpolant: The interpolant, or multiplier, to use (value between 0 and 1).
    /// - Returns: A new instance interpolated from this instance towards the target instance.
    public func lerp(to target: Self, interpolant: Double) -> Self {
        let vectors = vectorize()
        let targetVectors = target.vectorize()
        var output : [Double] = []

        for (index, vector) in vectors.enumerated() {
            // calculate vector and target vector seperately to maintain better floating point accuracy
            // at 0 and 1 interpolant values.
            let interpolatedValue = (1 - interpolant) * vector + interpolant * targetVectors[index]
            output.append(interpolatedValue)
        }

        return Self.normalize(from: output)
    }

    /// Calculates the interval to a target instance.
    /// - Parameter target: The target instance.
    /// - Returns: A Double value representing the interval, or distance, between this instance and the target instance.
    public func interval(to target: Self) -> Double {
        let intervalSquared = vectorize()
          .map { vector in pow(vector, 2) }
          .reduce(0, +)
        return sqrt(intervalSquared)
    }
}
