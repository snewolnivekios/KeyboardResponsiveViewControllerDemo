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
class ContactViewController: UIViewController, TextFieldAdvancing {

  /// The segue activated when the user taps Enter on the last text field.
  var textFieldSegueIdentifier: String? = "securityInfo"

  /// Demo text view customized in `viewWillLayoutSubviews()`
  @IBOutlet weak var messageTextView: UITextView!


  /// Activates keyboard responsiveness to text fields.
  override func viewDidAppear(_ animated: Bool) {
    activateKeyboardResponsiveTextFields()
  }


  /// Deactivates keyboard responsiveness to text fields.
  override func viewWillDisappear(_ animated: Bool) {
    view.endEditing(true) // ensure smooth keyboard presentation
    deactivateKeyboardResponsiveTextFields()
  }


  /// Positions message text at the top of its content.
  override func viewWillLayoutSubviews() {
    messageTextView.layer.cornerRadius = 5
    messageTextView.setContentOffset(CGPoint(x: 0, y: 0), animated: false) // position the leading content at the top of the view
  }
}

