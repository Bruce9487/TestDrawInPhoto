//
//  CanvasView.swift
//  TestDrawInPhoto
//
//  Created by APP技術部-陳冠志 on 2019/9/19.
//  Copyright © 2019 Bruce Chen. All rights reserved.
//

import UIKit

class CanvasImageView: UIImageView {

    var lineColor = UIColor.red
    var lineWidth: CGFloat = 10
    var path: UIBezierPath?
    var touchPoint: CGPoint!
    var startingPoint: CGPoint!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        self.startingPoint = touches.first?.location(in: self)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchPoint = touches.first?.location(in: self)
        self.path = UIBezierPath()
        path?.move(to: startingPoint)
        path?.addLine(to: touchPoint)
        self.startingPoint = touchPoint
        self.draw()
    }

    func draw() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path?.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(shapeLayer)
        self.setNeedsDisplay()
    }

    func clearCanvas() {
        guard let drawPath = path else { return }
        drawPath.removeAllPoints()
        self.layer.sublayers = nil
        self.setNeedsDisplay()
    }
}
