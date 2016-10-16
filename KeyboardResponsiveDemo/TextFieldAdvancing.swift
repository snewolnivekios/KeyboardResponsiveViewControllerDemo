//
//  TextFieldAdvancing.swift
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

/// A conforming `UIViewController` gains a text field auto-advance functionality.
///
/// Provided the controller is registered as a `UITextFieldDelegate` for the active text field, the user tapping the Enter key (however it's labeled) will advance the focus to the next text field as identified by their `tag` values. For the last text field in the sequence, the controller will advance to the next scene via the segue given by `textFieldSegueIdentifier`.
///
/// - note: The text fields in the storyboard scene must be configured with sequential, contiguous Tag values. The controller must also be assigned as each text field's delegate.
@objc protocol TextFieldAdvancing: UITextFieldDelegate { // @objc designation required in order for conforming view controller to be recognized as a UITextFieldDelegate
  var textFieldSegueIdentifier: String? { get }
}

extension UIViewController {

  /// In response to the user tapping the Return key in a text field, calls upon `advanceFirstResponder(from:)`.
  ///
  /// - parameter textField: The text field currently assigned as the first responder.
  ///
  /// - returns: `true` in all cases.
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    advanceFirstResponder(from: textField)
    return true
  }


  /// Advances first responder to the next text field in the `tag` sequence. For the last text field in the sequence, advances to the next scene via the segue given by `textFieldSegueIdentifier`.
  ///
  /// - note: The text fields in the storyboard scene must be configured with sequential, contiguous Tag values.
  ///
  /// - parameter textField: The text field currently assigned as the first responder.
  func advanceFirstResponder(from textField: UITextField) {
    guard let vc = self as? TextFieldAdvancing else { return }
    if let nextTextField = view.viewWithTag(textField.tag + 1) {
      nextTextField.becomeFirstResponder()
    } else {
      if let textFieldSegueIdentifier = vc.textFieldSegueIdentifier {
        performSegue(withIdentifier: textFieldSegueIdentifier, sender: nil)
      }
    }
  }

}
