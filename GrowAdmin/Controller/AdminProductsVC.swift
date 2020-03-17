//
//  AdminProductsVC.swift
//  GrowAdmin
//
//  Created by Hiya Shah on 3/12/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import UIKit

class AdminProductsVC: ProductsVC {

    
    var selectedProduct : Product?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let editCategoryBtn = UIBarButtonItem(title: "Edit Category", style: .plain, target: self, action: #selector(editCategory))
        let newProductBtn = UIBarButtonItem(title: "+ Product", style: .plain, target: self, action: #selector(newProduct))
        navigationItem.setRightBarButtonItems([editCategoryBtn,newProductBtn], animated: false)
    }
    
    @objc func editCategory(){
        performSegue(withIdentifier: Segues.ToEditCategory, sender: self)
    }
    
    @objc func newProduct(){
        performSegue(withIdentifier: Segues.ToAddEditProduct, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //editing product
        selectedProduct = products[indexPath.row]
        performSegue(withIdentifier: Segues.ToAddEditProduct, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.ToAddEditProduct {
            if let destination = segue.destination as? AddEditProductsVC {
                destination.selectedCategory = category
                destination.productToEdit = selectedProduct
            }
        } else if segue.identifier == Segues.ToEditCategory {
            if let destination = segue.destination as? AddEditCategoryVC {
                destination.categoryToEdit = category
            }
        }
    }

}
