# Keyboard Responsive UIViewController Demo

This accompanies the blog post at http://ios.kevinlowens.com/keyboard-responsive-view-controller/.

Current as of Swift 3 Xcode 8.0.

Demonstrates how to extend `UIViewController` so that it is responsive to the keyboard, moving text fields into view when they would otherwise be obscured by it ... without requiring scroll views or other storyboard configurations.

Simply drop `KeyboardResponsiveViewController.swift` into your project and make calls to `activateKeyboardResponsiveTextFields()` and `deactivateKeyboardResponsiveTextFields()` in your `viewDidAppear()` and `viewWillDisappear()` methods, respectively. 

See the post for more information.
