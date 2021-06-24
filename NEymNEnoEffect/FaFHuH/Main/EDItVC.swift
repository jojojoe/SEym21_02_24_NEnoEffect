//
//  EDItVC.swift
//  NEymNEnoEffect
//
//  Created by JOJO on 2021/6/18.
//

import UIKit
import Photos

class EDItVC: UIViewController {

    var sizeType: SIZeSelectView.SIZeType
    var contentImg: UIImage
    
    let backBtn = UIButton(type: .custom)
    let saveBtn = UIButton(type: .custom)
    let bottomBarBgView = UIView()
    let cavnasBgView = UIView()
    let canvasView = UIView()
    
    let canvasBgImgV = UIImageView()
    let canvasPhotoImgV = UIImageView()
    let canvasBorderImgV = UIImageView()
    let borderToolBar: EDitToolBorderBar
    let bgcolorToolBar: EDitToolBGColorBar = EDitToolBGColorBar()
    let stickerToolBar = EDitToolSTickerBar()
    let brushToolBar = EDitToolBrushBar()
    var paintContentView : MaskView!
    let coinAlertView = SAveCOInAlertView()
    var shouldCostCoin: Bool = false
    
    var isCurrentBorderPro: Bool = false
    var isModify : Bool = false
    
    init(sizeType: SIZeSelectView.SIZeType, contentImg: UIImage) {
        self.sizeType = sizeType
        self.contentImg = contentImg
        self.borderToolBar = EDitToolBorderBar(frame: .zero, sizeType: sizeType)
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setupView()
        setupCoinAlertView()
        setupDafultFirstStatus()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        remakeLayout()
    }
    
    func remakeLayout() {
        let W = cavnasBgView.bounds.size.width
        let H = cavnasBgView.bounds.size.height
        var canW: CGFloat = W
        var canH: CGFloat = H
        
        if sizeType == .size_16_9 {
            if (W / H) > (9 / 16) {
                canW = H * (9/16)
            } else {
                canH = W / (9/16)
            }
        } else {
            canH = W
        }
        
        canvasView.snp.remakeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(canW)
            $0.height.equalTo(canH)
        }
        canvasBgImgV.snp.remakeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(canW)
            $0.height.equalTo(canH)
            
        }
        canvasPhotoImgV.snp.remakeConstraints {
            $0.center.equalTo(canvasView)
            $0.width.equalTo(canW * 0.9)
            $0.height.equalTo(canH * 0.9)
        }
        canvasBorderImgV.snp.remakeConstraints {
            $0.center.equalTo(canvasView)
            $0.width.equalTo(canW * 0.9)
            $0.height.equalTo(canH * 0.9)
        }
    }
    

}

extension EDItVC {
   
