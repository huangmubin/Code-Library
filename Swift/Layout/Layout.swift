//
//  Layout.swift
//  Layout
//
//  Created by 黄穆斌 on 16/9/24.
//  Copyright © 2016年 MuBinHuang. All rights reserved.
//

import UIKit

// MARK: - Layout

class Layout {
    
    // MARK: Views
    
    weak var view: UIView!
    weak var first: UIView!
    weak var second: UIView!
    
    // MARK: Init
    
    init(_ view: UIView) {
        self.view = view
    }
    
    // MARK: Set View
    
    func view(_ first: UIView) -> Layout {
        self.first = first
        self.first.translatesAutoresizingMaskIntoConstraints = false
        if self.second == nil {
            self.second = self.view
        }
        return self
    }
    
    func to(_ second: UIView) -> Layout {
        self.second = second
        return self
    }
    
    // MARK: Constraints
    
    var constrants: [NSLayoutConstraint] = []
    
    @discardableResult
    func get(layouts: ([NSLayoutConstraint]) -> Void) -> Layout {
        layouts(constrants)
        return self
    }
    
    @discardableResult
    func clear() -> Layout {
        constrants.removeAll(keepingCapacity: true)
        return self
    }
    
    // MARK: Custom Edge Methods
    
    @discardableResult
    func layout(edge: NSLayoutAttribute, to: NSLayoutAttribute? = nil, constant: CGFloat = 0, multiplier: CGFloat = 1, priority: UILayoutPriority = UILayoutPriorityDefaultHigh, related: NSLayoutRelation = .equal) -> Layout {
        let layout = NSLayoutConstraint(item: first, attribute: edge, relatedBy: related, toItem: second, attribute: to ?? edge, multiplier: multiplier, constant: constant)
        layout.priority = priority
        view.addConstraint(layout)
        constrants.append(layout)
        return self
    }
    
    @discardableResult
    func equal(edges: NSLayoutAttribute...) -> Layout {
        for edge in edges {
            let layout = NSLayoutConstraint(
                item: first,
                attribute: edge,
                relatedBy: .equal,
                toItem: second,
                attribute: edge,
                multiplier: 1,
                constant: 0
            )
            view.addConstraint(layout)
            constrants.append(layout)
        }
        return self
    }
    
    // MARK: - Size Edge Methods
    
    @discardableResult
    func size(height: CGFloat, priority: UILayoutPriority = UILayoutPriorityDefaultHigh) -> Layout {
        let layout = NSLayoutConstraint(
            item: first,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: height
        )
        layout.priority = priority
        first.addConstraint(layout)
        constrants.append(layout)
        return self
    }
    
    @discardableResult
    func size(width: CGFloat, priority: UILayoutPriority = UILayoutPriorityDefaultHigh) -> Layout {
        let layout = NSLayoutConstraint(
            item: first,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: width
        )
        layout.priority = priority
        first.addConstraint(layout)
        constrants.append(layout)
        return self
    }
    
    @discardableResult
    func size(ratio: CGFloat, constant: CGFloat = 0, priority: UILayoutPriority = UILayoutPriorityDefaultHigh) -> Layout {
        let layout = NSLayoutConstraint(
            item: first,
            attribute: .width,
            relatedBy: .equal,
            toItem: first,
            attribute: .height,
            multiplier: ratio,
            constant: constant
        )
        layout.priority = priority
        first.addConstraint(layout)
        constrants.append(layout)
        return self
    }
    
    // MARK: - One Edge Methods
    
    @discardableResult
    func leading(_ constant: CGFloat = 0, multiplier: CGFloat = 1, relate: NSLayoutRelation = .equal, priority: UILayoutPriority = UILayoutPriorityDefaultHigh) -> Layout {
        let layout = NSLayoutConstraint(
            item: first,
            attribute: .leading,
            relatedBy: relate,
            toItem: second,
            attribute: .leading,
            multiplier: multiplier,
            constant: constant
        )
        layout.priority = priority
        view.addConstraint(layout)
        constrants.append(layout)
        return self
    }
    
