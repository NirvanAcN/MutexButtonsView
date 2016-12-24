//
//  MutexButtonsView.swift
//  snsktv
//
//  Created by iCe_Rabbit on 2016/12/23.
//  Copyright © 2016年 HOME Ma. All rights reserved.
//

import UIKit

protocol MutexButtonsViewDelegate: NSObjectProtocol {
    /// required: set buttons title
    ///
    /// - Returns: titles
    func mutexButtonsViewButtonsTitle() -> [String]
    
    /// optional: set buttons title's font
    ///
    /// - Returns: default font is systemFont size15
    func mutexButtonsViewFont() -> UIFont
    
    /// optional: set buttons title's color
    ///
    /// - Returns: tuple's first value is .normal default is black, second is .selected default is red
    func mutexButtonsViewTitleColors() -> (UIColor, UIColor)
    
    /// optional: set buttons' background image
    ///
    /// - Returns: tuple's first value is .normal, second is .selected
    func mutexButtonsViewBackgroundImages() -> (UIImage?, UIImage?)!

    /// optional: set buttons view's default selected button by index
    ///
    /// - Returns: default is 0
    func mutexButtonsViewDefaultSelectIndex() -> Int
    
    /// optional: when buttons are touchuped, this function will execute
    ///
    /// - Parameters:
    ///   - mutexButtonsView: mutexButtonsView
    ///   - index: which button had touched
    func mutexButtonsView(_ mutexButtonsView: MutexButtonsView, didSelect index: Int)
}

extension MutexButtonsViewDelegate {
    func mutexButtonsViewFont() -> UIFont {
        return MutexButtonsView.kDefaultFont
    }
    
    func mutexButtonsViewTitleColors() -> (UIColor, UIColor) {
        return MutexButtonsView.kDefaultColors
    }
    
    func mutexButtonsViewBackgroundImages() -> (UIImage?, UIImage?)! {
        return nil
    }

    func mutexButtonsViewDefaultSelectIndex() -> Int {
        return 0
    }
    
    func mutexButtonsView(_ mutexButtonsView: MutexButtonsView, didSelect index: Int) { }
}

class MutexButtonsView: UIView {
    
    fileprivate static let kDefaultFont     = UIFont.systemFont(ofSize: 15)
    fileprivate static let kDefaultColors   = (UIColor.black, UIColor.red)
    
    private weak var _delegate: MutexButtonsViewDelegate!
    weak var delegate: MutexButtonsViewDelegate! {
        set {
            _delegate = newValue
            configure()
        }
        get {
            return _delegate
        }
    }
    
    private var btns = [UIButton]()
    
    private var _selectedIndex = 0
    /// change which button is selected
    var selectedIndex: Int! {
        get {
            return _selectedIndex
        }
        set {
            guard newValue < btns.count, newValue >= 0 else {
                return
            }
            onBtnsClick(btns[newValue])
            _selectedIndex = newValue
        }
    }
    
    private func configure() {
        guard let datasource    = delegate?.mutexButtonsViewButtonsTitle() else { return }
        let font                = delegate.mutexButtonsViewFont()
        let titleColors         = delegate.mutexButtonsViewTitleColors()
        let backgroundImages    = delegate.mutexButtonsViewBackgroundImages()
        let indexDefault        = delegate.mutexButtonsViewDefaultSelectIndex()
        
        createBtns(by: datasource, font: font, titleColors: titleColors, backgroundImages: backgroundImages, indexDefault: indexDefault)
    }
    
    private func createBtns(by datasource: [String], font: UIFont, titleColors: (UIColor, UIColor),  backgroundImages: (UIImage?, UIImage?)!, indexDefault: Int) {
        let width   = bounds.size.width / CGFloat(datasource.count)
        let height  = bounds.size.height
        
        for (idx, title) in datasource.enumerated() {
            let btn = UIButton.init(type: .custom)
            btn.frame = CGRect.init(x: CGFloat(idx) * width, y: CGFloat.leastNonzeroMagnitude, width: width, height: height)
            btn.setTitle(title, for: .normal)
            btn.setTitleColor(titleColors.0, for: .normal)
            btn.setTitleColor(titleColors.1, for: .selected)
            btn.setTitleColor(UIColor.blue, for: .highlighted)
            btn.setBackgroundImage(backgroundImages?.0, for: .normal)
            btn.setBackgroundImage(backgroundImages?.1, for: .selected)
            btn.titleLabel?.font = font
            btn.addTarget(self, action: #selector(onBtnsClick), for: .touchUpInside)
            btn.addTarget(self, action: #selector(onBtnsAllAction), for: .allTouchEvents)
            btn.isSelected = idx == indexDefault
            btns.append(btn)
            addSubview(btn)
        }
    }
    
    @objc private func onBtnsClick(_ sender: UIButton) {
        btns.forEach {$0.isSelected = sender == $0}
        delegate?.mutexButtonsView(self, didSelect: btns.index(of: sender)!)
    }
    
    @objc private func onBtnsAllAction(_ sender: UIButton) {
        sender.isHighlighted = false
    }
    
}
