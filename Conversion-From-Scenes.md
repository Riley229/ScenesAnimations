# Conversion From Scenes

This document describes the steps necessary to convert projects using the animation components previously available in Scenes version 1.0.12 to the new ScenesAnimations library.  Be sure to read through the ScenesAnimations documentation [README](./README.md) before proceeding.

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

### Import ScenesAnimation into necessary files

For all files containing or referencing animation components, import the ScenesAnimations library at the top of the file:

```swift
import ScenesAnimations
```

## Update Project

Now that you have copied your project and imported the ScenesAnimations library, simply go through each file and correct the highlighted errors.  Read the error messages as they will contain all the information necessary to update your project, such as new variable names, or new substitues for previous systems.
