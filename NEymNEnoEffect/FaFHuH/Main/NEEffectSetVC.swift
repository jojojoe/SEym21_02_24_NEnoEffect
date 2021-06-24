//
//  NEEffectSetVC.swift
//  NEymNEnoEffect
//
//  Created by JOJO on 2021/6/18.
//

import UIKit
import MessageUI
import StoreKit
import Defaults
import NoticeObserveKit
import DeviceKit

let AppName: String = "NeoFlu"
let purchaseUrl = ""
let TermsofuseURLStr = "http://elated-toad.surge.sh/Terms_of_use.html"
let PrivacyPolicyURLStr = "http://abusive-art.surge.sh/Privacy_Agreement.html"
let feedbackEmail: String = "jascksongoshi@yandex.com"
let AppAppStoreID: String = ""


class NEEffectSetVC: UIViewController {

    
    let userNameLabel = UILabel()
    let feedbackBtn = SettingContentBtn(frame: .zero, name: "Feedback", iconImage: UIImage(named: "setting_feedback")!)
    let privacyLinkBtn = SettingContentBtn(frame: .zero, name: "Privacy Policy", iconImage: UIImage(named: "setting_privacy")!)
    let termsBtn = SettingContentBtn(frame: .zero, name: "Terms of use", iconImage: UIImage(named: "setting_term")!)
    let logoutBtn = SettingContentBtn(frame: .zero, name: "Log out", iconImage: UIImage(named: "setting_logout")!)
    let loginBtn = SettingContentBtn(frame: .zero, name: "Log in", iconImage: UIImage(named: "setting_login")!)
    let backBtn = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
         
        setupView()
        setupContentView()
        updateUserAccountStatus()
        
    }
    
}

extension NEEffectSetVC {
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension NEEffectSetVC {
    func setupView() {
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
        userNameLabel.font = UIFont(name: "Avenir-Black", size: 20)
        userNameLabel.layer.shadowColor = UIColor(hexString: "#01FFFA")?.cgColor
        userNameLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        userNameLabel.layer.shadowRadius = 3
        userNameLabel.layer.shadowOpacity = 0.8
        userNameLabel.textColor = UIColor(hexString: "#01FFFA")
        userNameLabel.textAlignment = .center
        userNameLabel.text = "Log in"
        view.addSubview(userNameLabel)
        userNameLabel.adjustsFontSizeToFitWidth = true
        userNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(backBtn)
            $0.centerX.equalToSuperview()
            $0.left.equalTo(backBtn.snp.right).offset(20)
            $0.height.greaterThanOrEqualTo(1)
        }
        //
        
        
    }
    //
    func setupContentView() {
        view.addSubview(loginBtn)
        loginBtn.clickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            self.showLoginVC()
        }
        loginBtn.snp.makeConstraints {
            $0.width.equalTo(700/2)
            $0.height.equalTo(232/2)
            $0.top.equalTo(backBtn.snp.bottom).offset(60)
            $0.centerX.equalToSuperview()
        }
        
        // logout
        view.addSubview(logoutBtn)
        logoutBtn.clickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            LoginMNG.shared.logout()
            self.updateUserAccountStatus()
        }
        logoutBtn.snp.makeConstraints {
            $0.width.equalTo(700/2)
            $0.height.equalTo(232/2)
            $0.top.equalTo(loginBtn)
            $0.centerX.equalToSuperview()
        }
        
        // feedback
        view.addSubview(feedbackBtn)
        feedbackBtn.clickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            self.feedback()
        }
        feedbackBtn.snp.makeConstraints {
            $0.width.equalTo(700/2)
            $0.height.equalTo(232/2)
            $0.top.equalTo(loginBtn.snp.bottom).offset(-15)
            $0.centerX.equalToSuperview()
        }
        
