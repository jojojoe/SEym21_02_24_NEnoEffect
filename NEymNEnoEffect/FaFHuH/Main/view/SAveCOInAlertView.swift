//
//  SAveCOInAlertView.swift
//  NEymNEnoEffect
//
//  Created by JOJO on 2021/6/22.
//

import UIKit


class SAveCOInAlertView: UIView {

    var okBtnClickBlock: (()->Void)?
    var cancelBtnClickBlock: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.9)
        //
        let contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont(name: "Avenir-Black", size: 22)
        contentLabel.textColor = UIColor(hexString: "#FFE7A8")
        contentLabel.layer.shadowColor = UIColor(hexString: "#FFD667")?.cgColor
        contentLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentLabel.layer.shadowOpacity = 0.8
        contentLabel.layer.shadowRadius = 3
        
        contentLabel.text = "Using paid items will cost \(NEyCoinManag.default.coinCostCount) coins."
        
        contentLabel.textAlignment = .center
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(320)
            $0.height.greaterThanOrEqualTo(60)
        }
       
        //
        let contentImgV = UIImageView(image: UIImage(named: "costcoins_coin"))
        addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.width.equalTo(554/2)
            $0.height.equalTo(506/2)
            $0.bottom.equalTo(contentLabel.snp.top).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        //
        let okBtn = UIButton(type: .custom)
        addSubview(okBtn)
        okBtn.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(-10)
            $0.width.equalTo(363)
            $0.height.equalTo(127)
            $0.centerX.equalToSuperview()
        }
        okBtn.addTarget(self, action: #selector(okBtnClick(sender:)), for: .touchUpInside)
        okBtn.setTitle("", for: .normal)
        okBtn.setTitleColor(.white, for: .normal)
        okBtn.setBackgroundImage(UIImage(named: "costcoins_button"), for: .normal)
        okBtn.titleLabel?.font = UIFont(name: "Avenir-Black", size: 22)
        //
        let cancelBtn = UIButton(type: .custom)
        addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints {
            $0.top.equalTo(contentImgV.snp.top).offset(-20)
            $0.height.width.equalTo(56)
            $0.right.equalToSuperview().offset(-18)
        }
        cancelBtn.addTarget(self, action: #selector(cancelBtnClick(sender:)), for: .touchUpInside)
        cancelBtn.setImage(UIImage(named: "canvas_close"), for: .normal)
        
        
    }
    
    @objc func okBtnClick(sender: UIButton) {
        okBtnClickBlock?()
    }
    @objc func cancelBtnClick(sender: UIButton) {
        cancelBtnClickBlock?()
    }
}
