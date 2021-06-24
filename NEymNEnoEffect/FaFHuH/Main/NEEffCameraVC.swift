//
//  NEEffCameraVC.swift
//  NEymNEnoEffect
//
//  Created by JOJO on 2021/6/22.
//

import UIKit
import DeviceKit


class NEEffCameraVC: UIViewController {

    let backBtn = UIButton(type: .custom)
    var cameraView: WQCameraView?
    var stickerOverlayerImgV = UIImageView()
    var sizeType: SIZeSelectView.SIZeType = .size_1_1
    let bgCanvasView = UIView()
    let canvasView = UIView()
    
    let didlayoutOnce: Once = Once()
    
    init(sizeType: SIZeSelectView.SIZeType = .size_1_1) {
        self.sizeType = sizeType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNotification()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.cameraView?.checkAuthorizedStatus()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.cameraView?.stopCameraSessionRunning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            [weak self] in
            guard let `self` = self else {return}
            self.didlayoutOnce.run {
                self.remakeLayout()
            }
            
        }
        
        
        
    }

}

extension NEEffCameraVC {
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector:#selector(becomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        //注册进入后台的通知
        NotificationCenter.default.addObserver(self, selector:#selector(becomeDeath), name: UIApplication.willResignActiveNotification, object: nil)
    }
    @objc
    func becomeActive(noti:Notification){
        DispatchQueue.main.async {
            [weak self] in
            guard let `self` = self else {return}
            self.cameraView?.checkAuthorizedStatus()
                
        }
        debugPrint("进入前台")
    }
    @objc
    func becomeDeath(noti:Notification){
        self.cameraView?.stopCameraSessionRunning()
        debugPrint("进入后台")
    }
}

extension NEEffCameraVC {
    func remakeLayout() {
        let W = bgCanvasView.bounds.size.width
        let H = bgCanvasView.bounds.size.height
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
//
        if self.cameraView?.superview != nil {
            self.cameraView?.removeFromSuperview()
        }
        let cameraView = WQCameraView(frame: CGRect(x: 0, y: 0, width: canW, height: canH))
        canvasView.addSubview(cameraView)
        cameraView.delegate = self
        self.cameraView = cameraView
        
    }
}

extension NEEffCameraVC {
    func setupView() {
        //
        view.backgroundColor = UIColor.black
        //
        view.addSubview(backBtn)
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        backBtn.setImage(UIImage(named: "ic_back"), for: .normal)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0)
            $0.left.equalTo(10)
            $0.width.height.equalTo(144/2)
        }
        //
        
        bgCanvasView.backgroundColor = .clear
        view.addSubview(bgCanvasView)
        
        bgCanvasView.snp.makeConstraints {
            $0.top.equalTo(backBtn.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(-240)
            $0.left.equalToSuperview()
        }
        //
        //
        canvasView.backgroundColor = UIColor.clear
        bgCanvasView.addSubview(canvasView)
        
         
        //
        let takePhotoBtn = UIButton(type: .custom)
        view.addSubview(takePhotoBtn)
        takePhotoBtn.setImage(UIImage(named: "photo_button"), for: .normal)
        takePhotoBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-80)
            $0.width.height.equalTo(232/2)
        }
        takePhotoBtn.addTarget(self, action: #selector(takePhotoBtnClick(sender:)), for: .touchUpInside)
        //
        let rotateCameraBtn = UIButton(type: .custom)
        view.addSubview(rotateCameraBtn)
        rotateCameraBtn.setImage(UIImage(named: "photo_overturn"), for: .normal)
        rotateCameraBtn.snp.makeConstraints {
            $0.left.equalTo(takePhotoBtn.snp.right).offset(24)
            $0.centerY.equalTo(takePhotoBtn)
            $0.width.height.equalTo(140/2)
        }
        rotateCameraBtn.addTarget(self, action: #selector(rotateCameraBtnClick(sender:)), for: .touchUpInside)
         
        
    }
    
    
    
}

extension NEEffCameraVC {
    @objc func backBtnClick(sender: UIButton) {
        
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func takePhotoBtnClick(sender: UIButton) {
        self.cameraView?.takePhoto()
    }
    @objc func rotateCameraBtnClick(sender: UIButton) {
        self.cameraView?.rotateCamera()
    }
     
    
    
}



extension NEEffCameraVC: CameraViewControllerDelegate {
     
    func didFinishProcessingPhoto(_ image: UIImage) {
        debugPrint(image)
        self.showEditVC(image: image)
    }
    
    func showEditVC(image: UIImage) {
       
        let editVC = EDItVC(sizeType: sizeType, contentImg: image)
        self.navigationController?.pushViewController(editVC)
    }
}

