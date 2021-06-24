//
//  ApLoginVC.swift
//  WQymWallQRCode
//
//  Created by JOJO on 2021/6/18.
//

import Foundation
import FirebaseAuth
import FirebaseUI
import Firebase
import AuthenticationServices
import DeviceKit
import SnapKit
import SwifterSwift

class APLoginVC: FUIAuthPickerViewController, FUIAuthDelegate {
    
    let ppUrl = "http://late-language.surge.sh/Privacy_Agreement.htm"
    let touUrl = "http://late-language.surge.sh/Terms_of_use.htm"
    
    let def_fontName = ""
    
    override init(nibName: String?, bundle: Bundle?, authUI: FUIAuth) {
        super.init(nibName: "FUIAuthPickerViewController", bundle: bundle, authUI: authUI)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var buttons: [UIButton] = []
    var collection: UICollectionView!
    let bgImageView = UIImageView()
    let pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.findButtons(subView: self.view)
        setupView()
        
    }
    
    func findButtons(subView: UIView) {
        
        if subView.isKind(of: UIButton.classForCoder()) {
            if let button = subView as? UIButton {
                buttons.append(button)
            }
            return
        } else {
            subView.backgroundColor = .clear
        }
        
        for sv in subView.subviews {
            findButtons(subView: sv)
        }
    }
    
    @objc func closebuttonClick(button: UIButton) {
        self.dismiss(animated: true) {
        }
    }
    
    @objc func appleButtonClick(button: UIButton) {
        let requestID = ASAuthorizationAppleIDProvider().createRequest()
                // 这里请求了用户的姓名和email
                requestID.requestedScopes = [.fullName, .email]
                
                let controller = ASAuthorizationController(authorizationRequests: [requestID])
                controller.delegate = self
                controller.presentationContextProvider = self
                controller.performRequests()
    }
    
    func customFont(fontName: String, size: CGFloat) -> UIFont {
        let stringArray: Array = fontName.components(separatedBy: ".")
        let path = Bundle.main.path(forResource: stringArray[0], ofType: stringArray[1])
        let fontData = NSData.init(contentsOfFile: path ?? "")
        
        let fontdataProvider = CGDataProvider(data: CFBridgingRetain(fontData) as! CFData)
        let fontRef = CGFont.init(fontdataProvider!)!
        
        var fontError = Unmanaged<CFError>?.init(nilLiteral: ())
        CTFontManagerRegisterGraphicsFont(fontRef, &fontError)
        
        let fontName: String =  fontRef.postScriptName as String? ?? ""
        let font = UIFont(name: fontName, size: size)
        
        fontError?.release()
        
        return font ?? UIFont(name: def_fontName, size: size)!
    }
    
    @objc func buttonClick(button: UIButton) {
        
        switch button.tag {
            
        case 1001:
            let url = URL(string: ppUrl)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            break
            
        case 1002:
            let url = URL(string: touUrl)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            break

        default:
            break
        }
    }
 
}

extension APLoginVC {
    func setupView() {
        view.backgroundColor = .black
        let topBgImgV = UIImageView(image: UIImage(named: "login_background"))
        topBgImgV.contentMode = .scaleAspectFill
        view.addSubview(topBgImgV)
        topBgImgV.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        //
        let userInfoImgV = UIImageView(image: UIImage(named: "login_img"))
        view.addSubview(userInfoImgV)
        userInfoImgV.contentMode = .scaleAspectFit
        userInfoImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-250)
        }
        //
        let bgBottomView = UIView()
        bgBottomView.backgroundColor = .clear
        view.addSubview(bgBottomView)
        bgBottomView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-250)
        }
        //
        let closebutton = UIButton()
        closebutton.alpha = 1
        closebutton.setImage(UIImage(named: "costcoins_ic_close"), for: .normal)
        closebutton.addTarget(self, action: #selector(closebuttonClick(button:)), for: .touchUpInside)
        view.addSubview(closebutton)
        closebutton.snp.makeConstraints { (make) in
            make.width.height.equalTo(108/2)
            make.left.equalTo(10)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0)
        }
        
        //
