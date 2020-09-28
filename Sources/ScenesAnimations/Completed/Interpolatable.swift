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

// Reference: https://en.wikipedia.org/wiki/Linear_interpolation

import Foundation

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
    ///   - progress: The progress, or interpolant value, to use (between 0 and 1).
    /// - Returns: A new instance interpolated from this instance towards the target instance.
    public func lerp(to target: Self, progress: Double) -> Self {
        let vectors = vectorize()
        let targetVectors = target.vectorize()
        var output : [Double] = []

        for (index, vector) in vectors.enumerated() {
            // calculate vector and target vector seperately to maintain better floating point accuracy
            // at 0 and 1 progress values.
            let interpolatedValue = (1 - progress) * vector + progress * targetVectors[index]
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
