/*
 ScenesAnimations provides support for creating and running animations.
 ScenesAnimations runs on top of Scenes and IGIS.
 Copyright (C) 2020,2021 Camden Thomson
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

import Igis

// ********************************************************************************
// Numeral Types
// ********************************************************************************

extension BinaryFloatingPoint {
    public func vectorize() -> [Double] {
        return [Double(self)]
    }

    public static func normalize(from vectors: [Double]) -> Self {
        return Self(vectors[0])
    }
}

extension BinaryInteger {
    public func vectorize() -> [Double] {
        return [Double(self)]
    }

    public static func normalize(from vectors: [Double]) -> Self {
        return Self(vectors[0])
    }
}

extension Float : Interpolatable {}
extension Double : Interpolatable {}

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

// ********************************************************************************
// Igis
// ********************************************************************************

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

extension Alpha : Interpolatable {
    public func vectorize() -> [Double] {
        return alphaValue.vectorize()
    }

    public static func normalize(from vectors: [Double]) -> Alpha {
        return Alpha(alphaValue: Double.normalize(from: vectors))
    }
}

extension Color : Interpolatable {
    public func vectorize() -> [Double] {
        return hue.vectorize() + saturation.vectorize() + brightness.vectorize()
    }

    public static func normalize(from vectors: [Double]) -> Color {
        return Color(hue: Double.normalize(from: [vectors[0]]),
                     saturation: Double.normalize(from: [vectors[1]]),
                     brightness: Double.normalize(from: [vectors[2]]))
    }
}
