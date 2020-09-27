# Conversion From Scenes 1.0.12

This document describes the steps necessary to convert projects using the animation library previously available through Scenes in version 1.0.12 to use the new ScenesAnimations library.  Be sure to read through the ScenesAnimations documentation [README](./README.md) before proceeding.

## Setup

### Naming Conventions

- We'll assume that your existing project is called "OldProjectName".
- We'll assume that your new project name is called "NewProjectName".
- We'll further assume that these projects share a common parent directory.

### Start by cloning a new project of the current ScenesShell

```shell
git clone https://github.com/TheCoderMerlin/ScenesShell NewProjectName
```

### Protect the SceneShell source files in NewProjectName

```shell
cd NewProjectName/Sources/ScenesShell
rename 's/swift/swift.org/' *.swift
```

### Copy the source files from OldProjectName to NewProjectName

```shell
cp -r ../../../OldProjectName/Sources/ScenesShellD/*.swift .
```

## Import the ScenesAnimations library to NewProjectName

### Update dylib.manifest

```shell
ScenesAnimations         0.1.0
```

### build NewProjectName

```shell
rm .dir-locals.el
dylibEmacs
build
```

### Update Files as needed to include ScenesAnimations

```swift
import ScenesAnimations
```

## Edit references to AnimationManager (AnimationController)

### Update AnimationManager name

For all references to animationManager, change it to animationController.

```swift
// Change from:
animationManager.terminateAll()

// To:
animationController.terminateAll()
```

### Remove run() method and use play() directly on Animation

```swift
// Change from:
animationManager.run(animation: animation)

// To:
animationController.register(animation: animation)
animation.play()
```

### Remove references to getValue() method

Instead, use the apply() method available through EasingStyle

```swift
// Change from:
animationManager.getValue(ease: .linear, percent: 0.5)

// To:
EasingStyle.linear.apply(progress: 0.5)
```

### Remove references to inverse variable

The inverse variable is no longer available across the entire library due to its extremely specialized uses.

## Edit references to Animations

### Remove references to loop and reverse variables

```swift
// Change from:
animation.loop = true
animation.reverse = true

// To:
animation.repeatStyle = .forever
animation.direction = .alternate
```

### Remove references to inverse variable

The inverse variable is no longer available across the entire library due to its extremely specialized uses.

## Edit references to Tweenable (Interpolatable) types

### Update Tweenable name

If you directly reference Tweenable, change it to Interpolatable.

```swift
// Change from:
extension String : Tweenable

// To:
extension String : Interpolatable
```

### Update lerp() parameters

If you use the lerp() method, update the signature to include the renamed parameter:

```swift
// Change from:
point.lerp(to: Point(), percent: 0.8)

// To:
point.lerp(to: Point(), progress: 0.8)
```

### Update Conformance

If you provided conformance for a type, change it to include the new methods:

```swift
// Change from:
func lerp(to target: Self, percent: Double) -> Self
func interval(to target: Self) -> Double

// To:
func vectorize() -> [Double]
static func normalize(from vectors: [Double]) -> Self
```

These changes allow the library to automatically generate the interval() and lerp() methods for conforming types resulting in more consistent functionality.
