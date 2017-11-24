//
//  ViewController.swift
//  TextAnimation
//
//  Created by Dinh Thanh An on 11/24/17.
//  Copyright © 2017 Elisoft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textDrawingView: TextDrawingView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textDrawingView.text = "Hi An!"
        textDrawingView.color = .red
        textDrawingView.lineWidth = 2
    }

    @IBAction func animateButtonPressed(_ sender: Any) {
        textDrawingView.startAnimation()
    }
    
}

class TextDrawingView: UIView {
    
    public var text: String = "" {
        didSet { createLayers(from: text)}
    }
    
    public var color: UIColor = .black {
        didSet { shapeLayers.forEach { $0.strokeColor = color.cgColor } }
    }
    
    public var lineWidth: CGFloat = 1 {
        didSet { shapeLayers.forEach { $0.lineWidth = lineWidth } }
    }
    
    public func startAnimation() {
        animateLayers()
    }
    private var shapeLayers = [CAShapeLayer]()
    
    private func createLayers(from text: String) {
        
        let spacing: CGFloat = 10
        let mesurementPath = UIBezierPath()
        for (index, character) in text.enumerated() {
            
            let path = bezierPath(from: character)
            let translation = mesurementPath.cgPath.boundingBox.width + spacing * min(CGFloat(index), 1)
            let transform = CGAffineTransform(translationX: translation, y: 0)
            path.apply(transform)
            mesurementPath.append(path)
            
            let layer = CAShapeLayer()
            layer.path = path.cgPath
//            layer.lineWidth = 1
            layer.strokeEnd = 0
//            layer.strokeColor = UIColor.black.cgColor
            layer.fillColor = UIColor.clear.cgColor
            layer.isGeometryFlipped = true
            layer.frame = bounds
            self.layer.addSublayer(layer)
            shapeLayers.append(layer)
        }
    }
    
    private func bezierPath(from character: Character) -> UIBezierPath {
        let font = UIFont.systemFont(ofSize: 50)
        var unichars = [UniChar]("\(character)".utf16)
        var glyphs = [CGGlyph](repeating: 0, count: unichars.count)
        
        let gotGlyphs = CTFontGetGlyphsForCharacters(font, &unichars, &glyphs, unichars.count)
        
        if gotGlyphs, let path = CTFontCreatePathForGlyph(font, glyphs[0], nil) {
            return UIBezierPath(cgPath: path)
        } else {
            return UIBezierPath()
        }
    }
    
    func animateLayers() {
        
        for (index, layer) in shapeLayers.enumerated() {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.beginTime = CACurrentMediaTime() + CFTimeInterval(index) * 0.5
            animation.toValue = 1
            animation.duration = 1
            animation.fillMode = kCAFillModeForwards
            animation.isRemovedOnCompletion = false
            layer.add(animation, forKey: "animation")
        }
        
    }
}

