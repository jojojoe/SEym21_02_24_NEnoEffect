//
//  IHymStickerTouchView.swift
//  IHymInstaHighlight
//
//  Created by JOJO on 2021/6/1.
//

import UIKit
 
class IHymStickerTouchView: TouchStuffView {

    var contentImageview: UIImageView!
    var deleteBtn: UIButton!
    var flipBtn: UIButton!
    var rotateBtn: UIImageView!
    var borderBgView: UIView!
    var borderColorHex: String = "#FFFFFF"
    let deleteBtnImgName: String = "edit_sticker_ic_delete"
    let rotateBtnImgName: String = "edit_sticker_ic_delete"
    var isTempleteSticker: Bool = false
    var templeteColorString: String = "000000" {
        didSet {
            if isTempleteSticker {
                contentImageview.tintColor = UIColor.init(hex: templeteColorString)
            }
        }
    }
    
    var stikerItem: NEymEditToolItem?
    
    var colorIndexPath: IndexPath = IndexPath.init(item: 0, section: 0)
    var itemIndexPath: IndexPath = IndexPath.init(item: 0, section: 0)
    var shapeAlpha: Float = 1.0
    
    
    var deleteActionBlock: ((_ touchView: TouchStuffView)->Void)?
    var rotateActionBlock: ((_ touchView: TouchStuffView)->Void)?
    var flipActionBlock: ((_ touchView: TouchStuffView)->Void)?
    
    
    
    init(withImage bgImage:UIImage, viewSize:CGSize, isTemplete: Bool = false) {
         super.init(frame: CGRect.init(x: 0, y: 0, width: viewSize.width, height: viewSize.height))
         isTempleteSticker = isTemplete
         setupView()
         setupActionBtns()
         setupContentImageView(contentImage: bgImage, viewSize: viewSize)
         setupBorderViewWithSize(viewSize: viewSize, lineColor: UIColor.init(hex: borderColorHex))
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width: CGFloat =  40
        deleteBtn.bounds = CGRect.init(x: 0, y: 0, width: width, height: width)
        deleteBtn.center = CGPoint.init(x: bounds.width, y: 0)
        
        rotateBtn.bounds = CGRect.init(x: 0, y: 0, width: width, height: width)
        rotateBtn.center = CGPoint.init(x: bounds.width, y: bounds.height)
        
        flipBtn.bounds = CGRect.init(x: 0, y: 0, width: width, height: width)
        flipBtn.center = CGPoint.init(x: 0, y: bounds.height)
        
        borderBgView.frame = bounds
        
    }
     
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let pointDeleteBtn = deleteBtn.convert(point, from: self)
        let pointRotateBtn = rotateBtn.convert(point, from: self)
        let pointFlipBtn = flipBtn.convert(point, from: self)
        if deleteBtn.bounds.contains(pointDeleteBtn) {
            return deleteBtn.hitTest(pointDeleteBtn, with: event)
        } else if rotateBtn.bounds.contains(pointRotateBtn) {
            return rotateBtn.hitTest(pointRotateBtn, with: event)
        } else if flipBtn.bounds.contains(pointFlipBtn) {
            return flipBtn.hitTest(pointFlipBtn, with: event)
        }
        return super.hitTest(point, with: event)
        
    }
    
    func touchViewButtonOppositTransform(oppositView: UIView) {
        let touchTransform: CGAffineTransform = self.transform
        let rotation: CGFloat = atan2(touchTransform.b, touchTransform.a)
        let scaleX: CGFloat = CGFloat(sqrtf(Float(touchTransform.a * touchTransform.a + touchTransform.c * touchTransform.c)))
        let scaleY: CGFloat = CGFloat(sqrtf(Float(touchTransform.b * touchTransform.b + touchTransform.d * touchTransform.d)))
        
        oppositView.transform = CGAffineTransform.init(scaleX: 1/scaleX, y: 1/scaleY)
        oppositView.transform = oppositView.transform.rotated(by: -rotation)
        
    }
    
    func touchViewBorderOppositTransform(view: UIView) {
        let touchTransform: CGAffineTransform = self.transform
        let scaleX: CGFloat = CGFloat(sqrtf(Float(touchTransform.a * touchTransform.a + touchTransform.c * touchTransform.c)))
        let scaleY: CGFloat = CGFloat(sqrtf(Float(touchTransform.b * touchTransform.b + touchTransform.d * touchTransform.d)))
        let scale: CGFloat = max(scaleX, scaleY)
        view.layer.shadowRadius = 4 / scale
        
    }
    
    override func updateBtnOppositTransform() {
        touchViewButtonOppositTransform(oppositView: deleteBtn)
        touchViewButtonOppositTransform(oppositView: rotateBtn)
        touchViewButtonOppositTransform(oppositView: flipBtn)
        touchViewBorderOppositTransform(view: borderBgView)
    }

    override func setHilight(_ flag: Bool) {
        super.setHilight(flag)
        
        deleteBtn.isHidden = !flag
        rotateBtn.isHidden = !flag
        flipBtn.isHidden = !flag
        borderBgView.isHidden = !flag
        
    }
    
    
}


