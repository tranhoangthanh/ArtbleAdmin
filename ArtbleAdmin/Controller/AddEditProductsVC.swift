//
//  AddEditProductsVC.swift
//  ArtbleAdmin
//
//  Created by Trần Thành on 12/6/19.
//  Copyright © 2019 Trần Thành. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class AddEditProductsVC: UIViewController {
    
    
    @IBOutlet weak var productImgView: UIImageView!
    @IBOutlet weak var productNameTf: UITextField!
    @IBOutlet weak var productPriceTf: UITextField!
    @IBOutlet weak var activityIndicatior: UIActivityIndicatorView!
    @IBOutlet weak var productDescriptionTextView: UITextView!
    @IBOutlet weak var addButton : UIButton!
    
    //Variable
    var selectedCategory : Category!
    var productToEdit : Product?
    
    var name = ""
    var price = 0.0
    var productDescription = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped))
        tap.numberOfTapsRequired = 1
        productImgView.isUserInteractionEnabled = true
        productImgView.addGestureRecognizer(tap)
        
        //if we editing , productToEdit will != nil
        if let product = productToEdit {
            productNameTf.text = product.name
            productDescriptionTextView.text = product.productDescription
            productPriceTf.text = String(product.price)
            addButton.setTitle("Save Change", for: .normal)
            if let url = URL(string: product.imageUrl) {
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
        guard let image = productImgView.image , let name = productNameTf.text , name.isNotEmpty , let description = productDescriptionTextView.text , description.isNotEmpty , let priceString = productPriceTf.text , let price = Double(priceString) else {
            simpleAlert(title: "Missing Fields", msg: "Please fill out all required fields.")
            return
        }
        
        self.name = name
        self.productDescription = description
        self.price = price
        
        activityIndicatior.startAnimating()
        //Step1 : Turn the image into Data
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {return}
        //Step2 : Create an storage image reference -> A location in Firestorage for it to be stored.
        let imageRef = Storage.storage().reference().child("/productImages/\(name).jpg")
        //Step 3 : Set the meta data.
        let metadata = StorageMetadata()
        metadata.contentType = "image/ipg"
        //step 4. : upload data.
        imageRef.putData(imageData, metadata: metadata) { (metaData, error) in
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload image.")
                return
            }
            //step 5 : Once the image is uploaded , retrieve the dowload url
            imageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    self.handleError(error: error, msg: "Unable to dowload url")
                    return
                }
                guard let url = url else {return}
                print(url)
                //step 6 : Upload new Category document to the Firestore categories collection.
                self.uploadDocument(url: url.absoluteString)
            })
        }
    }
    
    func uploadDocument(url :String){
        var docRef : DocumentReference!
        var product = Product(name: name, id: "", category: selectedCategory.id, price: price, productDescription: productDescription, imageUrl: url)
        
        if let productToEdit = productToEdit {
            //we are editing a product
            docRef = Firestore.firestore().collection("products").document(productToEdit.id)
            product.id = productToEdit.id
        } else {
            // we are add a new product
            docRef = Firestore.firestore().collection("products").document()
            product.id = docRef.documentID
        }
        
        let data = Product.modelToData(product: product)
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload Firestore document.")
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func handleError(error : Error , msg : String){
        debugPrint(error.localizedDescription)
        simpleAlert(title: "Error", msg: msg)
        activityIndicatior.stopAnimating()
    }
}

extension AddEditProductsVC : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func launchImagePicker(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard  let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        productImgView.contentMode = .scaleAspectFill
        productImgView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