    @discardableResult
    func trailing(_ constant: CGFloat = 0, multiplier: CGFloat = 1, relate: NSLayoutRelation = .equal, priority: UILayoutPriority = UILayoutPriorityDefaultHigh) -> Layout {
        let layout = NSLayoutConstraint(
            item: first,
            attribute: .trailing,
            relatedBy: relate,
            toItem: second,
            attribute: .trailing,
            multiplier: multiplier,
            constant: constant
        )
        layout.priority = priority
        view.addConstraint(layout)
        constrants.append(layout)
        return self
    }
    
    @discardableResult
    func top(_ constant: CGFloat = 0, multiplier: CGFloat = 1, relate: NSLayoutRelation = .equal, priority: UILayoutPriority = UILayoutPriorityDefaultHigh) -> Layout {
        let layout = NSLayoutConstraint(
            item: first,
            attribute: .top,
            relatedBy: relate,
            toItem: second,
            attribute: .top,
            multiplier: multiplier,
            constant: constant
        )
        layout.priority = priority
        view.addConstraint(layout)
        constrants.append(layout)
        return self
    }
    
    @discardableResult
    func bottom(_ constant: CGFloat = 0, multiplier: CGFloat = 1, relate: NSLayoutRelation = .equal, priority: UILayoutPriority = UILayoutPriorityDefaultHigh) -> Layout {
        let layout = NSLayoutConstraint(
            item: first,
            attribute: .bottom,
            relatedBy: relate,
            toItem: second,
            attribute: .bottom,
            multiplier: multiplier,
            constant: constant
        )
        layout.priority = priority
        view.addConstraint(layout)
        constrants.append(layout)
        return self
    }
    
    @discardableResult
    func centerX(_ constant: CGFloat = 0, multiplier: CGFloat = 1, relate: NSLayoutRelation = .equal, priority: UILayoutPriority = UILayoutPriorityDefaultHigh) -> Layout {
        let layout = NSLayoutConstraint(
            item: first,
            attribute: .centerX,
            relatedBy: relate,
            toItem: second,
            attribute: .centerX,
            multiplier: multiplier,
            constant: constant
        )
        layout.priority = priority
        view.addConstraint(layout)
        constrants.append(layout)
        return self
    }
    
    @discardableResult
    func centerY(_ constant: CGFloat = 0, multiplier: CGFloat = 1, relate: NSLayoutRelation = .equal, priority: UILayoutPriority = UILayoutPriorityDefaultHigh) -> Layout {
        let layout = NSLayoutConstraint(
            item: first,
            attribute: .centerY,
            relatedBy: relate,
            toItem: second,
            attribute: .centerY,
            multiplier: multiplier,
            constant: constant
        )
        layout.priority = priority
        view.addConstraint(layout)
        constrants.append(layout)
        return self
    }
    
    @discardableResult
    func width(_ constant: CGFloat = 0, multiplier: CGFloat = 1, relate: NSLayoutRelation = .equal, priority: UILayoutPriority = UILayoutPriorityDefaultHigh) -> Layout {
        let layout = NSLayoutConstraint(
            item: first,
            attribute: .width,
            relatedBy: relate,
            toItem: second,
            attribute: .width,
            multiplier: multiplier,
            constant: constant
        )
        layout.priority = priority
        view.addConstraint(layout)
        constrants.append(layout)
        return self
    }
    
    @discardableResult
    func height(_ constant: CGFloat = 0, multiplier: CGFloat = 1, relate: NSLayoutRelation = .equal, priority: UILayoutPriority = UILayoutPriorityDefaultHigh) -> Layout {
        let layout = NSLayoutConstraint(
            item: first,
            attribute: .height,
            relatedBy: relate,
            toItem: second,
            attribute: .height,
            multiplier: multiplier,
            constant: constant
        )
        layout.priority = priority
        view.addConstraint(layout)
        constrants.append(layout)
        return self
    }
    
    // MARK: Two Edge Methods
    
