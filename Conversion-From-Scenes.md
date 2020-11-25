# Conversion From Scenes

This document describes the steps necessary to convert projects using the animation components previously available in Scenes version 1.0.11 to the new ScenesAnimations library.  Be sure to read through the ScenesAnimations documentation [README](./README.md) before proceeding.

## Setup

### Naming Conventions

- We'll assume that your existing project is called "OldProject".
- We'll assume that your new project name is called "NewProject".
- We'll further assume that these projects share a common parent directory.

### Start by cloning a new project of the current ScenesShell

```shell
git clone https://github.com/TheCoderMerlin/ScenesShell NewProject
```

### Protect the SceneShell source files in NewProject

```shell
cd NewProject/Sources/ScenesShell
rename 's/swift/swift.org/' *.swift
```

### Copy the source files from OldProject to NewProject

```shell
cp -r ../../../OldProject/Sources/ScenesShellD/*.swift .
```

## Import the ScenesAnimations library to NewProject

### Update dylib.manifest

```shell
Igis                     1.3.5
Scenes                   1.1.0
ScenesAnimations         0.1.1
```

Then, in the shell type:

```shell
rm .dir-locals.el
dylibEmacs
```

### Import ScenesAnimation into necessary files

For all files containing or referencing animation components, import the ScenesAnimations library at the top of the file:

```swift
import ScenesAnimations
```

## Update Project

Now that you have copied your project and imported the ScenesAnimations library, you can simply work through each file ScenesAnimations is working in and correct the highlighted errors.  The error messages should contain all the necessary information for converting your project.  If further instruction is needed, refer to the following information.

### Edit references to AnimationManager (AnimationController)

#### Change the name of all references

Change references from the AnimationManager type and the animationManager variable to AnimationController and animationController respectively.

```swift
// Change from:
let manager = animationManager as AnimationManager

// To:
let controller = animationController as AnimationController
```

#### Remove references:

```swift
animationManager.run(animation: myAnimation, autoPlay: true)

animationManager.getValue(ease: .inOutQuad, percent: 0.5)
```

Instead use:

```swift
animationController.register(myAnimation)
myAnimation.play()

EasingStyle.inOutQuad.apply(progress: 0.5)
```

### Edit References to Animation

#### Change initialization:

Tween is now a type of Animation, so after creating a Tween, you can treat it directly as an animation:

```swift
// Change from:
let myTween = Tween(from:Point(), to:Point(x:100, y:100)) { self.myPoint = $0 }
let myAnimation = Animation(tween: myTween)
animationController.register(myAnimation)

// To:
let myAnimation = Tween(from:Point(), to:Point(x:100, y:100)) { self.myPoint = $0 }
animationController.register(myAnimation)
```

#### Remove References:

```swift
myAnimation.loop = true
myAnimation.reverse = true
```

Instead use:

```swift
myAnimation.repeatStyle = .forever
myAnimation.direction = .alternate
```

Also, note the `inverse` property was permanently removed.  Instead, you can reuse the same animation by simply changing its direction as needed:

```swift
// Change from:
mySecondAnimation = myAnimation.inverse

// To:
myAnimation.direction = .reverse
```

`isQueued` is no longer available.

### Tween

#### Remove references to TweenProtocol:

```swift
let tween = myTween as TweenProtocol
```

Tween now conforms to Animation as its non-generic type.

### Interpolatable (Tweenable)

#### Edit references to Tweenable

```swift
// Change from:
let point = myPoint as Tweenable

// To:
let point = myPoint as Interpolatable
```

#### Edit lerp() function parameters

```swift
// Change from:
let point = myPoint.lerp(to:Point(), percent:0.5)

// To:
let point = myPoint.lerp(to:Point, progress:0.5)
```

### EasingStyle

#### Update the following Styles

```swift
// Change from:
EasingStyle.configureInPow(exponent:9)
EasingStyle.configureOutPow(exponent:9)
EasingStyle.configureInOutPow(exponent:9)

// To:
EasingStyle.inPow(exponent:9)
EasingStyle.outPow(exponent:9)
EasingStyle.inOutPow(exponent:9)
```

```swift
// Change from:
EasingStyle.inExponential
EasingStyle.outExponential
EasingStyle.inOutExponential

// To:
EasingStyle.inExpo
EasingStyle.outExpo
EasingStyle.inOutExpo
```

Note, the `inverse` property was permanently removed.

### TweenSequence

TweenSequence has been temporarily removed.  It will be replaced with `Timeline` in the following updates.
