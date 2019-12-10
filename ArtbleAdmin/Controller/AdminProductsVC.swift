//
//  AdminProductsVC.swift
//  ArtbleAdmin
//
//  Created by Trần Thành on 12/6/19.
//  Copyright © 2019 Trần Thành. All rights reserved.
//

import UIKit
import Firebase

class AdminProductsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    //Variables
    var products = [Product]()
    var category : Category!
    var db : Firestore!
    var listener : ListenerRegistration!
    var seletedProduct : Product?
    
    fileprivate func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Identifier.ProductCell, bundle: nil), forCellReuseIdentifier: Identifier.ProductCell)
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        setupTableView()
        setupQuery()
    }
    
   

    @IBAction func editCategory(_ sender: Any) {
        
        performSegue(withIdentifier: Segues.ToEditCategory, sender: self)
        
    }
    @IBAction func newProduct(_ sender: Any) {
        performSegue(withIdentifier: Segues.ToAddEditProduct, sender: self)
    }
    
    func setupQuery(){
        self.listener = db.products(category: category.id).addSnapshotListener({ (snap, error) in
            if let error = error {
                debugPrint(error)
                return
            }
            snap?.documentChanges.forEach({ (change) in
                let data = change.document.data()
                let product = Product(data: data)
                switch change.type {
                case.added :
                    self.onDocumentAdded(change: change, product: product)
                case.modified :
                    self.onDocumentModified(change: change, product: product)
                case.removed :
                    self.onDocumentRemoved(change: change)
                }
            })
        })
    }
}

extension AdminProductsVC : UITableViewDelegate , UITableViewDataSource {
    
    func onDocumentAdded(change : DocumentChange , product : Product){
        let newIndex = Int(change.newIndex)
        products.insert(product, at: newIndex)
        tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .fade)
        
      }
    func onDocumentModified(change : DocumentChange , product : Product){
        if change.newIndex == change.oldIndex {
            // item changed  , but remained in the same position
            let index = Int(change.newIndex)
            products[index] = product
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        } else {
            //item changed  , but changed position
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            products.remove(at: oldIndex)
            products.insert(product, at: newIndex)
            tableView.moveRow(at: IndexPath(row: oldIndex, section: 0), to: IndexPath(row: newIndex, section: 0))
        }
    }
    func onDocumentRemoved(change : DocumentChange){
        let oldIndex = Int(change.oldIndex)
        products.remove(at: oldIndex )
        tableView.deleteRows(at: [IndexPath(row: oldIndex, section: 0)], with: .left)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.ProductCell, for: indexPath) as! ProductCell
        cell.configCell(product: products[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.seletedProduct = products[indexPath.row]
        performSegue(withIdentifier: Segues.ToAddEditProduct, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.ToAddEditProduct {
            if let destination = segue.destination as? AddEditProductsVC {
                destination.selectedCategory = category
                destination.productToEdit = seletedProduct
             }
        } else if segue.identifier == Segues.ToEditCategory {
            if let destination = segue.destination as? AddEditCategoryVC {
                destination.categoryToEdit = category
            }
        }
    }
}
