//
//  ViewController.swift
//  Grow
//
//  Created by Hiya Shah on 1/18/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    fileprivate func presentLoginController() {
        let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryboardId.loginVC)
        present(controller, animated: true, completion: nil)
    }

}