    /// width and height
    @discardableResult
    func size(_ constant: CGFloat = 0, multiplier: CGFloat = 1) -> Layout {
        let _ = {
            let layout = NSLayoutConstraint(
                item: first,
                attribute: .width,
                relatedBy: .equal,
                toItem: second,
                attribute: .width,
                multiplier: multiplier,
                constant: constant
            )
            view.addConstraint(layout)
            constrants.append(layout)
        }()
        let _ = {
            let layout = NSLayoutConstraint(
                item: first,
                attribute: .height,
                relatedBy: .equal,
                toItem: second,
                attribute: .height,
                multiplier: multiplier,
                constant: constant
            )
            view.addConstraint(layout)
            constrants.append(layout)
        }()
        return self
    }
    
    /// centerX and centerY
    @discardableResult
    func center(_ constant: CGFloat = 0, multiplier: CGFloat = 1) -> Layout {
        let _ = {
            let layout = NSLayoutConstraint(
                item: first,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: second,
                attribute: .centerX,
                multiplier: multiplier,
                constant: constant
            )
            view.addConstraint(layout)
            constrants.append(layout)
        }()
        let _ = {
            let layout = NSLayoutConstraint(
                item: first,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: second,
                attribute: .centerY,
                multiplier: multiplier,
                constant: constant
            )
            view.addConstraint(layout)
            constrants.append(layout)
        }()
        return self
    }
    
    // MARK: Four Edge Methods
    
    /// top, bottom, leading, trailing
    @discardableResult
    func edges(zoom: CGFloat = 0) -> Layout {
        let _ = {
            let layout = NSLayoutConstraint(
                item: first,
                attribute: .top,
                relatedBy: .equal,
                toItem: second,
                attribute: .top,
                multiplier: 1,
                constant: zoom
            )
            view.addConstraint(layout)
            constrants.append(layout)
        }()
        let _ = {
            let layout = NSLayoutConstraint(
                item: first,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: second,
                attribute: .bottom,
                multiplier: 1,
                constant: -zoom
            )
            view.addConstraint(layout)
            constrants.append(layout)
        }()
        let _ = {
            let layout = NSLayoutConstraint(
                item: first,
                attribute: .leading,
                relatedBy: .equal,
                toItem: second,
                attribute: .leading,
                multiplier: 1,
                constant: zoom
            )
            view.addConstraint(layout)
            constrants.append(layout)
        }()
        let _ = {
            let layout = NSLayoutConstraint(
                item: first,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: second,
                attribute: .trailing,
                multiplier: 1,
                constant: -zoom
            )
            view.addConstraint(layout)
            constrants.append(layout)
        }()
        return self
    }
    
    /// width, height, centerX, centerY
    @discardableResult
    func align(offset: CGFloat = 0) -> Layout {
        let _ = {
            let layout = NSLayoutConstraint(
                item: first,
                attribute: .width,
                relatedBy: .equal,
                toItem: second,
                attribute: .width,
                multiplier: 1,
                constant: 0
            )
            view.addConstraint(layout)
            constrants.append(layout)
        }()
        let _ = {
            let layout = NSLayoutConstraint(
                item: first,
                attribute: .height,
                relatedBy: .equal,
                toItem: second,
                attribute: .height,
                multiplier: 1,
                constant: 0
            )
            view.addConstraint(layout)
            constrants.append(layout)
        }()
        let _ = {
            let layout = NSLayoutConstraint(
                item: first,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: second,
                attribute: .centerX,
                multiplier: 1,
                constant: offset
            )
            view.addConstraint(layout)
            constrants.append(layout)
        }()
        let _ = {
            let layout = NSLayoutConstraint(
                item: first,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: second,
                attribute: .centerY,
                multiplier: 1,
                constant: offset
            )
            view.addConstraint(layout)
            constrants.append(layout)
        }()
        return self
    }
}

// MARK: - Advanced Using

// MAKR: Custom Operation

/// Using to set the layout's priority.
infix operator >>>: AdditionPrecedence

// MARK: Safe Call Interface

extension Layout {
    
    static weak var `super`: UIView?
    
