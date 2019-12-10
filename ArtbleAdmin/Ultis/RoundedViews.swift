//
//  RoundedViews.swift
//  Artable
//
//  Created by Trần Thành on 12/4/19.
//  Copyright © 2019 Trần Thành. All rights reserved.
//

import UIKit

class RoundedButton : UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
    }
}

class RoundedShadowView : UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        layer.shadowColor = AppColors.Blue.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 3
    }
}

class RoundedImageView : UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
    }
}
