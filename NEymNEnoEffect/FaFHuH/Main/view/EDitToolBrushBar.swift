//
//  EDitToolBrushBar.swift
//  NEymNEnoEffect
//
//  Created by JOJO on 2021/6/21.
//

import UIKit

 
class EDitToolBrushBar: UIView {

    
    var list: [GCPaintItem] = []
    var collection: UICollectionView!
    var closeBtnBlock: (()->Void)?
    var selectBorderItemBlock: ((GCPaintItem, Bool)->Void)?
    var currentSelectItem: GCPaintItem?
    var lineWidthStrengthBlock:((_ lineWidthStrength:Int) -> Void)?
    var clearAllPathAction:(() -> Void)?
    let lineWidthSlider = UISlider()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        loadData()
        setupView()
        
        MaskConfigManager.sharedInstance().lineWidth = CGFloat(20)
        lineWidthSlider.value = 20
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupView() {
        let closeBtn = UIButton(type: .custom)
        addSubview(closeBtn)
        closeBtn.snp.makeConstraints {
            $0.top.equalTo(10)
            $0.right.equalTo(-12)
            $0.width.height.equalTo(30)
        }
        closeBtn.setImage(UIImage(named: "edit_ic_return"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeBtnClick(sender:)), for: .touchUpInside)
        //
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        addSubview(collection)
        collection.snp.makeConstraints {
            $0.right.left.equalToSuperview()
            $0.top.equalTo(closeBtn.snp.bottom).offset(10)
            $0.height.equalTo(60)
        }
        collection.register(cellWithClass: EDitBrushColorCell.self)
        //
        
        lineWidthSlider.isContinuous = false
        lineWidthSlider.setThumbImage(UIImage(named: "brush_slider_ball"), for: .normal)
        lineWidthSlider.setMinimumTrackImage(UIImage(named: "brush_slider_green"), for: .normal)
        lineWidthSlider.setMaximumTrackImage(UIImage(named: "brush_slider_white"), for: .normal)
        addSubview(lineWidthSlider)
        lineWidthSlider.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(350)
            $0.height.greaterThanOrEqualTo(27)
            $0.top.equalTo(collection.snp.bottom).offset(10)
        }
        lineWidthSlider.minimumValue = 4
        lineWidthSlider.maximumValue = 50
        lineWidthSlider.addTarget(self, action: #selector(lineWidthSliderChange(sender:)), for: .valueChanged)
        //
        let clearBtnU = UIButton(type: .custom)
        addSubview(clearBtnU)
        clearBtnU.addTarget(self, action: #selector(clearBtnUClick(sender:)), for: .touchUpInside)
        clearBtnU.setImage(UIImage(named: "brush_eraser"), for: .normal)
        clearBtnU.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(42)
            $0.top.equalTo(lineWidthSlider.snp.bottom).offset(24)
        }
        
    }
    
    func loadData() {
        list = NEEDataM.default.paintStyleItemList
        currentSelectItem = list.first
    }
    
    @objc func closeBtnClick(sender: UIButton) {
        closeBtnBlock?()
    }
    @objc func clearBtnUClick(sender: UIButton) {
        clearAllPathAction?()
    }
    @objc func lineWidthSliderChange(sender: UISlider) {
        lineWidthStrengthBlock?(Int(sender.value))
    }
    
    
    
}

extension EDitToolBrushBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withClass: EDitBrushColorCell.self, for: indexPath)
        let item : GCPaintItem = list[indexPath.item]
        cell.contentImageView.image = UIImage.init(named: item.previewImageName)
        cell.contentImageView.layer.masksToBounds = true
        cell.contentImageView.layer.cornerRadius = 12
        cell.selectView.layer.cornerRadius = 12
        
        if currentSelectItem?.previewImageName == item.previewImageName {
            cell.selectView.isHidden = false
        } else {
            cell.selectView.isHidden = true
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension EDitToolBrushBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height:CGFloat = 50
        return CGSize(width: height*3, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
}

extension EDitToolBrushBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = list[indexPath.item]
        currentSelectItem = item
        selectBorderItemBlock?(item, false)
        collectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}

class EDitBrushColorCell: UICollectionViewCell {
    var contentImageView: UIImageView = UIImageView()
    let selectView: UIView = UIView()
    let lockImageView: UIImageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentImageView.contentMode = .scaleAspectFill
        contentView.addSubview(contentImageView)
        contentImageView.snp.makeConstraints {
            $0.top.right.bottom.left.equalToSuperview()
        }
        
        selectView.isHidden = true
        selectView.backgroundColor = .clear
        selectView.layer.borderWidth = 2
        selectView.layer.borderColor = UIColor(hexString: "#14EBDA")?.cgColor
        contentView.addSubview(selectView)
        selectView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(0)
            $0.bottom.equalToSuperview().offset(0)
            $0.left.equalToSuperview().offset(0)
            $0.right.equalToSuperview().offset(0)
        }
        
        contentView.addSubview(lockImageView)
        lockImageView.image = UIImage(named: "edit_vip")
        lockImageView.contentMode = .scaleAspectFit
        lockImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.right.equalToSuperview()
            $0.width.height.equalTo(29)
        }
        lockImageView.isHidden = true
        
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                selectView.isHidden = false
            } else {
                selectView.isHidden = true
            }
        }
    }
    
}









