//
//  File.swift
//  HW12
//
//  Created by Helena on 29.06.2023.
//

import UIKit

class CircularProgressBarView: UIView {

    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var startPoint = CGFloat(3 * Double.pi / 2)
    private var endPoint = CGFloat(-Double.pi / 2)

    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createCircularPath()
    }

    private func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: 120, startAngle: startPoint, endAngle: endPoint, clockwise: false)
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 8.0
        circleLayer.strokeEnd = 1
        circleLayer.strokeColor = UIColor.white.cgColor
        circleLayer.opacity = 0.5
        layer.addSublayer(circleLayer)

        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 8.0
        progressLayer.strokeColor = UIColor.clear.cgColor
        layer.addSublayer(progressLayer)
    }
    
    func resetAnimation() {
        progressLayer.strokeColor = UIColor.clear.cgColor
    }

    func pauseAnimation() {
        let pausedTime: CFTimeInterval = progressLayer.convertTime(CACurrentMediaTime(), from: nil)
        progressLayer.speed = 0.0
        progressLayer.timeOffset = pausedTime
    }

    func resumeAnimation() {
        let pausedTime: CFTimeInterval = progressLayer.timeOffset
        progressLayer.speed = 1.0
        progressLayer.timeOffset = 0.0
        progressLayer.beginTime = 0.0
        let timeSincePause: CFTimeInterval = progressLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        progressLayer.beginTime = timeSincePause
    }

    func progressAnimation(duration: TimeInterval, from: CGFloat, to: CGFloat, isWorkTime: inout Bool) {
        if isWorkTime {
            progressLayer.strokeColor = UIColor.systemGreen.cgColor
        } else {
            progressLayer.strokeColor = UIColor.systemRed.cgColor
        }
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        progressLayer.strokeEnd = from
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = to
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        if progressLayer.zPosition == to {
            isWorkTime.toggle()
        }
        
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
}
