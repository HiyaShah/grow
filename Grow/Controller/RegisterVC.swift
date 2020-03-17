//
//  RegisterVC.swift
//  Grow
//
//  Created by Hiya Shah on 1/22/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class RegisterVC: UIViewController {
    //outlets
    
    @IBOutlet weak var usernameTxt: UITextField!
    
    @IBOutlet weak var confirmPassTxt: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var confirmPassCheckImg: UIImageView!
    @IBOutlet weak var passCheckImg: UIImageView!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
            passwordTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
            confirmPassTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
            // Do any additional setup after loading the view.
        }
        
        @objc func textFieldDidChange(_ textField: UITextField) {
            guard let passTxt = passwordTxt.text else { return }
            
            // If we have started typing int he confirm pass text field.
            if textField == confirmPassTxt {
                passCheckImg.isHidden = false
                confirmPassCheckImg.isHidden = false
            } else {
                if passTxt.isEmpty {
                    passCheckImg.isHidden = true
                    confirmPassCheckImg.isHidden = true
                    confirmPassTxt.text = ""
                }
            }
            
            // Make it so when the passwords match, the checkmarks turn green.
            if passwordTxt.text == confirmPassTxt.text {
                passCheckImg.image = UIImage(named: AppImages.GreenCheck)
                confirmPassCheckImg.image = UIImage(named: AppImages.GreenCheck)
            } else {
                passCheckImg.image = UIImage(named: AppImages.RedCheck)
                confirmPassCheckImg.image = UIImage(named: AppImages.RedCheck)
            }
        }
        
        @IBAction func registerClicked(_ sender: Any) {
            guard let email = emailTxt.text , email.isNotEmpty ,
                let username = usernameTxt.text , username.isNotEmpty ,
                let password = passwordTxt.text , password.isNotEmpty else {
                    simpleAlert(title: "Error", msg: "Please fill out all fields.")
                    return
            }
            
            guard let confirmPass = confirmPassTxt.text , confirmPass == password else {
                simpleAlert(title: "Error", msg: "Passwords do not match.")
                return
            }
            
            activityIndicator.startAnimating()
            
    //        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
    //            if let error = error {
    //                debugPrint(error)
    //                Auth.auth().handleFireAuthError(error: error, vc: self)
    //                return
    //            }
    //
    //            guard let firUser = result?.user else { return }
    //            let artUser = User.init(id: firUser.uid, email: email, username: username, stripeId: "")
    //            // Upload to Firestore
    //            self.createFirestoreUser(user: artUser)
    //        }
            

            guard let authUser = Auth.auth().currentUser else {
                return
            }

            let credential = EmailAuthProvider.credential(withEmail: email, password: password)

            authUser.link(with: credential) { (result, error) in
                if let error = error {
                    debugPrint(error)
                    Auth.auth().handleFireAuthError(error: error, vc: self)
                    return
                }
                
                guard let firUser = result?.user else { return }
                let artUser = User.init(id: firUser.uid, email: email, username: username, stripeId: "")
                // Upload to Firestore
                self.createFirestoreUser(user: artUser)
            }
        }
        
        func createFirestoreUser(user: User) {
            // Step 1: Create document reference
            let newUserRef = Firestore.firestore().collection("users").document(user.id)
            
            // Step 2: Create model data
            let data = User.modelToData(user: user)
            
            // Step 3: Upload to Firestore.
            newUserRef.setData(data) { (error) in
                if let error = error {
                    Auth.auth().handleFireAuthError(error: error, vc: self)
                    debugPrint("Error signing in: \(error.localizedDescription)")
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
                self.activityIndicator.stopAnimating()
            }
        }

}
