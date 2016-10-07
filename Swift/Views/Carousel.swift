//
//  Carousel.swift
//  Views
//
//  Created by 黄穆斌 on 16/9/27.
//  Copyright © 2016年 MuBinHuang. All rights reserved.
//

import UIKit

// MARK: - Carousel Model

extension Carousel {
    class Model {
        
        var image: UIImage {
            return _image
        }

        // MARK: Ivar

        var _image: UIImage

        // MARK: Init

        init(image: UIImage) {
            self._image = image
        }
    }
}

// MARK: - Carousel

class Carousel: UIView {
    
    // MARK: Perporty
    
    var datas: [Model] = []
    var views: [UIImageView] = []
    var index: Int = 0
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadDeploy()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadDeploy()
    }
    
    private func loadDeploy() {
        for _ in 0 ..< 3 {
            let image = UIImageView(frame: bounds)
            addSubview(image)
            views.append(image)
            
            let _ = {
                let layout = NSLayoutConstraint(item: image, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
                layouts.centerX.append(layout)
                addConstraint(layout)
            }()
            
            let _ = {
                let layout = NSLayoutConstraint(item: image, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
                layouts.centerY.append(layout)
                addConstraint(layout)
            }()
            
            
        }
    }
    
    // MARK: Layouts
    
    struct Layouts {
        var centerX: [NSLayoutConstraint] = []
        var centerY: [NSLayoutConstraint] = []
        var width  : [NSLayoutConstraint] = []
        var height : [NSLayoutConstraint] = []
        var space  : [NSLayoutConstraint] = []
    }
    private var layouts: Layouts = Layouts()
    
    
}
