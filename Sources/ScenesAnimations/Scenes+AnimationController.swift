import Scenes

extension Director {
    public var animationController : AnimationController {
        return AnimationController.forDirector(self)
    }
}

extension Scene {
    public var animationController : AnimationController {
        return director.animationController
    }
}

extension Layer {
    public var animationController : AnimationController {
        return director.animationController
    }
}

extension RenderableEntity {
    public var animationController : AnimationController {
        return director.animationController
    }
}
