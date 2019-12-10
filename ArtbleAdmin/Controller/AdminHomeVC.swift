//
//  ViewController.swift
//  ArtbleAdmin
//
//  Created by Trần Thành on 12/6/19.
//  Copyright © 2019 Trần Thành. All rights reserved.
//

import UIKit
import Firebase
class AdminHomeVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    //Variables
    var categories = [Category]()
    var selectedCategory : Category!
    var db : Firestore!
    var listener : ListenerRegistration!
    
    
    fileprivate func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Identifier.CategoryCell, bundle: nil), forCellWithReuseIdentifier: Identifier.CategoryCell)
        collectionView.showsVerticalScrollIndicator = false
    }
    
    
    fileprivate func setupIntialAnonymousUser() {
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error {
                    debugPrint(error)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        setupCollectionView()
        setupIntialAnonymousUser()
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listener.remove()
        categories.removeAll()
        collectionView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setCategoriesListener()
    }
    func setCategoriesListener(){
        listener = db.categoties.addSnapshotListener({ (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            snap?.documentChanges.forEach({ (change) in
                let data = change.document.data()
                let category = Category(data: data)
                switch change.type {
                case.added :
                    self.onDocumentAdded(change: change, category: category)
                case.modified :
                    self.onDocumentModified(change: change, category: category)
                case.removed :
                    self.onDocumentRemoved(change: change)
                }
            })
        })
    }
    func onDocumentAdded(change : DocumentChange , category : Category){
        
        let newIndex = Int(change.newIndex)
        categories.insert(category, at: newIndex)
        collectionView.insertItems(at: [IndexPath(item: newIndex, section: 0)])
    }
    func onDocumentModified(change : DocumentChange , category : Category){
        if change.newIndex == change.oldIndex {
            // item changed  , but remained in the same position
            let index = Int(change.newIndex)
            categories[index] = category
            collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        } else {
            //item changed  , but changed position
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            categories.remove(at: oldIndex)
            categories.insert(category, at: newIndex)
            collectionView.moveItem(at: IndexPath(item: oldIndex, section: 0), to: IndexPath(item: newIndex, section: 0))
        }
    }
    func onDocumentRemoved(change : DocumentChange){
        let oldIndex = Int(change.oldIndex)
        categories.remove(at: oldIndex )
        collectionView.deleteItems(at: [IndexPath(item: oldIndex, section: 0)])
    }
    
    @IBAction func addCategory(_ sender: Any) {
       
        performSegue(withIdentifier: Segues.ToAddEditCategory, sender: self)
        
        
    }
}


extension AdminHomeVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.CategoryCell, for: indexPath) as! CategoriesCell
        cell.configCell(category: categories[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let cellwidth = (width - 50) / 2
        let cellheight = cellwidth * 1.5
        return .init(width: cellwidth, height: cellheight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.item]
        performSegue(withIdentifier: Segues.ToAdminProductsVC, sender: self)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.ToAdminProductsVC {
            if let destination = segue.destination as? AdminProductsVC {
                destination.category = selectedCategory
            }
        }
}

}
