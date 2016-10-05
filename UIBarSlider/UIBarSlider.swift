//
//  barSlider.swift
//  barSlider
//
//  Created by Morten Waldvogel-Rønning on 19.09.2016.
//  Copyright © 2016 Morten. All rights reserved.
//

// Available outlets:
//  valueChanged
//  primaryActionTriggered

import UIKit

@IBDesignable public class UIBarSlider: UIControl {
    let trackLayer = CALayer()
    let valueLabel = UILabel()
    
    private var currentValue: Double = 25.0 {
        didSet {
            layoutSubviews()
        }
    }
    
    var isCurrentlyTracking: Bool = false {
        didSet {
            if isCurrentlyTracking {
                self.trackLayer.backgroundColor = self .trackerActiveColor.cgColor
            } else {
                self.trackLayer.backgroundColor = self .trackerColor.cgColor
            }
            updateTracker()
        }
    }
    
    /**
    Limit to whole numbers
    */
    @IBInspectable public var LimitToInt: Bool = false {
        didSet {}
    }
    
    /// Send ValueChanged action when received longpress gesture
    @IBInspectable public var SendValueChangedOnPress: Bool = false {
        didSet {}
    }
    
    @IBInspectable public var Minimum: Double = 0.0 {
        didSet {
            print ("didSet Minimum: ", Minimum)
            updateTracker()
        }
    }
    
    @IBInspectable public var Maximum: Double = 100.0 {
        didSet {
            print ("didSet Maximum: ", Maximum)
            updateTracker()
        }
    }
    
    /// Current slider value
    @IBInspectable public var value: Double {
        set {
                self.currentValue = newValue
                self.updateTracker()
            }
        get { if LimitToInt { return round(currentValue) } else { return currentValue } }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 5 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = cornerRadius > 0
            self.trackLayer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable public var trackerColor: UIColor = UIColor.gray {
        didSet {
            trackLayer.backgroundColor = trackerColor.cgColor
            trackLayer.setNeedsDisplay()
        }
    }
    
    @IBInspectable public var trackerActiveColor: UIColor = UIColor.lightGray {
        didSet {
        }
    }
    
    
    @IBInspectable public var backColor: UIColor = UIColor.white {
        didSet {
            layer.backgroundColor = backColor.cgColor
            setNeedsDisplay()
        }
    }
    
    public var label: UILabel = UILabel() {
        didSet {}
    }

        
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayers()
    }
    
    
    /// return the x-position for the current Value
    private func positionForValue(value: Double) -> Double {
        let pos = Double(self.bounds.width) * (currentValue - self.Minimum) / (self.Maximum - self.Minimum)
        print ("Position for value \(currentValue) is \(pos) based on width: \(self.bounds.width)")
        return pos
    }
    
    /// return the value for the current position
    private func valueForPosition(position: CGFloat) -> Double {
        let val = self.Minimum + Double(position / self.bounds.width) * (self.Maximum-self.Minimum)
        print ("Value for position \(position) is \(val)")
        return val
    }
    
    // Layers
    
    override public func layoutSubviews() {
        super.layoutSubviews()
     
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        trackLayer.frame = CGRect(x: 0.0, y: 0.0, width: positionForValue(value: currentValue), height: Double(self.bounds.height))
        CATransaction.commit()

        valueLabel.frame = CGRect(x: self.bounds.midX - valueLabel.frame.width/2, y: self.bounds.midY - valueLabel.frame.height/2, width: 50, height: 15)
        if LimitToInt {
            valueLabel.text = String(format: "%.0f", self.value)
        } else {
            valueLabel.text = String(format: "%.2f", self.value)
        }
        
        label.frame = CGRect(x: 5, y: self.bounds.midY - label.frame.height/2, width: self.bounds.midX - self.valueLabel.frame.width, height: 20)
    }
    
    func setupLayers() {
        print ("Setting up layers")
        
        let rec = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        let longR = UILongPressGestureRecognizer(target: self, action: #selector(longPress(sender:)))
        
        self.addGestureRecognizer(rec)
        self.addGestureRecognizer(longR)
        
        trackLayer.backgroundColor = trackerColor.cgColor
        self.layer.backgroundColor = backColor.cgColor
        self.layer.addSublayer(trackLayer)
        
        valueLabel.textAlignment = .center
        valueLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(valueLabel)
        
        self.label.text = "Test"
        self.label.adjustsFontSizeToFitWidth = true
        self.addSubview(self.label)
        
        layoutSubviews()

    }
    

    
    func updateTracker() {
        // print ("updateTracker - Current position: ", positionForValue(value: self.Value))
        
        
        trackLayer.setNeedsDisplay()
        
        /*
        if self.LimitToInt { valueLabel.text = String(format: "%d", self.value) }
        else { valueLabel.text = String(format: "%.2f", self.value) }
        valueLabel.sizeToFit()
        */
    }
    
    // --MARK: Touches
    @objc private func longPress(sender: UILongPressGestureRecognizer) {
        switch (sender.state) {
        case .began:
            self.isCurrentlyTracking = true
            currentValue = valueForPosition(position: sender.location(in: self).x)
            if self.SendValueChangedOnPress { sendActions(for: .valueChanged) }
            
        case .changed:
            var currentPoint = sender.location(in: self)
            if currentPoint.x < 0 { currentPoint.x = 0 }
            else if currentPoint.x > self.bounds.width { currentPoint.x = self.bounds.width}
            currentValue = valueForPosition(position: currentPoint.x)
        case .ended:
            sendActions(for: .valueChanged)
            self.isCurrentlyTracking = false
        default:
            break
        }
        
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            sendActions(for: .primaryActionTriggered)
        }
    }
}
