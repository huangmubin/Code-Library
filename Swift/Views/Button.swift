//
//  Button.swift
//  Views
//
//  Created by 黄穆斌 on 16/9/26.
//  Copyright © 2016年 MuBinHuang. All rights reserved.
//

import UIKit

class Button: UIButton {
    
    // MARK: - Property
    
    /// 备注信息
    @IBInspectable var note: String = ""
    
    // MAKR: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        deploy()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        deploy()
    }
    
    func deploy() {
        layer.shadowOffset = CGSize(width: shadowOffset.x, height: shadowOffset.y)
        
        let select = self.isSelected
        self.isSelected = true
        self.isSelected = select
        
        let high = self.isHighlighted
        self.isHighlighted = true
        self.isHighlighted = high
    }
    
    // MARK: - Draws
    
    // MAKR: Shadow
    
    /// 圆角角度
    @IBInspectable var corner: CGFloat = 0 {
        didSet {
            layer.cornerRadius = corner
        }
    }
    /// 阴影透明度
    @IBInspectable var shadowOpacity: Float = 0 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    /// 阴影偏移
    @IBInspectable var shadowOffset: CGPoint = CGPoint.zero {
        didSet {
            layer.shadowOffset = CGSize(width: shadowOffset.x, height: shadowOffset.y)
        }
    }
    /// 阴影距离
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    // MARK: Back View
    
    /// 背景颜色
    var backColor: UIColor = UIColor.clear {
        didSet {
            layer.backgroundColor = isSelected ? tintColor.cgColor : backColor.cgColor
            backgroundColor = UIColor.clear
        }
    }
    
    // MAKR: - Override
    
    // MARK: Status
    
    private var removedBackImageView: Bool = true
    override var isSelected: Bool {
        didSet {
            if removedBackImageView {
                for view in subviews {
                    if view is UIImageView && view !== imageView {
                        removedBackImageView = false
                        view.removeFromSuperview()
                    }
                }
            }
            layer.backgroundColor = isSelected ? tintColor.cgColor : backColor.cgColor
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.alpha = self.isHighlighted ? 0.3 : 1
            }
        }
    }
    
    // MARK: Color
    
    override var backgroundColor: UIColor? {
        didSet {
            if backgroundColor != UIColor.clear {
                backColor = backgroundColor ?? UIColor.clear
            }
        }
    }
    
}
