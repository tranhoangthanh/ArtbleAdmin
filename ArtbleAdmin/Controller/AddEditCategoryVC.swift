//
//  AddEditCategoryVC.swift
//  ArtbleAdmin
//
//  Created by Trần Thành on 12/6/19.
//  Copyright © 2019 Trần Thành. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class AddEditCategoryVC: UIViewController {
    
    @IBOutlet weak var nameTf: UITextField!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addButton : UIButton!
    
    var categoryToEdit : Category?
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTap(_:)))
        tap.numberOfTapsRequired = 1
        categoryImage.isUserInteractionEnabled = true
        categoryImage.addGestureRecognizer(tap)
        
        
        //if we editing , categoryToEdit will != nil
        if let category = categoryToEdit {
            nameTf.text = category.name
            addButton.setTitle("Save Changes", for: .normal)
            if let url = URL(string: category.imgUrl) {
                categoryImage.contentMode = .scaleAspectFill
                categoryImage.kf.setImage(with: url)
            }
        }
    }
    
    
    
    @objc func imageTap(_ tap : UITapGestureRecognizer){
        launchImagePicker()
    }
    
    
    
    @IBAction func addCategoryClicked(_ sender: Any) {
       
        uploadImageThenDocument()
    }
    
    
    
    func uploadImageThenDocument(){
        
      
        guard let image = categoryImage.image , let categoryName = nameTf.text , categoryName.isNotEmpty else  {
            simpleAlert(title: "Error", msg: "Must add category and name")
            return
        }
        
        activityIndicator.startAnimating()
        //Step1 : Turn the image into Data
         //Step2 : Create an storage image reference -> A location in Firestorage for it to be stored.
        //Step 3 : Set the meta data.
         //step 4. : upload data.
          //step 5 : Once the image is uploaded , retrieve the dowload url
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {return}
        
        //Step2 : Create an storage image reference -> A location in Firestorage for it to be stored.
        
        let imageRef = Storage.storage().reference().child("/categoryImages/\(categoryName).jpg")
        
        //Step 3 : Set the meta data.
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        //step 4. : upload data
        
        imageRef.putData(imageData, metadata: metaData) { (metadata, error) in
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload image")
                return
            }
            //step 5 : Once the image is uploaded , retrieve the dowload url
            imageRef.downloadURL { (url, error) in
                if let error = error {
                    self.handleError(error: error, msg: "Unable to upload image")
                    return
                }
                guard let url = url else {return}
                print(url)
                //step 6 : Upload new Category document to the Firestore categories collection.
                self.uploadDocument(url: url.absoluteString)
            }
        }
    }
    
    fileprivate func handleError(error : Error , msg : String) {
        debugPrint(error.localizedDescription)
        self.simpleAlert(title: "Error" , msg: msg)
        self.activityIndicator.stopAnimating()
    }
    
    func uploadDocument(url : String){
        var docRef : DocumentReference!
        var category = Category(name: nameTf.text!, id: "", imgUrl: url, timeStamp: Timestamp())
        
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
                self.handleError(error: error, msg: "Unable to upload image")
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
}


extension AddEditCategoryVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {return}
        categoryImage.contentMode = .scaleToFill
        categoryImage.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func launchImagePicker(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
}
