//
//  KeyboardResponsiveViewController.swift
//  KeyboardResponsiveDemo
//
//  Copyright © 2016 Kevin L. Owens. All rights reserved.
//
//  KeyboardResponsiveDemo is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  KeyboardResponsiveDemo is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with KeyboardResponsiveDemo.  If not, see <http://www.gnu.org/licenses/>.
//

import UIKit

/// A view controller that animates the active text field into view if obscured by the keyboard.
class KeyboardResponsiveViewController: UIViewController, UITextFieldDelegate {
  
  /// The text field currently identified as the view's first responder, or `nil` if there is no such first responder.
  var activeTextField: UITextField?


  /// Records the given `textField` as the one that is currently active.
  func textFieldDidBeginEditing(_ textField: UITextField) {
    activeTextField = textField
  }


  /// Records the absence of any currently active text field.
  func textFieldDidEndEditing(_ textField: UITextField) {
    activeTextField = nil
  }


  /// In response to keyboard presentation, animates the active text field into view if obscured by the keyboard, and adds a tap gesture recognizer to dismiss the keyboard.
  func keyboardWillShow(_ notification: NSNotification) {

    // The distance between the bottom of the text field and the top of the keyboard
    let gap: CGFloat = 20

    if let activeTextField = activeTextField,
      let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

      // Calculate delta between upper boundary of keyboard and lower boundary of text field
      let textFieldFrame = activeTextField.superview!.convert(activeTextField.frame, to: view)
      let textFieldBound = textFieldFrame.origin.y + textFieldFrame.size.height + gap
      let keyboardBound = keyboardFrame.origin.y
      let viewShift = min(keyboardBound - textFieldBound, 0) // Don't shift if keyboard doesn't cross text field boundary

      // Shift the view
      var viewFrame = view.frame
      viewFrame.origin.y += viewShift - viewFrame.origin.y // Account for previous shift
      UIView.animate(withDuration: 0.5) {
        self.view.frame = viewFrame
      }
    }

    // Add tap gesture recognizer to dismiss keyboard
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
    view.addGestureRecognizer(tapGestureRecognizer)
  }


  /// In response to keyboard dismissal, animates the view back to its original position, and removes the previously added tap gesture recognizer to dismiss the keyboard.
  func keyboardWillHide(_ notification: NSNotification) {

    // Reset the view position
    var vwFrame = view.frame
    vwFrame.origin.y = 0
    UIView.animate(withDuration: 0.5) {
      self.view.frame = vwFrame
    }

    // Remove tap gesture recognizer
    if let tapGestureRecognizers = view.gestureRecognizers?.flatMap( {$0 as? UITapGestureRecognizer} ) {
      for gr in tapGestureRecognizers {
        gr.removeTarget(self, action: #selector(dismissKeyboard(_:)))
      }
    }
  }


  /// Enables keyboard responsiveness to text fields, animating the view such that the currently active text field is not obscured by the keyboard. Call this method from `viewDidAppear(_:)`.
  ///
  /// - important: This method should be paired with `deactivateKeyboardResponsiveTextFields()`, calling in `viewWillDisappear()`.
  func activateKeyboardResponsiveTextFields() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }


  /// Disables keyboard responsiveness to text fields. Call this method from `viewWillDisappear()`.
  ///
  /// - important: Not calling this method before the view disappears will leave it receiving the keyboard notifications it uses to affect responsiveness until it is deallocated.
  ///
  /// Consider also paring a call to this method with a call to `view.endEditing()`. Doing so will ensure the keyboard properly animates when segueing between views.
  func deactivateKeyboardResponsiveTextFields() {
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }


  /// Dismisses the keyboard in response to a tap gesture.
  func dismissKeyboard(_ sender: UITapGestureRecognizer) {
    view.endEditing(true)
  }


  /// Activates keyboard responsiveness to text fields.
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    activateKeyboardResponsiveTextFields()
  }


  /// Deactivates keyboard responsiveness to text fields.
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillAppear(animated)
    view.endEditing(true) // ensure smooth keyboard presentation
    deactivateKeyboardResponsiveTextFields()
  }
}
