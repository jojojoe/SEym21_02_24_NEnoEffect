//
//  EDItToolFuBar.swift
//  NEymNEnoEffect
//
//  Created by JOJO on 2021/6/18.
//

import UIKit

class EDItToolFuBar: UIView {

    var btnClickBlock: ((String)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    

}


extension EDItToolFuBar {
    func setupView() {
        let bgBtn = EDItToolFuBarBtn(frame: .zero, icon: UIImage(named: "edit_ic_background"), name: "Background", nameColorStr: "#01FFFA")
        let borderBtn = EDItToolFuBarBtn(frame: .zero, icon: UIImage(named: "edit_ic_border"), name: "Border", nameColorStr: "#FF12D2")
        let stickerBtn = EDItToolFuBarBtn(frame: .zero, icon: UIImage(named: "edit_ic_sticker"), name: "Sticker", nameColorStr: "#FFC602")
        let brushBtn = EDItToolFuBarBtn(frame: .zero, icon: UIImage(named: "edit_ic_brush"), name: "Brush", nameColorStr: "#983FFF")
        
        //
        let width: CGFloat = (UIScreen.main.bounds.size.width - 1) / 4
        
        addSubview(bgBtn)
        bgBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview()
            $0.height.equalTo(80)
            $0.width.equalTo(width)
        }
        bgBtn.addTarget(self, action: #selector(bgBtnClick(sender:)), for: .touchUpInside)
        //
        addSubview(borderBtn)
        borderBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(bgBtn.snp.right)
            $0.height.equalTo(80)
            $0.width.equalTo(width)
        }
        borderBtn.addTarget(self, action: #selector(borderBtnClick(sender:)), for: .touchUpInside)
        //
        addSubview(stickerBtn)
        stickerBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(borderBtn.snp.right)
            $0.height.equalTo(80)
            $0.width.equalTo(width)
        }
        stickerBtn.addTarget(self, action: #selector(stickerBtnClick(sender:)), for: .touchUpInside)
        //
        addSubview(brushBtn)
        brushBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(stickerBtn.snp.right)
            $0.height.equalTo(80)
            $0.width.equalTo(width)
        }
        brushBtn.addTarget(self, action: #selector(brushBtnClick(sender:)), for: .touchUpInside)
    }
    
    @objc func bgBtnClick(sender: UIButton) {
        btnClickBlock?("bg")
    }
    @objc func borderBtnClick(sender: UIButton) {
        btnClickBlock?("border")
    }
    @objc func stickerBtnClick(sender: UIButton) {
        btnClickBlock?("sticker")
    }
    @objc func brushBtnClick(sender: UIButton) {
        btnClickBlock?("brush")
    }
    
}

class EDItToolFuBarBtn: UIButton {
    
    var icon: UIImage?
    var name: String
    var nameColorStr: String
    
    init(frame: CGRect, icon: UIImage?, name: String, nameColorStr: String) {
        self.icon = icon
        self.name = name
        self.nameColorStr = nameColorStr
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        let iconImgV = UIImageView(image: icon)
        iconImgV.contentMode = .center
        addSubview(iconImgV)
        iconImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.height.equalTo(160/2)
        }
        //
        let nameLabel = UILabel()
        nameLabel.font = UIFont(name: "Avenir-Black", size: 14)
        nameLabel.text = name
        nameLabel.textColor = UIColor(hexString: nameColorStr)
        nameLabel.layer.shadowColor = UIColor(hexString: nameColorStr)?.cgColor
        nameLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        nameLabel.layer.shadowRadius = 3
        nameLabel.layer.shadowOpacity = 0.8
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.greaterThanOrEqualTo(20)
            $0.width.greaterThanOrEqualTo(1)
        }
    }
    
}

