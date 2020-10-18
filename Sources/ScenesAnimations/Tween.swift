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

/// A `Tween` allows the animation of components through a single calculated property.
public class Tween<TweenElement: Interpolatable> : Animation {
    /// An updateHandler is responsible for updating referenced properties with the calculated property.
    public typealias UpdateHandler<TweenElement: Interpolatable> = (TweenElement) -> ()

    private let startValue : TweenElement
    private let endValue : TweenElement

    internal var updateHandler : UpdateHandler<TweenElement>

    /// Creates a new `Tween` from the specified parameters.
    /// - Parameters:
    ///   - from: The starting value.
    ///   - to: The ending value.
    ///   - delay: The amount of delay to add at the beginning.
    ///   - duration: The amount of time for the animation to complete.
    ///   - ease: The `EasingStyle` to apply.
    ///   - update: The value to update.
    public init(from: TweenElement, to: TweenElement, delay: Double = 0, duration: Double = 1,
                ease: EasingStyle = .none, update: @escaping UpdateHandler<TweenElement>) {
        self.startValue = from
        self.endValue = to
        self.updateHandler = update
        super.init(delay: delay, duration: duration, ease: ease)
    }

    /// Creates a new `Tween` from the specified parameters.
    /// - Parameters:
    ///   - from: The starting value.
    ///   - to: The ending value.
    ///   - delay: The amount of delay to add at the beginning.
    ///   - speed: The speed for the animation to complete (in fps).
    ///   - ease: The `EasingStyle` to apply.
    ///   - update: The value to update.
    public convenience init(from: TweenElement, to: TweenElement, delay: Double = 0, speed: Double,
                            ease: EasingStyle = .none, update: @escaping UpdateHandler<TweenElement>) {
        var interval = from.interval(to: to)
        if interval < 0 {
            assert(false, "Distance returned from distance() in \(type(of: from)) must be positive.")
            interval = -interval
        }

        self.init(from: from, to: to, delay: delay, duration: interval / speed, ease: ease, update: update)
    }

    override func seek(progress: Double) {
        if state == .playing {
            let newValue = startValue.lerp(to: endValue, progress: ease.apply(progress: progress))
            updateHandler(newValue)
        }
    }
}
