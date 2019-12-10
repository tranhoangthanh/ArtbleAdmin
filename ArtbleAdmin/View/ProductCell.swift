//
//  ProductCell.swift
//  Artable
//
//  Created by Trần Thành on 12/5/19.
//  Copyright © 2019 Trần Thành. All rights reserved.
//

import UIKit
import Kingfisher

class ProductCell: UITableViewCell {

    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addToCardClicked(_ sender: Any) {
    }
    @IBAction func favoriteClicked(_ sender: Any) {
    }
    
    func configCell(product : Product){
        self.productTitle.text = product.name
        if let url = URL(string: product.imageUrl){
            let placeholder = UIImage(named: "placeholder")
            let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
            productImage.kf.indicatorType = .activity
            self.productImage.kf.setImage(with: url , placeholder: placeholder, options: options)
        }
        let formatter  = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber) {
            productPrice.text = price
        }
        
    }
}
