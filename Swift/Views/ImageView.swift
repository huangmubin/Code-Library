//
//  ImageView.swift
//  Views
//
//  Created by 黄穆斌 on 16/9/26.
//  Copyright © 2016年 MuBinHuang. All rights reserved.
//

import UIKit

class ImageView: UIImageView {
    
    /// cornerRadius = self.bounds.height * corner!.width + corner!.height
    @IBInspectable var corner: CGSize? = nil {
        didSet {
            if corner == nil {
                layer.cornerRadius = 0
            } else {
                layer.masksToBounds = true
                layer.cornerRadius = self.bounds.height * corner!.width + corner!.height
            }
        }
    }
    
}