    func setupView() {
        view.addSubview(backBtn)
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        backBtn.setImage(UIImage(named: "ic_back"), for: .normal)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0)
            $0.left.equalTo(10)
            $0.width.height.equalTo(144/2)
        }
        //
        view.addSubview(saveBtn)
        saveBtn.addTarget(self, action: #selector(saveBtnClick(sender:)), for: .touchUpInside)
        saveBtn.setImage(UIImage(named: "ic_save"), for: .normal)
        saveBtn.snp.makeConstraints {
            $0.centerY.equalTo(backBtn)
            $0.right.equalTo(-4)
            $0.width.height.equalTo(194/2)
            $0.height.height.equalTo(152/2)
             
        }
        //

        bottomBarBgView.backgroundColor = .black
        view.addSubview(bottomBarBgView)
        bottomBarBgView.snp.makeConstraints {
            $0.height.equalTo(250)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        //
        view.addSubview(cavnasBgView)
        cavnasBgView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(backBtn.snp.bottom).offset(10)
            $0.bottom.equalTo(bottomBarBgView.snp.top).offset(-10)
        }
        //
        
        canvasView.backgroundColor = .white
        //
        canvasView.addSubview(canvasBgImgV)
        canvasBgImgV.clipsToBounds = true
        canvasBgImgV.contentMode = .scaleAspectFill
        //
        cavnasBgView.addSubview(canvasView)
        canvasView.clipsToBounds = true
        //
 
        canvasView.addSubview(canvasPhotoImgV)
        canvasPhotoImgV.clipsToBounds = true
        canvasView.addSubview(canvasBorderImgV)
        canvasPhotoImgV.contentMode = .scaleAspectFill
        canvasBorderImgV.contentMode = .scaleAspectFit
        // bursh paint content view
        paintContentView = MaskView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height))
        canvasView.addSubview(paintContentView)
        paintContentView.perPaintMoveCompletion = {[weak self] canBeforeAction, canNextAction in
            guard let `self` = self else { return }
//            self.isModify = true
        }
        showPaintContentView(isInteractionEnabled: false)
        
        
        //
        let toolFuBar = EDItToolFuBar()
        bottomBarBgView.addSubview(toolFuBar)
        toolFuBar.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(80)
        }
        toolFuBar.btnClickBlock = {
            [weak self] type in
            guard let `self` = self else {return}
            if type == "bg" {
                self.showBar(bar: self.bgcolorToolBar)
            } else if type == "border" {
                self.showBar(bar: self.borderToolBar)
            } else if type == "sticker" {
                self.showBar(bar: self.stickerToolBar)
            } else if type == "brush" {
                self.showBar(bar: self.brushToolBar)
            }
        }
        
        
        //
        borderToolBar.isHidden = true
        bottomBarBgView.addSubview(borderToolBar)
        borderToolBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        borderToolBar.closeBtnBlock = {
            [weak self] in
            guard let `self` = self else {return}
            self.borderToolBar.isHidden = true
        }
        borderToolBar.selectBorderItemBlock = {
            [weak self] item, isPro in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.updateBorder(item: item)
            }
        }
        //
        bgcolorToolBar.isHidden = true
        bottomBarBgView.addSubview(bgcolorToolBar)
        bgcolorToolBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        bgcolorToolBar.closeBtnBlock = {
            [weak self] in
            guard let `self` = self else {return}
            self.bgcolorToolBar.isHidden = true
        }
        bgcolorToolBar.selectBorderItemBlock = {
            [weak self] item, isPro in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.updateCanvasBgColor(item: item)
            }
        }
        //
        stickerToolBar.isHidden = true
        bottomBarBgView.addSubview(stickerToolBar)
        stickerToolBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        stickerToolBar.closeBtnBlock = {
            [weak self] in
            guard let `self` = self else {return}
            self.stickerToolBar.isHidden = true
            TMTouchAddonManager.default.cancelCurrentAddonHilightStatus()
            
        }
        stickerToolBar.selectItemBlock = {
            [weak self] item, isPro in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.addSticker(stickerItem: item)
            }
        }
        //
        brushToolBar.isHidden = true
        bottomBarBgView.addSubview(brushToolBar)
        brushToolBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        brushToolBar.closeBtnBlock = {
            [weak self] in
            guard let `self` = self else {return}
            self.brushToolBar.isHidden = true
            self.showPaintContentView(isInteractionEnabled: false)
        }
        brushToolBar.clearAllPathAction = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.clearBrushAllPath()
            }
        }
        brushToolBar.lineWidthStrengthBlock = {
            [weak self] lineWidth in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.updateLineWidth(lineWidthStrength: lineWidth)
            }
        }
        brushToolBar.selectBorderItemBlock = {
            [weak self] brushItem, isPro in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.updatePaintBrushStyle(item: brushItem)
            }
        }
    }
    
    func setupDafultFirstStatus() {
        canvasView.backgroundColor = .white
        canvasPhotoImgV.image = contentImg
        updatePaintBrushStyle(item: NEEDataM.default.paintStyleItemList.first!)
        
    }
    
    func showBar(bar: UIView) {
        
        DispatchQueue.main.async {
            TMTouchAddonManager.default.cancelCurrentAddonHilightStatus()
            self.borderToolBar.isHidden = true
            self.bgcolorToolBar.isHidden = true
            self.stickerToolBar.isHidden = true
            self.brushToolBar.isHidden = true
            bar.isHidden = false
            if bar == self.brushToolBar {
                self.showPaintContentView(isInteractionEnabled: true)
            }
        }
        
    }
    
    func setupCoinAlertView() {
        
        coinAlertView.alpha = 0
        view.addSubview(coinAlertView)
        coinAlertView.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        coinAlertView.okBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            
            if NEyCoinManag.default.coinCount >= NEyCoinManag.default.coinCostCount {
                DispatchQueue.main.async {
                    self.shouldCostCoin = true
                    if let resultImg = self.canvasView.screenshot {
                        self.saveToAlbumPhotoAction(images: [resultImg])
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "", message: "Not enough coins, please buy first.", buttonTitles: ["OK"], highlightedButtonIndex: 0) { i in
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            self.navigationController?.pushViewController(NEEffectStoreVC())
                        }
                    }
                }
            }
            UIView.animate(withDuration: 0.25) {
                self.coinAlertView.alpha = 0
            }
        }
        coinAlertView.cancelBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            UIView.animate(withDuration: 0.25) {
                self.coinAlertView.alpha = 0
            }
        }
    }
    
}

