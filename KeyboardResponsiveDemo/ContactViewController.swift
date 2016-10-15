//
//  ContactViewController.swift
//  KeyboardResponsiveDemo
//
//  Copyright © 2016 Kevin L. Owens. All rights reserved.
//
//  BarsDemo is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  BarsDemo is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with KeyboardResponsiveDemo.  If not, see <http://www.gnu.org/licenses/>.
//

import UIKit

/// Manages data entry on the contact info view, submitting the form upon entry of the last field.
class ContactViewController: UIViewController, UITextFieldDelegate {

  @IBOutlet weak var messageTextView: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }


  /// Positions message text at the top of its content.
  override func viewWillLayoutSubviews() {
    messageTextView.layer.cornerRadius = 5
    messageTextView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
  }


  /// Advances to the next text field as identified by sequential and contiguous `tag` values, or segues to the next view if there is no follow-on tag.
  ///
  /// - parameter textField: The text field losing focus.
  ///
  /// - returns: `true` in all cases.
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let nextTextField = view.viewWithTag(textField.tag + 1) {
      nextTextField.becomeFirstResponder()
    } else {
      performSegue(withIdentifier: "securityInfo", sender: nil)
    }
    return true
  }


  /// Dismisses the keyboard in response to a tap gesture.
  ///
  /// - parameter sender: The tap gesture recognizer.
  @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
    view.endEditing(true)
  }
}

