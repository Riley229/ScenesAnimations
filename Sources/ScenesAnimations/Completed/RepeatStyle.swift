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
    /// Plays through one cycle and then completes (no repeats).
    case none
    /// Repeats forever until `Animation` is explicitly stopped or cancelled.
    case forever
    /// Repeats specified number of cycles and completes.
    case count(Int)

    // tells animation whether or not it should repeat for the given cycle count
    internal func shouldRepeat(for cycle: Int) -> Bool {
        switch self {
        case .none:
            return false
        case .forever:
            return true
        case .count(let count):
            return count > 0 && cycle < count
        }
    }
}
