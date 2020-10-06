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

import Scenes

extension Director {
    /// The `AnimationController` associated with this director.
    public var animationController : AnimationController {
        return AnimationController.getAnimationController(forDirector: self)
    }
}

extension Scene {
    /// The `AnimationController` associated with this Scenes director.
    public var animationController : AnimationController {
        return director.animationController
    }
}

extension Layer {
    /// The `AnimationController` associated with this Layers director.
    public var animationController : AnimationController {
        return director.animationController
    }
}

extension RenderableEntity {
    /// The `AnimationController` associated with this RenderableEntities director.
    public var animationController : AnimationController {
        return director.animationController
    }
}
