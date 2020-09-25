/// The playback direction for an `Animation`.
public enum Direction {
    /// Plays forwards each animation cycle.
    case normal
    /// Plays backwards, or in reverse, each animation cycle.
    case reverse
    /// Reverses the playback direction each animation cycle with the first iteration being played forwards.
    case alternate
    /// Reverses the playback direction each animation cycle with the first iteration being player in reverse.
    case alternateReverse

    internal func isReversed(isReversed: Bool) -> Bool {
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
