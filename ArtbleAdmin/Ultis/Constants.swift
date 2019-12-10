//
//  Constants.swift
//  Artable
//
//  Created by Trần Thành on 12/4/19.
//  Copyright © 2019 Trần Thành. All rights reserved.
//

import UIKit

struct Storyboard {
    static let Main = "Main"
}

struct StoryboardId {
    
}

struct AppImages {
    static let GreenCheck = "green_check"
    static let RedCheck = "red_check"
}

struct AppColors {
    static let Blue = #colorLiteral(red: 0.2887048423, green: 0.3279049993, blue: 0.4109624028, alpha: 1)
    static let Red = #colorLiteral(red: 0.8352941176, green: 0.3921568627, blue: 0.3137254902, alpha: 1)
    static let OffWhite = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
}

struct Identifier {
    static let CategoryCell = "CategoriesCell"
    static let ProductCell =  "ProductCell"
}

struct Segues {
    static let ToAdminProductsVC = "ToAdminProductsVC"
    static let ToAddEditCategory = "ToAddEditCategory"
    static let ToEditCategory = "ToEditCategory"
    static let ToAddEditProduct = "ToAddEditProduct"
}
