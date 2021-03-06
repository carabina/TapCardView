//
//  TapCardView.swift
//  TapCardView
//
//  Created by jinsei shima on 2017/12/31.
//  Copyright © 2017 jinsei shima. All rights reserved.
//

import UIKit

enum TapPosition {

    case left, right, bottom
}

protocol CardViewDelegate: class {

    func tapPosition(type: TapPosition)
}

class TapCardView: UIView {

    weak var delegate: CardViewDelegate?

    // border of tap position. ratio of width and height.
    var horizontalBorder: CGFloat = 0.5
    var verticalBorder: CGFloat = 0.75

    // flip animation settings
    var flipDegree: Float = 14
    var flipDuration = 0.24

    override init(frame: CGRect) {

        super.init(frame: frame)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(sender:)))
        addGestureRecognizer(tapGesture)
    }

    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    @objc func tapGesture(sender: UITapGestureRecognizer) {

        if sender.state == .ended {

            let tapPoint = sender.location(in: self)
            let tapPosition = getTapPosition(point: tapPoint, size: bounds.size)

            switch tapPosition {
            case .left:
                delegate?.tapPosition(type: .left)
            case .right:
                delegate?.tapPosition(type: .right)
            case .bottom:
                delegate?.tapPosition(type: .bottom)
            }
        }
    }

    func getTapPosition(point: CGPoint, size: CGSize) -> TapPosition {

        if(point.y >= size.height * verticalBorder) {
            return .bottom
        }
        else if(point.x >= size.width * horizontalBorder) {
            return .right
        }
        else {
            return .left
        }
    }

    func flipCard(type: TapPosition) {

        if type == .bottom { return }

        // degree of rotation, when left end or right end.
        let radius: Float = (type == .left) ? flipDegree : -flipDegree
        let duration = flipDuration

        UIView.animateKeyframes(withDuration: duration, delay: 0, options: [], animations: {
            let transform = CATransform3DIdentity
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: duration/2, animations: {
                self.layer.transform = CATransform3DRotate(transform, self.degree2radian(d: radius), 0, 1, 0)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: duration/2, animations: {
                self.layer.transform = CATransform3DRotate(transform, self.degree2radian(d: 0), 0, 1, 0)
            })
        }, completion: nil)
    }

    fileprivate func degree2radian(d: Float) -> CGFloat {

        let r = Float.pi * d/180
        return CGFloat(r)
    }
}

