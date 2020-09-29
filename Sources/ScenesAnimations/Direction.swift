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

/// Defines the playback direction for an `Animation`.
public enum Direction {
    /// Plays forwards each animation cycle.
    case normal
    /// Plays backwards, or in reverse, each animation cycle.
    case reverse
    /// Reverses the playback direction each animation cycle with the first iteration being played forwards.
    case alternate
    /// Reverses the playback direction each animation cycle with the first iteration being player in reverse.
    case alternateReverse

    // tells animation whether or not it should start in reverse.
    internal func shouldStartReversed() -> Bool {
        switch self {
        case .normal, .alternate:
            return false
        case .reverse, .alternateReverse:
            return true
        }
    }
    
    // tells animation whether or not it should play the next cycle in reverse.
    internal func shouldPlayReversed(isReversed: Bool) -> Bool {
        switch self {
        case .normal:
            return false
        case .reverse:
            return true
        case .alternate, .alternateReverse:
            return !isReversed
        }
    }
}
