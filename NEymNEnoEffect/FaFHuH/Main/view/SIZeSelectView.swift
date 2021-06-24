//
//  SIZeSelectView.swift
//  NEymNEnoEffect
//
//  Created by JOJO on 2021/6/18.
//

import UIKit

 

class SIZeSelectView: UIView {
    enum SIZeType {
        case size_16_9
        case size_1_1
    }
     
    let okBtn169 = UIButton(type: .custom)
    let okBtn11 = UIButton(type: .custom)
    var okBtnClickBlock: ((SIZeType)->Void)?
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

        addSubview(okBtn169)
        okBtn169.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-120)
            $0.width.equalTo(144/2)
            $0.height.equalTo(226/2)
            $0.right.equalTo(snp.centerX).offset(-15)
        }
        okBtn169.addTarget(self, action: #selector(okBtnClick(sender:)), for: .touchUpInside)
        okBtn169.setImage(UIImage(named: "canvas_169"), for: .normal)
        //
        
        addSubview(okBtn11)
        okBtn11.snp.makeConstraints {
            $0.centerY.equalTo(okBtn169)
            $0.width.equalTo(144/2)
            $0.height.equalTo(144/2)
            $0.left.equalTo(snp.centerX).offset(15)
        }
        okBtn11.addTarget(self, action: #selector(okBtnClick(sender:)), for: .touchUpInside)
        okBtn11.setImage(UIImage(named: "canvas_11"), for: .normal)
        
        //
        let cancelBtn = UIButton(type: .custom)
        addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints {
            $0.bottom.equalTo(okBtn169.snp.top).offset(-46)
            $0.height.width.equalTo(40)
            $0.right.equalTo(-20)
        }
        cancelBtn.addTarget(self, action: #selector(cancelBtnClick(sender:)), for: .touchUpInside)
        cancelBtn.setImage(UIImage(named: "canvas_close"), for: .normal)
        
        
    }
    
    @objc func okBtnClick(sender: UIButton) {
        if sender == okBtn169 {
            okBtnClickBlock?(.size_16_9)
        } else {
            okBtnClickBlock?(.size_1_1)
        }
        
    }
    @objc func cancelBtnClick(sender: UIButton) {
        cancelBtnClickBlock?()
    }
}
