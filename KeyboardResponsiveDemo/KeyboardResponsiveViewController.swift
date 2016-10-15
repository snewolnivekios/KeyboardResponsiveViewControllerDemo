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


// MARK: - Keyboard Responsive View Controller Extension

extension UIViewController {

  /// Returns the text field currently identified as the view's first responder, or `nil` if there is no such first responder.
  func activeTextField(view: UIView?) -> UITextField? {

    if (view?.isFirstResponder) == true {
      return view as? UITextField
    }

    for view in view!.subviews {
      if let atf = activeTextField(view: view) {
        return atf
      }
    }

    return nil
  }


  /// In response to keyboard presentation, animates the active text field into view if obscured by the keyboard.
  func keyboardWillShow(_ notification: NSNotification) {

    // The distance between the bottom of the text field and the top of the keyboard
    let gap: CGFloat = 20

    if let activeTextField = activeTextField(view: view),
      let kbFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

      let tfFrame = activeTextField.superview!.convert(activeTextField.frame, to: view)
      let tfY = tfFrame.origin.y + tfFrame.size.height + gap
      let kbY = kbFrame.origin.y
      let deltaY = min(kbY - tfY, 0)
      var vwFrame = view.frame
      vwFrame.origin.y += deltaY - vwFrame.origin.y

      UIView.animate(withDuration: 0.5) {
        self.view.frame = vwFrame
      }
    }
  }


  /// In response to keyboard presentation, animates the view back to its original position.
  func keyboardWillHide(_ notification: NSNotification) {
    var vwFrame = view.frame
    vwFrame.origin.y = 0
    UIView.animate(withDuration: 0.5) {
      self.view.frame = vwFrame
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
}
