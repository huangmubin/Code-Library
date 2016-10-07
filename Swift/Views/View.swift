//
//  View.swift
//  Views
//
//  Created by 黄穆斌 on 16/9/26.
//  Copyright © 2016年 MuBinHuang. All rights reserved.
//

import UIKit

class View: UIView {
    
    // MARK: - Values
    
    /// 视图圆角: x 左上角, y 右上角, h 右下角, w 左下角
    @IBInspectable var cornerRadius: CGRect = CGRect.zero {
        didSet {
            backLayer.path = roundedPath(size: bounds.size, a: cornerRadius.origin.x, b: cornerRadius.origin.y, c: cornerRadius.height, d: cornerRadius.width).cgPath
        }
    }
    /// 阴影透明度
    @IBInspectable var shadowOpacity: Float = 0 {
        didSet {
            backLayer.shadowOpacity = shadowOpacity
        }
    }
    /// 阴影扩展
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            backLayer.shadowRadius = shadowRadius
        }
    }
    /// 阴影偏移
    @IBInspectable var shadowOffset: CGPoint = CGPoint.zero {
        didSet {
            backLayer.shadowOffset = CGSize(width: shadowOffset.x, height: shadowOffset.y)
        }
    }
    
    // MARK: - Override
    
    /// Will be always clear, every set will change color and backlayer's color.
    override var backgroundColor: UIColor? {
        didSet {
            if backgroundColor != nil {
                let color = backgroundColor
                backgroundColor = nil
                backLayer.fillColor = color?.cgColor
            }
        }
    }
    
    override var frame: CGRect {
        didSet {
            backLayer.path = roundedPath(size: bounds.size, a: cornerRadius.origin.x, b: cornerRadius.origin.y, c: cornerRadius.height, d: cornerRadius.width).cgPath
        }
    }
    
    override var bounds: CGRect {
        didSet {
            backLayer.path = roundedPath(size: bounds.size, a: cornerRadius.origin.x, b: cornerRadius.origin.y, c: cornerRadius.height, d: cornerRadius.width).cgPath
        }
    }
    
    // MARK: Sub Layer
    
    private var backLayer: CAShapeLayer = CAShapeLayer()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initDeploy()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initDeploy()
    }
    
    func initDeploy() {
        backLayer.path = roundedPath(size: bounds.size, a: cornerRadius.origin.x, b: cornerRadius.origin.y, c: cornerRadius.height, d: cornerRadius.width).cgPath
        backLayer.strokeColor = UIColor.clear.cgColor
        layer.insertSublayer(backLayer, at: 0)
    }
    
    // MARK: - Drawer
    
    func roundedPath(size: CGSize, a: CGFloat, b: CGFloat, c: CGFloat, d: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: a))
        path.addArc(withCenter: CGPoint(x: a, y: a), radius: a, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI_2) * 3, clockwise: true)
        path.addLine(to: CGPoint(x: size.width - b, y: 0))
        path.addArc(withCenter: CGPoint(x: size.width - b, y: b), radius: b, startAngle: CGFloat(M_PI_2) * 3, endAngle: CGFloat(M_PI_2) * 4, clockwise: true)
        path.addLine(to: CGPoint(x: size.width, y: size.height - c))
        path.addArc(withCenter: CGPoint(x: size.width - c, y: size.height - c), radius: c, startAngle: 0, endAngle: CGFloat(M_PI_2), clockwise: true)
        path.addLine(to: CGPoint(x: d, y: size.height))
        path.addArc(withCenter: CGPoint(x: d, y: size.height - d), radius: d, startAngle: CGFloat(M_PI_2), endAngle: CGFloat(M_PI), clockwise: true)
        path.close()
        return path
    }
}
