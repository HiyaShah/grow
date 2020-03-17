//
//  AddEditProductsVC.swift
//  GrowAdmin
//
//  Created by Hiya Shah on 3/12/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class AddEditProductsVC: UIViewController {

    
    @IBOutlet weak var productNameTxt: UITextField!
    
    @IBOutlet weak var productPriceTxt: UITextField!
    
    @IBOutlet weak var productDescTxt: UITextView!
    
    
    @IBOutlet weak var productImgView: RoundedImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var addBtn: RoundedButton!
    
    
    
    var selectedCategory: Category! //implicitly unwrapped
    var productToEdit: Product?
    var name = ""
    var price = 0.0
    var productDescription = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped))
        tap.numberOfTapsRequired = 1
        productImgView.isUserInteractionEnabled = true;
        productImgView.addGestureRecognizer(tap)
        
        //if we are editing productToEdit will not be nil
        if let product = productToEdit {
            productNameTxt.text = product.name
            productDescTxt.text = product.productDescription
            productPriceTxt.text = String(product.price)
            addBtn.setTitle("Save Changes", for: .normal)
            if let url = URL(string: product.imageUrl){
                productImgView.contentMode = .scaleAspectFill
                productImgView.kf.setImage(with: url)
            }
        }
    }
    
    @objc func imgTapped(){
        launchImagePicker()
        
    }
    

    @IBAction func addClicked(_ sender: Any) {
        uploadImageThenDocument()
    }
    
    func uploadImageThenDocument(){
        guard let image = productImgView.image ,
            let productName = productNameTxt.text , productName.isNotEmpty,
            let description = productDescTxt.text, description.isNotEmpty,
            let priceString = productPriceTxt.text,
                let price = Double(priceString) else {
                    simpleAlert(title: "Missing Fields", msg: "Please fill out all required missing fields.")
                    return
        }
        
        self.name = productName
        self.productDescription = description
        self.price = price
        
        activityIndicator.startAnimating()
        //turn image into data
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {return}
        
        //create storage img reference
        let imageRef = Storage.storage().reference().child("/productImages/\(productName).jpg")
        
        //set meta data
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        //upload the data
        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload image.")
                return
            }
            //once img is uploaded , retrive download url
            imageRef.downloadURL { (url, error) in
                if let error = error {
                    self.handleError(error: error, msg: "Unable to retrieve image url.")
                    return
                }
                
                //upload new product document to the firestore products collection
                guard let url = url else {return}
                print(url)
                self.uploadDocument(url: url.absoluteString)
            }
        }
        
    }
    
    func uploadDocument(url: String) {
            var docRef: DocumentReference!
            var product = Product.init(name: name, price: price, id: "", productDescription: productDescription, category: selectedCategory.id, imageUrl: url)
            
            
            if let productToEdit = productToEdit {
                //we are editing
                docRef = Firestore.firestore().collection("products").document(productToEdit.id)
                product.id = productToEdit.id
                
            } else {
                //new category
                docRef = Firestore.firestore().collection("products").document()
                product.id = docRef.documentID
            }

            let data = Product.modelToData(product: product)
            docRef.setData(data, merge: true) { (error) in
                if let error = error {
                    self.handleError(error: error, msg: "Unable to upload Firestore document")
                    return
                }
            }
            self.navigationController?.popViewController(animated: true)
        }
        
        func handleError(error: Error, msg: String){
            debugPrint(error.localizedDescription)
            self.simpleAlert(title: "Error", msg: msg)
            activityIndicator.stopAnimating()
        }
        
        
    }

    extension AddEditProductsVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        func launchImagePicker(){
            let imagePicker = UIImagePickerController();
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            guard let image = info[.originalImage] as? UIImage else { return }
            productImgView.contentMode = .scaleAspectFill
            productImgView.image = image
            dismiss(animated: true, completion: nil)
            
            
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
    

}
