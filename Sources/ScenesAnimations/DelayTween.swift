// Used for delays in TweenSequences.
internal class DelayTween : InternalTweenProtocol {
    let duration : Double

    init(duration: Double) {
        self.duration = duration
    }

    @available(swift, obsoleted: 5.2.4, message: "No longer available")
    var inverse : InternalTweenProtocol {
        return self
    }

    func update(progress: Double) {
    }
}
