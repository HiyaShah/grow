//
//  ViewController.swift
//  GrowAdmin
//
//  Created by Hiya Shah on 1/18/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import UIKit

class AdminHomeVC: HomeVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem?.isEnabled = false
        
        let addCategoryBtn = UIBarButtonItem(title: "Add Category", style: .plain, target: self, action: #selector(addCategory))
        navigationItem.rightBarButtonItem = addCategoryBtn
    }

    @objc func addCategory() {
        //segue to add category view
        performSegue(withIdentifier: Segues.ToAddEditCategory, sender: self)
    }

}

