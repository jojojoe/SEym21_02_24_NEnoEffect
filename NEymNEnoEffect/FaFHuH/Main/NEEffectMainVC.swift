//
//  NEEffectMainVC.swift
//  NEymNEnoEffect
//
//  Created by JOJO on 2021/6/18.
//

import UIKit
import Photos
import YPImagePicker


class NEEffectMainVC: UIViewController, UINavigationControllerDelegate {
    let sizeTypeView = SIZeSelectView()
    var currentActionType: String = "" // album  camera
    var currentSizeType: SIZeSelectView.SIZeType = .size_1_1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSizeSelectView()
        showLoginVC()
        
    }
    
    
    

}

extension NEEffectMainVC {
    func setupView() {
        view.backgroundColor = .white
        let bgImgV = UIImageView(image: UIImage(named: "home_background"))
        bgImgV.contentMode = .scaleAspectFill
        view.addSubview(bgImgV)
        bgImgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        //
        let contentBgView = UIView()
        contentBgView.backgroundColor = .clear
        view.addSubview(contentBgView)
        contentBgView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.greaterThanOrEqualTo(1)
        }
        //
        let topImgV = UIImageView(image: UIImage(named: "home_neon"))
        topImgV.contentMode = .scaleAspectFill
        contentBgView.addSubview(topImgV)
        topImgV.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-50)
            $0.centerX.equalToSuperview()
            $0.width.greaterThanOrEqualTo(1)
            $0.height.greaterThanOrEqualTo(534/2)
        }
        //
        let storeBtn = UIButton(type: .custom)
        storeBtn.setImage(UIImage(named: "home_store"), for: .normal)
        contentBgView.addSubview(storeBtn)
        storeBtn.snp.makeConstraints {
            $0.top.equalTo(topImgV.snp.bottom).offset(-60)
            $0.centerX.equalToSuperview()
            $0.width.greaterThanOrEqualTo(1)
            $0.height.equalTo(260/2)
        }
        storeBtn.addTarget(self, action: #selector(storeBtnClick(sender:)), for: .touchUpInside)
        //
        let settingBtn = UIButton(type: .custom)
        settingBtn.setImage(UIImage(named: "home_setting"), for: .normal)
        contentBgView.addSubview(settingBtn)
        settingBtn.snp.makeConstraints {
            $0.top.equalTo(storeBtn.snp.bottom).offset(-20)
            $0.centerX.equalToSuperview()
            $0.width.greaterThanOrEqualTo(1)
            $0.height.equalTo(260/2)
        }
        settingBtn.addTarget(self, action: #selector(settingBtnClick(sender:)), for: .touchUpInside)
        //
        let createBtn = UIButton(type: .custom)
        createBtn.setImage(UIImage(named: "home_create"), for: .normal)
        contentBgView.addSubview(createBtn)
        createBtn.snp.makeConstraints {
            $0.top.equalTo(settingBtn.snp.bottom).offset(-20)
            $0.centerX.equalToSuperview()
            $0.width.greaterThanOrEqualTo(1)
            $0.height.equalTo(260/2)
        }
        createBtn.addTarget(self, action: #selector(createBtnClick(sender:)), for: .touchUpInside)
        //
        let photoBtn = UIButton(type: .custom)
        photoBtn.setImage(UIImage(named: "home_photo"), for: .normal)
        contentBgView.addSubview(photoBtn)
        photoBtn.snp.makeConstraints {
            $0.top.equalTo(createBtn.snp.bottom).offset(-20)
            $0.centerX.equalToSuperview()
            $0.width.greaterThanOrEqualTo(1)
            $0.height.equalTo(260/2)
            $0.bottom.equalTo(contentBgView.snp.bottom)
        }
        photoBtn.addTarget(self, action: #selector(photoBtnClick(sender:)), for: .touchUpInside)
        
    }
    
    func setupSizeSelectView() {
        
        sizeTypeView.alpha = 0
        view.addSubview(sizeTypeView)
        sizeTypeView.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        sizeTypeView.okBtnClickBlock = {
            [weak self] type in
            guard let `self` = self else {return}
            
            self.currentSizeType = type
            
            if type == .size_16_9 {
                self.action16_9Type()
            } else {
                self.action1_1Type()
            }
            
            UIView.animate(withDuration: 0.25) {
                self.sizeTypeView.alpha = 0
            }
        }
        sizeTypeView.cancelBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            UIView.animate(withDuration: 0.25) {
                self.sizeTypeView.alpha = 0
            }
        }
    }
    
    @objc func storeBtnClick(sender: UIButton) {
        let vC = NEEffectStoreVC()
        self.navigationController?.pushViewController(vC)
    }
    @objc func settingBtnClick(sender: UIButton) {
        let vC = NEEffectSetVC()
        self.navigationController?.pushViewController(vC)
    }
    @objc func createBtnClick(sender: UIButton) {
        showSizeTypeView(itemStr: "album")
    }
    @objc func photoBtnClick(sender: UIButton) {
        showSizeTypeView(itemStr: "camera")
    }
    
    
    func showLoginVC() {
        if LoginMNG.currentLoginUser() == nil {
            let loginVC = LoginMNG.shared.obtainVC()
            loginVC.modalTransitionStyle = .crossDissolve
            loginVC.modalPresentationStyle = .fullScreen
            
            self.present(loginVC, animated: true) {
            }
        }
    }
    
    // album  camera
    func showSizeTypeView(itemStr: String) {
        currentActionType = itemStr
        
        UIView.animate(withDuration: 0.35) {
            self.sizeTypeView.alpha = 1
        }
    }
    
    func action16_9Type() {
//        testShowEdit()
        if currentActionType == "album" {
            checkAlbumAuthorization()
        } else {
            checkCameraAuthor()
        }
    }
    
    func action1_1Type() {
//        testShowEdit()
        if currentActionType == "album" {
            checkAlbumAuthorization()
        } else {
            checkCameraAuthor()
        }
    }
    
    
    func testShowEdit() {
        // size_16_9 size_1_1
        let editVC = EDItVC(sizeType: .size_16_9, contentImg: UIImage(named: "login_background")!)
        self.navigationController?.pushViewController(editVC)
    }
    
}

extension NEEffectMainVC: UIImagePickerControllerDelegate {
    
    func checkAlbumAuthorization() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                switch status {
                case .authorized:
                    DispatchQueue.main.async {
                        self.presentPhotoPickerController()
                    }
                case .limited:
                    DispatchQueue.main.async {
                        self.presentLimitedPhotoPickerController()
                    }
                case .notDetermined:
                    if status == PHAuthorizationStatus.authorized {
                        DispatchQueue.main.async {
                            self.presentPhotoPickerController()
                        }
                    } else if status == PHAuthorizationStatus.limited {
                        DispatchQueue.main.async {
                            self.presentLimitedPhotoPickerController()
                        }
                    }
                case .denied:
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
                    
                case .restricted:
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
                default: break
                }
            }
        }
    }
    
    func presentLimitedPhotoPickerController() {
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 1
        config.screens = [.library]
        config.library.defaultMultipleSelection = false
        config.library.skipSelectionsGallery = true
        config.showsPhotoFilters = false
        config.library.preselectedItems = nil
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            var imgs: [UIImage] = []
            for item in items {
                switch item {
                case .photo(let photo):
                    if let img = photo.image.scaled(toWidth: 1200) {
                        imgs.append(img)
                    }
                    print(photo)
                case .video(let video):
                    print(video)
                }
            }
            picker.dismiss(animated: true, completion: nil)
            if !cancelled {
                if let image = imgs.first {
                    self.showEditVC(image: image)
                }
            }
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    
    
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        picker.dismiss(animated: true, completion: nil)
//        var imgList: [UIImage] = []
//
//        for result in results {
//            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
//                if let image = object as? UIImage {
//                    DispatchQueue.main.async {
//                        // Use UIImage
//                        print("Selected image: \(image)")
//                        imgList.append(image)
//                    }
//                }
//            })
//        }
//        if let image = imgList.first {
//            self.showEditVC(image: image)
//        }
//    }
    
 
    func presentPhotoPickerController() {
        let myPickerController = UIImagePickerController()
        myPickerController.allowsEditing = false
        myPickerController.delegate = self
        myPickerController.sourceType = .photoLibrary
        self.present(myPickerController, animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.showEditVC(image: image)
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.showEditVC(image: image)
        }

    }
//
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func showEditVC(image: UIImage) {
        let editVC = EDItVC(sizeType: currentSizeType, contentImg: image)
        self.navigationController?.pushViewController(editVC)
    }

}


extension NEEffectMainVC {
    func checkCameraAuthor() {
        func showVC() {
            DispatchQueue.main.async {
                [weak self] in
                guard let `self` = self else {return}
                let vc = NEEffCameraVC(sizeType: self.currentSizeType)
                self.navigationController?.pushViewController(vc)
            }

        }
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            showVC()
            break
        case .notDetermined:
            
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    if !granted {
                        // not notAuthorized
                        self.showCameraSettingAlertVC()
                    }
    //                Authorized
                    showVC()
                }
            })
        default:
        // not notAuthorized
            showCameraSettingAlertVC()
            break
        }
    }
    
    func showCameraSettingAlertVC() {
        DispatchQueue.main.async {
            [weak self] in
            guard let `self` = self else {return}
            let alert = UIAlertController(title: "Oops", message: "You have declined access to camera, please active it in Settings>Privacy>Camera.", preferredStyle: .alert)
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

 