    @discardableResult
    func auto(_ layouts: () -> Void) -> Layout {
        DispatchQueue.main.sync {
            Layout.super = self.view
            layouts()
            Layout.super = nil
        }
        return self
    }
    
}

// MARK: - Layout.View

extension Layout {
    
    class View {
        weak var `super`: UIView?
        weak var view: UIView!
        var attribute: NSLayoutAttribute
        
        var constant: CGFloat = 0
        var multiplier: CGFloat = 1
        var priority: UILayoutPriority?
        
        init(view: UIView, attribute: NSLayoutAttribute) {
            self.view = view
            self.attribute = attribute
        }
    }
}

// MARK: - Custom Operations

extension Layout.View {
    
    // MARK: Results
    
    @discardableResult
    static func == (left: Layout.View, right: Layout.View) -> NSLayoutConstraint {
        let layout = NSLayoutConstraint(item: left.view, attribute: left.attribute, relatedBy: .equal, toItem: right.view, attribute: right.attribute, multiplier: right.multiplier, constant: right.constant)
        if right.priority != nil {
            layout.priority = right.priority!
        }
        if right.super == nil {
            Layout.super?.addConstraint(layout)
        } else {
            right.super?.addConstraint(layout)
        }
        return layout
    }
    
    @discardableResult
    static func == (left: Layout.View, right: CGFloat) -> NSLayoutConstraint {
        let layout = NSLayoutConstraint(item: left.view, attribute: left.attribute, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: right)
        left.view.addConstraint(layout)
        return layout
    }
    
    @discardableResult
    static func <= (left: Layout.View, right: Layout.View) -> NSLayoutConstraint {
        let layout = NSLayoutConstraint(item: left.view, attribute: left.attribute, relatedBy: .lessThanOrEqual, toItem: right.view, attribute: right.attribute, multiplier: right.multiplier, constant: right.constant)
        if right.priority != nil {
            layout.priority = right.priority!
        }
        if right.super == nil {
            Layout.super?.addConstraint(layout)
        } else {
            right.super?.addConstraint(layout)
        }
        return layout
    }
    
    @discardableResult
    static func >= (left: Layout.View, right: Layout.View) -> NSLayoutConstraint {
        let layout = NSLayoutConstraint(item: left.view, attribute: left.attribute, relatedBy: .greaterThanOrEqual, toItem: right.view, attribute: right.attribute, multiplier: right.multiplier, constant: right.constant)
        if right.priority != nil {
            layout.priority = right.priority!
        }
        if right.super == nil {
            Layout.super?.addConstraint(layout)
        } else {
            right.super?.addConstraint(layout)
        }
        return layout
    }
    
    // MARK: Values Set
    
    static func + (left: Layout.View, right: CGFloat) -> Layout.View {
        left.constant = right
        return left
    }
    static func - (left: Layout.View, right: CGFloat) -> Layout.View {
        left.constant = -right
        return left
    }
    static func * (left: Layout.View, right: CGFloat) -> Layout.View {
        left.multiplier = right
        return left
    }
    static func / (left: Layout.View, right: CGFloat) -> Layout.View {
        left.multiplier = 1/right
        return left
    }
    static func >>> (left: Layout.View, right: UILayoutPriority) -> Layout.View {
        left.priority = right
        return left
    }
    
}

// MARK: - Extension UIView

extension UIView {
    
    var leading: Layout.View {
        return Layout.View(view: self, attribute: .leading)
    }
    var trailing: Layout.View {
        return Layout.View(view: self, attribute: .trailing)
    }
    var top: Layout.View {
        return Layout.View(view: self, attribute: .top)
    }
    var bottom: Layout.View {
        return Layout.View(view: self, attribute: .bottom)
    }
    var centerX: Layout.View {
        return Layout.View(view: self, attribute: .centerX)
    }
    var centerY: Layout.View {
        return Layout.View(view: self, attribute: .centerY)
    }
    var width: Layout.View {
        return Layout.View(view: self, attribute: .width)
    }
    var height: Layout.View {
        return Layout.View(view: self, attribute: .height)
    }
    
}