//        let topTitleLabe = UILabel()
//        topTitleLabe.font = UIFont(name: "Avenir-Black", size: 28)
//        topTitleLabe.adjustsFontSizeToFitWidth = true
//        topTitleLabe.textAlignment = .center
//        topTitleLabe.textColor = .white
//        topTitleLabe.text = "Glister"
//        topTitleLabe.numberOfLines = 2
//        view.addSubview(topTitleLabe)
//        topTitleLabe.snp.makeConstraints {
//            $0.top.equalTo(closebutton.snp.bottom).offset(10)
//            $0.centerX.equalToSuperview()
//            $0.width.equalTo(250)
//            $0.height.greaterThanOrEqualTo(32)
//        }
//        //
//        let topInfoLabel = UILabel()
//        topInfoLabel.font = UIFont(name: "Verdana-Bold", size: 18)
//        topInfoLabel.textColor = .white
//        topInfoLabel.textAlignment = .center
//        topInfoLabel.adjustsFontSizeToFitWidth = true
//        topInfoLabel.numberOfLines = 2
//        topInfoLabel.text = "Welcome to Create Epic Photo & Amazing Wallpaper"
//        view.addSubview(topInfoLabel)
//        topInfoLabel.snp.makeConstraints {
//            $0.top.equalTo(topTitleLabe.snp.bottom).offset(14)
//            $0.centerX.equalToSuperview()
//            $0.width.equalTo(300)
//            $0.height.greaterThanOrEqualTo(50)
//        }
        //
        
        
        //
        let googleButton = buttons[0]
        googleButton.layer.cornerRadius = 12
        googleButton.layer.masksToBounds = true
        googleButton.setTitle(" Sign in with Google", for: .normal)
        googleButton.setTitleColor(.black, for: .normal)
        googleButton.titleLabel?.font = UIFont(name: "SFProText-Bold", size: 18)
        googleButton.frame = CGRect.zero
        googleButton.backgroundColor = .white
        googleButton.contentHorizontalAlignment = .center
        bgBottomView.addSubview(googleButton)
        googleButton.snp.makeConstraints { (make) in
            make.width.equalTo(280)
            make.height.equalTo(54)
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-76)
        }
        //
        let appleButton = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
        appleButton.layer.cornerRadius = 12
        appleButton.layer.masksToBounds = true
        appleButton.addTarget(self, action: #selector(appleButtonClick(button:)), for: .touchUpInside)
        bgBottomView.addSubview(appleButton)
        appleButton.snp.makeConstraints { (make) in
            make.width.equalTo(280)
            make.height.equalTo(54)
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(googleButton.snp.top).offset(-20)
        }
        
        
        // Do any additional setup after loading the view.
        
           
        let bottomView = UIView()
        bottomView.backgroundColor = .clear
        self.view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(40)
            make.bottom.equalTo(-20)
            make.centerX.equalTo(self.view)
        }
        
        let ppButton = UIButton()
        let str = NSMutableAttributedString(string: "Privacy Policy &")
        let strRange = NSRange.init(location: 0, length: str.length)
        //此处必须转为NSNumber格式传给value，不然会报错
        let number = NSNumber(integerLiteral: NSUnderlineStyle.single.rawValue)
        str.addAttributes([NSAttributedString.Key.underlineStyle: number,
                           NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "#FFFFFF")?.withAlphaComponent(0.8) ?? .white,
                           NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 12)!],
                          range: strRange)
        ppButton.setAttributedTitle(str, for: UIControl.State.normal)
        ppButton.contentHorizontalAlignment = .right
        ppButton.tag = 1001
        ppButton.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
        bottomView.addSubview(ppButton)
        ppButton.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(40)
            make.bottom.equalTo(-20)
            make.left.equalTo(0)
        }
        
        let tou = UIButton()
        let toustr = NSMutableAttributedString(string: " Terms of Use")
        let toustrRange = NSRange.init(location: 0, length: toustr.length)
        //此处必须转为NSNumber格式传给value，不然会报错
        let tounumber = NSNumber(integerLiteral: NSUnderlineStyle.single.rawValue)
        toustr.addAttributes([NSAttributedString.Key.underlineStyle: tounumber,
                              NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "#FFFFFF")?.withAlphaComponent(0.8) ?? .white,
                           NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 12)!],
                          range: toustrRange)
        tou.setAttributedTitle(toustr, for: UIControl.State.normal)
        tou.contentHorizontalAlignment = .left
        tou.tag = 1002
        tou.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
        bottomView.addSubview(tou)
        tou.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(40)
            make.bottom.equalTo(-20)
            make.right.equalTo(-2)
        }
    }
}

extension APLoginVC: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 请求完成，但是有错误
    }
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        // 请求完成， 用户通过验证
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // 拿到用户的验证信息，这里可以跟自己服务器所存储的信息进行校验，比如用户名是否存在等。
            //                let detailVC = DetailVC(cred: credential)
            //                self.present(detailVC, animated: true, completion: nil)
            
            print(credential)
            LoginMNG.saveAppleUserIDAndUserName(userID: credential.user, userName: credential.email ?? "")
            self.dismiss(animated: true) {
            }
            
        } else {
            
        }
    }
}

extension APLoginVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return (UIApplication.shared.delegate as! AppDelegate).window!
    }
}

  

 