extension IHymStickerTouchView {
    func setupView() {
        backgroundColor = UIColor.clear
        
    }
    
    func setupContentImageView(contentImage:UIImage, viewSize: CGSize) {
        
        let whRatio: CGFloat = contentImage.size.width / contentImage.size.height
        var imageWidth: CGFloat = viewSize.width
        var imageHeight: CGFloat = viewSize.height
        
        if whRatio >= 1 {
            imageHeight = imageWidth / whRatio;
        } else {
            imageWidth = imageHeight * whRatio;
        }
        
        let contentImageViewSize: CGSize = CGSize.init(width: imageWidth, height: imageHeight)
        
        contentImageview = UIImageView.init(frame: CGRect.init(x: (viewSize.width - contentImageViewSize.width) / 2, y: (viewSize.height - contentImageViewSize.height) / 2, width: contentImageViewSize.width, height: contentImageViewSize.height))
        if isTempleteSticker {

            contentImageview.image = contentImage.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            contentImageview.tintColor = UIColor.init(hex: templeteColorString)
        } else {
            contentImageview.image = contentImage
        }
        contentImageview.backgroundColor = UIColor.clear
        contentImageview.contentMode = .scaleAspectFit
        addSubview(contentImageview)
        sendSubviewToBack(contentImageview)
        
    }
}

extension IHymStickerTouchView {
    func setupActionBtns() {
        deleteBtn = UIButton.init(type: UIButton.ButtonType.custom)
        deleteBtn.setImage(UIImage(named: deleteBtnImgName), for: .normal)
        deleteBtn.addTarget(self, action: #selector(deleteBtnClick(_:)) , for: UIControl.Event.touchUpInside)
        addSubview(deleteBtn)

        
        
        rotateBtn = UIImageView.init(image: UIImage.init(named: rotateBtnImgName))
        rotateBtn.contentMode = .center
        rotateBtn.isUserInteractionEnabled = true
//        addSubview(rotateBtn)
        let panRotateGesture: UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(rotateButtonPanGestureDetected(_:)))
        rotateBtn.addGestureRecognizer(panRotateGesture)
        
        flipBtn = UIButton(type: .custom)
        flipBtn.setImage(UIImage(named: "flip_ic"), for: .normal)
        flipBtn.addTarget(self, action: #selector(flipBtnClick(_:)), for: .touchUpInside)
//        addSubview(flipBtn)
        
    }

    @objc
    func deleteBtnClick(_ btn: UIButton) {
        deleteActionBlock?(self)
    }
    
    @objc
    func flipBtnClick(_ btn: UIButton) {
        flipActionBlock?(self)
    }
    
    
    

    func setupBorderViewWithSize(viewSize: CGSize, lineColor:UIColor) {
        
        borderBgView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: viewSize.width, height: viewSize.width))
        borderBgView.layer.allowsEdgeAntialiasing = true
        borderBgView.isUserInteractionEnabled = false
        
        let dottedLineBorder: CAShapeLayer = CAShapeLayer.init()
        dottedLineBorder.frame = CGRect.init(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        dottedLineBorder.allowsEdgeAntialiasing = true
        borderBgView.layer.addSublayer(dottedLineBorder)
        dottedLineBorder.lineCap = .square
        dottedLineBorder.strokeColor = lineColor.cgColor
        dottedLineBorder.fillColor = UIColor.clear.cgColor
        dottedLineBorder.path = UIBezierPath.init(rect: CGRect.init(x: 0, y: 0, width: viewSize.width, height: viewSize.height)).cgPath
        dottedLineBorder.lineDashPattern = [5,5]
        borderBgView.layer.addSublayer(dottedLineBorder)
        
        insertSubview(borderBgView, at: 0)
        
    }



}