//        if Device.current.diagonal == 4.7 || Device.current.diagonal > 7 {
//            feedbackBtn.snp.makeConstraints {
//                $0.width.equalTo(357)
//                $0.height.equalTo(64)
//                $0.top.equalTo(userNameLabel.snp.bottom).offset(27)
//                $0.centerX.equalToSuperview()
//            }
//        } else {
//            feedbackBtn.snp.makeConstraints {
//                $0.width.equalTo(357)
//                $0.height.equalTo(64)
//                $0.top.equalTo(userNameLabel.snp.bottom).offset(37)
//                $0.centerX.equalToSuperview()
//            }
//        }
        
        // privacy link
        view.addSubview(privacyLinkBtn)
        privacyLinkBtn.clickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            UIApplication.shared.openURL(url: PrivacyPolicyURLStr)
        }
        privacyLinkBtn.snp.makeConstraints {
            $0.width.equalTo(700/2)
            $0.height.equalTo(232/2)
            $0.top.equalTo(feedbackBtn.snp.bottom).offset(-15)
            $0.centerX.equalToSuperview()
        }
        // terms
        
        view.addSubview(termsBtn)
        termsBtn.clickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            UIApplication.shared.openURL(url: TermsofuseURLStr)
        }
        termsBtn.snp.makeConstraints {
            $0.width.equalTo(700/2)
            $0.height.equalTo(232/2)
            $0.top.equalTo(privacyLinkBtn.snp.bottom).offset(-15)
            $0.centerX.equalToSuperview()
        }
        
         
    }
    
    
}

extension NEEffectSetVC {
     
    
    func showLoginVC() {
        if LoginMNG.currentLoginUser() == nil {
            let loginVC = LoginMNG.shared.obtainVC()
            loginVC.modalTransitionStyle = .crossDissolve
            loginVC.modalPresentationStyle = .fullScreen
            
            self.present(loginVC, animated: true) {
            }
        }
    }
    func updateUserAccountStatus() {
        if let userModel = LoginMNG.currentLoginUser() {
            let userName  = userModel.userName
            userNameLabel.text = (userName?.count ?? 0) > 0 ? userName : AppName
            logoutBtn.isHidden = false
            loginBtn.isHidden = true
//            loginBtn.isUserInteractionEnabled = false
            
        } else {
            userNameLabel.text = ""
            logoutBtn.isHidden = true
            loginBtn.isHidden = false
//            loginBtn.isUserInteractionEnabled = true
            
        }
    }
}

extension NEEffectSetVC: MFMailComposeViewControllerDelegate {
    func feedback() {
        //首先要判断设备具不具备发送邮件功能
        if MFMailComposeViewController.canSendMail(){
            //获取系统版本号
            let systemVersion = UIDevice.current.systemVersion
            let modelName = UIDevice.current.modelName
            
            let infoDic = Bundle.main.infoDictionary
            // 获取App的版本号
            let appVersion = infoDic?["CFBundleShortVersionString"] ?? "8.8.8"
            // 获取App的名称
            let appName = "\(AppName)"

            
            let controller = MFMailComposeViewController()
            //设置代理
            controller.mailComposeDelegate = self
            //设置主题
            controller.setSubject("\(appName) Feedback")
            //设置收件人
            // FIXME: feed back email
            controller.setToRecipients([feedbackEmail])
            //设置邮件正文内容（支持html）
         controller.setMessageBody("\n\n\nSystem Version：\(systemVersion)\n Device Name：\(modelName)\n App Name：\(appName)\n App Version：\(appVersion )", isHTML: false)
            
            //打开界面
            self.present(controller, animated: true, completion: nil)
        }else{
            HUD.error("The device doesn't support email")
        }
    }
    
    //发送邮件代理方法
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
    }
 }

class SettingContentBtn: UIButton {
    var clickBlock: (()->Void)?
    var nameTitle: String
    var iconImage: UIImage
    init(frame: CGRect, name: String, iconImage: UIImage) {
        self.nameTitle = name
        self.iconImage = iconImage
        super.init(frame: frame)
        setupView()
        addTarget(self, action: #selector(clickAction(sender:)), for: .touchUpInside)
    }
    
    @objc func clickAction(sender: UIButton) {
        clickBlock?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor = .clear
//        self.layer.cornerRadius = 17
//        self.layer.borderWidth = 4
//        self.layer.borderColor = UIColor.black.cgColor
        //
        let iconImgV = UIImageView(image: iconImage)
        iconImgV.contentMode = .scaleAspectFit
        addSubview(iconImgV)
        iconImgV.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
         
        
         
        
    }
    
}
