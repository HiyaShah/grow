//
//  RoundedViews.swift
//  Grow
//
//  Created by Hiya Shah on 1/25/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import Foundation
import UIKit

class RoundedButton : UIButton {
    override func awakeFromNib() {
        layer.cornerRadius = 5
        
    }
}

class RoundedShadowView : UIView{
    override func awakeFromNib() {
        layer.cornerRadius = 5
        layer.shadowColor = AppColors.OffWhite.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 3
    }
}

class RoundedImageView : UIImageView {
    override func awakeFromNib() {
        layer.cornerRadius = 5
    }
}
