//
//  Constants.swift
//  Grow
//
//  Created by Hiya Shah on 1/25/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import Foundation
import UIKit

struct Storyboard {
    static let LoginStoryboard = "LoginStoryboard"
    static let Main = "Main"
}

struct StoryboardId {
    static let LoginVC = "loginVC"
}

struct AppImages {
    static let GreenCheck = "green_check"
    static let RedCheck = "red_check"
    static let FilledStar = "filled_star"
    static let EmptyStar = "empty_star"
    static let Placeholder = "placeholder"
}

struct AppColors {
    static let PastelAquamarine = #colorLiteral(red: 0.8941176471, green: 0.9882352941, blue: 0.9647058824, alpha: 1)
    static let OffWhite = #colorLiteral(red: 0.9542341828, green: 1, blue: 0.9506618381, alpha: 1)
    
}

struct Identifiers {
    static let CategoryCell = "CategoryCell"
    static let ProductCell = "ProductCell"
    static let CartItemCell = "CartItemCell"
}

struct Segues {
    static let ToProducts = "toProductsVC"
    static let ToAddEditCategory = "ToAddEditCategory"
    static let ToEditCategory = "ToEditCategory"
    static let ToAddEditProduct = "ToAddEditProduct"
    static let ToFavorites = "ToFavorites"
}
