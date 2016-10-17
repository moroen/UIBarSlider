//
//  UIBarToggle.swift
//  UIBarSlider
//
//  Created by Morten Waldvogel-Rønning on 17.10.2016.
//  Copyright © 2016 Morten. All rights reserved.
//

import UIKit

@IBDesignable public class UIBarToggle: UIControl {

    let toggleLayer = CALayer()
    
    private var myState: Bool = false
    
    public var State: Bool {
        set {   myState = newValue
            layoutSubviews() }
        get { return myState }
            
    }
    
    @IBInspectable public var Width: Double = 0.0 {
        didSet {
            layoutSubviews()
        }
    }
    
    @IBInspectable public var WidthRelative: Double = 0.5 {
        didSet {
            layoutSubviews()
        }
    }
    
    @IBInspectable public var OnColor: UIColor = UIColor.red {
        didSet {
            layoutSubviews()
        }
    }
    
    @IBInspectable public var OffColor: UIColor = UIColor.blue {
        didSet {
            layoutSubviews()
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 5 {
        didSet {
            //self.layer.cornerRadius = cornerRadius
            //self.layer.masksToBounds = cornerRadius > 0
            toggleLayer.cornerRadius = cornerRadius
            layoutSubviews()
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    // --MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayers()
    }
    
    // --MARK: Layers
    func setupLayers() {
        
        let rec = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        
        self.addGestureRecognizer(rec)
        self.layer.addSublayer(toggleLayer)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
    
        if self.myState {
            toggleLayer.backgroundColor = self.OnColor.cgColor
        } else {
           toggleLayer.backgroundColor = self.OffColor.cgColor
        }
        
        var myWidth: CGFloat = 0.0
        
        if self.Width != 0 {
            myWidth = CGFloat(self.Width)
        } else {
            myWidth = self.bounds.width * CGFloat(self.WidthRelative)
        }
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        toggleLayer.frame = CGRect(x: self.bounds.midX - myWidth/2, y: 0, width: myWidth, height: self.bounds.height)
        
        CATransaction.commit()
    }
    
    // --MARK: Handlers
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        let loc = sender.location(in: self)
        
        
        if toggleLayer.frame.contains(loc) {
            myState = !myState
            layoutSubviews()
            sendActions(for: .valueChanged)
        }
    }
    
}
