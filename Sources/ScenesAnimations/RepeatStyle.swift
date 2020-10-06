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

/// Used to define how many iterations an `Animation` cycles through before completion.
public enum RepeatStyle {
    /// Repeats forever until `Animation` is explicitly stopped or cancelled.
    case forever
    /// Repeats specified number of cycles and completes.
    case count(Double)
    /// Repeats until the specified closure returns true.
    case until(() -> Bool)

    /// Repeats specified number of cycles and completes.
    public static func count(_ count: Int) -> RepeatStyle {
        return .count(Double(count))
    }

    // tells animation whether or not it should keep going for the given progress.
    internal func shouldContinue(count: Double) -> Bool {
        switch self {
        case .forever:
            return true
        case .count(let checkingCount):
            return checkingCount > count
        case .until(let stop):
            return !stop()
        }
    }
}
