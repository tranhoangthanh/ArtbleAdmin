//
//  CategoriesCell.swift
//  Artable
//
//  Created by Trần Thành on 12/5/19.
//  Copyright © 2019 Trần Thành. All rights reserved.
//

import UIKit
import Kingfisher

class CategoriesCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryImage: UIImageView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configCell(category: Category){
        self.categoryLabel.text = category.name
        if let url = URL(string: category.imgUrl) {
            let placeholder = UIImage(named: "placeholder")
            let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
            categoryImage.kf.indicatorType = .activity
            self.categoryImage.kf.setImage(with: url , placeholder: placeholder, options: options)
        }
    }
}
