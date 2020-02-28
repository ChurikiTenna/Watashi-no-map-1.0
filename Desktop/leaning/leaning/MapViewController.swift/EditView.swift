//
//  MapViewController.swift
//  leaning
//
//  Created by Tenna on 1/31/2 R.
//  Copyright © 2 Reiwa Tenna. All rights reserved.
//

import Foundation
import UIKit

class EditView: UIView, UITextViewDelegate {
    
    private let panel = UILabel()
    let textField = UITextField()
    let memoText = UITextView()
    let memoPlaceholder = UILabel()
    
    private var choosePinBtn = UIButton()
    private let addImgBtn = UIButton()
    let hidePanelBtn = UIButton()
    var createBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 半透明背景
        let back = UILabel()
        back.backgroundColor = UIColor(white: 0.9, alpha: 0.6)
        back.frame = CGRect(x: 0, y: 0, width: Screen.w, height: Screen.h)
        addSubview(back)
        // 背景
        panel.backgroundColor = UserSetting.color1
        panel.frame = CGRect(x: 6, y: 35, width: Screen.w-12, height: 380)
        panel.layer.borderColor = UserSetting.color3?.cgColor
        panel.layer.borderWidth = 3
        panel.clipsToBounds = true
        panel.layer.cornerRadius = 10
        addSubview(panel)
        
        // マップに戻るボタン
        let imageB = UIImage(named: "batsu.png")
        let imageviewB = UIImageView(image: imageB)
        let imgWidthB:CGFloat = imageB!.size.width
        imageviewB.frame = CGRect(x: 0, y: 0, width: imgWidthB/1.4, height: imgWidthB/1.4)
        hidePanelBtn.addSubview(imageviewB)
        hidePanelBtn.frame = CGRect(x: 25, y: 55, width: imgWidthB/1.4, height: imgWidthB/1.4)
        addSubview(hidePanelBtn)
        
        // 上の方のラベル
        let titleBar = UILabel(frame: CGRect(x: Screen.w/2-60, y: 50, width: 120, height: 36))
        titleBar.text = "ピンを作成"
        titleBar.textColor = UIColor.black
        titleBar.layer.cornerRadius = 10
        titleBar.clipsToBounds = true
        titleBar.textAlignment = NSTextAlignment.center
        titleBar.backgroundColor = UIColor(white: 1, alpha: 0.6)
        addSubview(titleBar)
        
        // textFieldの後ろ
        let backOfText = UILabel()
        backOfText.frame = CGRect(x: 20, y: 95, width: Screen.w-40, height: 50)
        backOfText.backgroundColor = UIColor.white
        backOfText.layer.cornerRadius = 5
        backOfText.clipsToBounds = true
        addSubview(backOfText)
        // textField
        textField.frame = CGRect(x: 35, y: 95, width: Screen.w-70, height: 50)
        textField.placeholder = "タイトル"
        textField.addTarget(self, action: #selector(EditView.textFieldEditingChanged), for: .editingChanged)
        addSubview(textField)
        
        // ピンの後ろ
        let pinback = UILabel()
        pinback.frame = CGRect(x: 37, y: 175-25, width: 50, height: 50)
        pinback.backgroundColor = UIColor(white: 1, alpha: 1)
        pinback.clipsToBounds = true
        pinback.layer.cornerRadius = 25
        addSubview(pinback)
        // 色を選ぶボタン
        choosePinBtn = btnSetting(rect: CGRect(x: 100, y: 150, width: Screen.w-120, height: 50), title: "       ピンを選ぶ", color: UIColor.black)
        choosePinBtn.contentHorizontalAlignment = .left
        addSubview(choosePinBtn)
        choosePinBtn.addTarget(self, action: #selector(EditView.selectPin), for: .touchDown)
        // 矢印イメージ
        let img1: UIImage = UIImage(named:"arrow.png")!
        let imageview = UIImageView(image: img1)
        let imgWidth:CGFloat = img1.size.width
        let imgHeight:CGFloat = img1.size.height
        imageview.frame = CGRect(x: Screen.w-50, y: 167, width: imgWidth, height: imgHeight)
        addSubview(imageview)
        
        // Memo fieldの後ろ
        let memoBack = UILabel()
        memoBack.backgroundColor = UIColor.white
        memoBack.frame = CGRect(x: 20, y: 205, width: Screen.w-40, height: 140)
        memoBack.layer.cornerRadius = 5
        memoBack.clipsToBounds = true
        addSubview(memoBack)
        // Memo field
        memoText.frame = CGRect(x: 30, y: 210, width: Screen.w-60, height: 130)
        memoText.backgroundColor = UIColor.white
        memoText.font = UIFont.systemFont(ofSize: 18)
        addSubview(memoText)
        memoText.delegate = self
        // 擬似placeholder
        memoPlaceholder.text = "メモを入力"
        memoPlaceholder.frame = CGRect(x: 33, y: 210, width: Screen.w-66, height: 40)
        memoPlaceholder.textColor = UIColor(white: 0, alpha: 0.2)
        addSubview(memoPlaceholder)
        
        // 完了ボタン
        createBtn = btnSetting(rect: CGRect(x: Screen.w-120, y: 355, width: 100, height: 30), title: "完了", color: UIColor.gray)
        addSubview(createBtn)
    }
    // ボタンの設定
    func btnSetting(rect: CGRect, title: String, color: UIColor) -> UIButton {
        let btn = UIButton(frame: rect)
        btn.backgroundColor = UIColor.white
        btn.layer.cornerRadius = 8
        btn.layer.borderColor = UserSetting.color2?.cgColor
        btn.layer.borderWidth = 2
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(color, for:.normal)
        return btn
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return true
    }
    
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        
        // タイトルに入力がない時”完了”ボタンは押せない
        if textField.text == "" {
            createBtn.isEnabled = false
            createBtn.setTitleColor(UIColor.gray, for:.normal)
        } else {
            createBtn.isEnabled = true
            createBtn.setTitleColor(UIColor.black, for:.normal)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        // メモに入力がない時はmemoplaceholderを表示
        if memoText.text == "" {
            memoPlaceholder.isHidden = false
        } else {
            memoPlaceholder.isHidden = true
        }
    }
    
    @objc func selectPin() {
        
        createBtn.alpha = 0.4
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.createBtn.alpha = 1
        }
        if(memoText.isFirstResponder){
            memoText.resignFirstResponder()
        } else if (textField.isFirstResponder){
            textField.resignFirstResponder()
        }
        // ボーダーの色を変える
        choosePinBtn.layer.borderColor = UserSetting.color3?.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
            self.choosePinBtn.layer.borderColor = UserSetting.color2?.cgColor
        }
        // ピンを選ぶパネルを出す
        let choosePin = ChoosePin()
        choosePin.frame = CGRect(x: 6, y: Screen.h, width: Screen.w-12, height: Screen.h)
        addSubview(choosePin)
        UIView.transition(with: choosePin, duration: 0.4, options: [.curveEaseIn], animations: {
                            choosePin.frame = CGRect(x: 6, y: 35, width: Screen.w-12, height: Screen.h+60)
            })
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
