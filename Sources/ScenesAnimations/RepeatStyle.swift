/// Defines how many iterations an `Animation` will cycle through before stopping.
public enum RepeatStyle {
    /// Plays through one cycle and then stops (no repeats).
    case none
    /// Repeats forever until `Animation` is explicitly stopped or cancelled.
    case forever
    /// Repeats for specified number of cycles and stops.
    case count(Int)

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
