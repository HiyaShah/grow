//
//  ForgotPasswordVC.swift
//  Grow
//
//  Created by Hiya Shah on 2/9/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var resetPassBtn: RoundedButton!
    @IBOutlet weak var cancelButton: RoundedButton!
    
    @IBOutlet weak var emailTxtField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func resetPassClicked(_ sender: Any) {
        guard let email = emailTxtField.text , email.isNotEmpty
             else {
                simpleAlert(title: "Error", msg: "Please fill out the email field :)")
                return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
              if let error = error {
                  debugPrint(error)
                  Auth.auth().handleFireAuthError(error: error, vc: self)
                  return
              }
          self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func cancelClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
