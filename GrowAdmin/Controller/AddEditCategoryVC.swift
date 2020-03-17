//
//  AddEditCategoryVC.swift
//  GrowAdmin
//
//  Created by Hiya Shah on 2/23/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class AddEditCategoryVC: UIViewController {
    @IBOutlet weak var nameTxt: UITextField!
    
    @IBOutlet weak var categoryImg: RoundedImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var addBtn: UIButton!
    
    var categoryToEdit : Category?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped(_:)))
        tap.numberOfTapsRequired = 1
        categoryImg.isUserInteractionEnabled = true;
        categoryImg.addGestureRecognizer(tap)
        
        //if we are editing categoryToEdit will not be nil
        if let category = categoryToEdit {
            nameTxt.text = category.name
            addBtn.setTitle("Save Changes", for: .normal)
            if let url = URL(string: category.imgUrl){
                categoryImg.contentMode = .scaleAspectFill
                categoryImg.kf.setImage(with: url)
            }
        }
    }
    
    @objc func imgTapped(_ tap: UITapGestureRecognizer){
        launchImagePicker()
        
    }
    
    @IBAction func addCategoryClicked(_ sender: Any) {
        
        uploadImageThenDocument()
        
    }
    
    func uploadImageThenDocument(){
        guard let image = categoryImg.image ,
            let categoryName = nameTxt.text , categoryName.isNotEmpty else {
                simpleAlert(title: "Error", msg: "must add category image and name")
                return
        }
        activityIndicator.startAnimating()
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {return}
        let imageRef = Storage.storage().reference().child("/categoryImages/\(categoryName).jpg")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload image")
                return
            }
            imageRef.downloadURL { (url, error) in
                if let error = error {
                    self.handleError(error: error, msg: "Unable to retrieve image url")
                    return
                }
                
                guard let url = url else {return}
                self.uploadDocument(url: url.absoluteString)
            }
        }
        
    }
    
    func uploadDocument(url: String) {
        var docRef: DocumentReference!
        var category = Category.init(name: nameTxt.text!, id: "", imgUrl: url, timeStamp: Timestamp())
        
        
        if let categoryToEdit = categoryToEdit {
            
            //we are editing
            docRef = Firestore.firestore().collection("categories").document(categoryToEdit.id)
            category.id = categoryToEdit.id
            
        } else {
            //new category
            docRef = Firestore.firestore().collection("categories").document()
            category.id = docRef.documentID
        }

        let data = Category.modelToData(category: category)
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload new category to Firestore")
                return
            }
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func handleError(error: Error, msg: String){
        debugPrint(error.localizedDescription)
        self.simpleAlert(title: "Error", msg: msg)
        self.activityIndicator.stopAnimating()
    }
    
    
}

extension AddEditCategoryVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImagePicker(){
        let imagePicker = UIImagePickerController();
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
        categoryImg.contentMode = .scaleAspectFill
        categoryImg.image = image
        dismiss(animated: true, completion: nil)
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