extension EDItVC {
    func updateCanvasBgColor(item: NEymEditToolItem) {
        isModify = true
        if item.thumbName.contains("#") {
            canvasBgImgV.image = nil
            canvasBgImgV.backgroundColor = UIColor(hexString: item.bigName)
        } else {
            canvasBgImgV.image = UIImage(named: item.bigName)
        }
    }
    func updateBorder(item: NEymEditToolItem) {
        isModify = true
        canvasBorderImgV.image = UIImage(named: item.bigName)
        isCurrentBorderPro = item.isPro
        
    }
    func addSticker(stickerItem: NEymEditToolItem) {
        isModify = true
        if let stickerImg = UIImage(named: stickerItem.bigName) {
            TMTouchAddonManager.default.addNewStickerAddonWithStickerImage(stickerImage: stickerImg, stickerItem: stickerItem, atView: canvasView)
        }
        
    }
    func updatePaintBrushStyle(item: GCPaintItem) {
        
        MaskConfigManager.sharedInstance().lineColorOne = UIColor.init(hexString: item.gradualColorOne) ?? UIColor.white
        MaskConfigManager.sharedInstance().lineColorTwo = UIColor.init(hexString: item.gradualColorTwo) ?? UIColor.white
        if item.StrokeType == "Normal" {
            MaskConfigManager.sharedInstance().strokeType = .normal
        } else {
            MaskConfigManager.sharedInstance().strokeType = .gradient
        }
    }
    func updateLineWidth(lineWidthStrength: Int) {
        isModify = true
        MaskConfigManager.sharedInstance().lineWidth = CGFloat(lineWidthStrength)
    }
    func clearBrushAllPath() {
        self.paintContentView.clearPath()
    }
    
    func showPaintContentView(isInteractionEnabled:Bool)  {
        if isInteractionEnabled == true {
            isModify = true
        }
        
        paintContentView.isUserInteractionEnabled = isInteractionEnabled
        paintContentView.touchView.canEditStatus = isInteractionEnabled
    }
    
}


extension EDItVC {
    @objc func backBtnClick(sender: UIButton) {
        func backAction() -> Void {
            TMTouchAddonManager.default.cancelCurrentAddonHilightStatus()
            TMTouchAddonManager.default.clearAddonManagerDefaultStatus()
            
            if self.navigationController != nil {
                self.navigationController?.popViewController()
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
        if isModify == true {
            showAlert(title: "Are you sure you want to exit, your operation will not be saved.", message: nil, buttonTitles: ["Cancel", "OK"], highlightedButtonIndex: 0) { index in
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    if index == 1 {
                        backAction()
                    }
                }
            }
        } else {
            backAction()
        }
    }
    
    @objc func saveBtnClick(sender: UIButton) {
        TMTouchAddonManager.default.cancelCurrentAddonHilightStatus()
        
        var isStickerPro: Bool = false
        
        for sticker in TMTouchAddonManager.default.addonStickersList {
            if sticker.stikerItem?.isPro == true {
                isStickerPro = true
                break
            }
        }
        if isStickerPro || isCurrentBorderPro {
            // 收费
            UIView.animate(withDuration: 0.35) {
                self.coinAlertView.alpha = 1
            }
        } else {
            // 免费
            if let resultImg = canvasView.screenshot {
                self.saveToAlbumPhotoAction(images: [resultImg])
            }
            
        }
        
        
    }
    
}

extension EDItVC {
    func saveToAlbumPhotoAction(images: [UIImage]) {
        DispatchQueue.main.async(execute: {
            PHPhotoLibrary.shared().performChanges({
                [weak self] in
                guard let `self` = self else {return}
                for img in images {
                    PHAssetChangeRequest.creationRequestForAsset(from: img)
                }
                
                
            }) { (finish, error) in
                if finish {
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let `self` = self else {return}
                        self.showSaveSuccessAlert()
                        if self.shouldCostCoin {
                            NEyCoinManag.default.costCoin(coin: NEyCoinManag.default.coinCostCount)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let `self` = self else {return}
                        if error != nil {
                            let auth = PHPhotoLibrary.authorizationStatus()
                            if auth != .authorized {
                                self.showDenideAlert()
                            }
                        }
                    }
                }
            }
        })
    }
    
    func showSaveSuccessAlert() {
        HUD.success("Photo save successful.")
    }
    
    func showDenideAlert() {
        DispatchQueue.main.async {
            [weak self] in
            guard let `self` = self else {return}
            let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                DispatchQueue.main.async {
                    let url = URL(string: UIApplication.openSettingsURLString)!
                    UIApplication.shared.open(url, options: [:])
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true)
        }
    }
    
}
