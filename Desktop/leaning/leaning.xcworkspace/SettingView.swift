//
//  SettingView.swift
//  leaning
//
//  Created by Tenna on 2/19/2 R.
//  Copyright © 2 Reiwa Tenna. All rights reserved.
//

import Foundation
import UIKit

class SettingView: UIView {
    
    private let color = UIColor(red: 168/255, green: 205/255, blue: 210/255, alpha: 1)
    private let cellLength = (Screen.w-80)/7
    public var btnB = UIButton(), btnY = UIButton(), btnP = UIButton()
    public var btn1 = UIButton(), btn2 = UIButton(), btn3 = UIButton()
    private let redSlider = UISlider(), greenSlider = UISlider(), blueSlider = UISlider()
    private var btnArray: [[UIButton]] = [[], []]
    private var sliderArray: [UISlider] = []
    private var colorArray: [UIColor] = []
    public var selectedPin = UIButton() // view controllerに渡す用
    private let screen = UILabel()
    private let label = UILabel()
    // カラーパレット
    private let collectionView: UICollectionView = {
        //セルのレイアウト
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: CGRect(x: 40, y: Screen.h-230, width: Screen.w-80, height: 160), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(white: 0.5, alpha: 0.1)
        collectionView.layer.cornerRadius = 10
        collectionView.clipsToBounds = true
        //セルの登録
        collectionView.register(ColorPaletteCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionView
    }()
    let cancelBtn = UIButton()
    let createBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 背景
        let back = UIView()
        back.backgroundColor = UIColor.white
        back.frame = CGRect(x: 0, y: 0, width: Screen.w, height: Screen.h)
        addSubview(back)
        
        // 現在地ピンの色を変えるラベル
        let label1 = labelSetting(text: "現在地のピン", y: 60)
        addSubview(label1)
        // 現在地ピンボタン
        var index = 0
        let name = ["hitoB.png", "hitoY.png", "hitoP.png"]
        let arrayX: [CGFloat] = [Screen.w/2-100, Screen.w/2-30, Screen.w/2+40]
        btnArray[0] = [btnB, btnY, btnP]
        for btn in btnArray[0] {
            imageBtnSetting(btn: btn, name: name[index], x: arrayX[index])
            self.addSubview(btn)
            index += 1
        }
        // 現在設定してあるピンを選択状態に
        switch UserSetting.pinImage {
        case "hitoP.png":
            btnP.isSelected = true
            selectedPin = btnP
            btnP.backgroundColor = UIColor(white: 0, alpha: 0.1)
        case "hitoY.png":
            btnY.isSelected = true
            selectedPin = btnY
            btnY.backgroundColor = UIColor(white: 0, alpha: 0.1)
        default:
            btnB.isSelected = true
            selectedPin = btnB
            btnB.backgroundColor = UIColor(white: 0, alpha: 0.1)
        }
        
        // テーマカラーを設定
        let label2 = labelSetting(text: "テーマカラー", y: Screen.h-500)
        addSubview(label2)
        
        let textLabel = UILabel(frame: CGRect(x: Screen.w/2-140, y: Screen.h-465, width: 130, height: 12))
        textLabel.text = "イメージ"
        textLabel.textColor = UIColor.black
        textLabel.font = UIFont.systemFont(ofSize: 13)
        textLabel.textAlignment = .center
        addSubview(textLabel)
        // イメージパネル
        colorArray = [UserSetting.color1!, UserSetting.color2!, UserSetting.color3!]
        screen.frame = CGRect(x: Screen.w/2-120, y: Screen.h-450, width: 90, height: 160)
        screen.backgroundColor = colorArray[0]
        screen.layer.borderColor = colorArray[2].cgColor
        screen.layer.borderWidth = 3
        screen.layer.cornerRadius = 10
        screen.clipsToBounds = true
        label.frame = CGRect(x: 10, y: 80, width: 70, height: 70)
        label.backgroundColor = colorArray[1]
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        screen.addSubview(label)
        addSubview(screen)
        // 色設定ボタン
        index = 0
        let arrayY: [CGFloat] = [Screen.h-440, Screen.h-390, Screen.h-340]
        btnArray[1] = [btn1, btn2, btn3]
        for btn in btnArray[1] {
            colorBtnSetting(btn: btn, color: colorArray[index], y: arrayY[index])
            self.addSubview(btn)
            index += 1
        }
        // ボタンが選択された状態にする
        btn1.isSelected = true
        btn1.layer.borderWidth = 3
        btn1.layer.borderColor = UIColor.red.cgColor
        
        // 色を調整（パレット、RBG）セグメンテッドコントロール
        let parameters = ["パレット", "RBG"]
        let segmentedControl = UISegmentedControl(items: parameters)
        segmentedControl.frame = CGRect(x: 120, y: Screen.h-275, width: Screen.w-240, height: 30)
        segmentedControl.backgroundColor = color
        // セグメントのフォントと文字色
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: UIColor(red: 21/255, green: 129/255, blue: 164/255, alpha: 1)
            ], for: .selected)
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: color
            ], for: .normal)
        // セグメント選択
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: UIControl.Event.valueChanged)
        addSubview(segmentedControl)
        
        // コレクションビュー（カラーパレット）
        collectionView.dataSource = self
        collectionView.delegate = self
        addSubview(collectionView)
        
        // RGBView
        index = 0
        sliderArray = [redSlider, greenSlider, blueSlider]
        let colorArray: [UIColor] = [UIColor.red, UIColor.green, UIColor.blue]
        let initColorArray: [CGFloat] = [Color.color1.rgba.r, Color.color1.rgba.r, Color.color1.rgba.b]
        for slider in sliderArray {
            sliderView(slider: slider, sliderColor: colorArray[index], initColor: initColorArray[index])
            addSubview(slider)
            index += 1
        }
        
        // キャンセルボタン
        cancelBtn.frame = CGRect(x: Screen.w/2-130, y: Screen.h-60, width: 120, height: 30)
        cancelBtn.setTitle("キャンセル", for: UIControl.State())
        cancelBtn.setTitleColor(UIColor.black, for: UIControl.State())
        cancelBtn.showsTouchWhenHighlighted = true
        addSubview(cancelBtn)
        // 完了ボタン
        createBtn.frame = CGRect(x: Screen.w/2+10, y: Screen.h-60, width: 120, height: 30)
        createBtn.setTitle("完了", for: UIControl.State())
        createBtn.setTitleColor(UIColor.black, for: UIControl.State())
        createBtn.showsTouchWhenHighlighted = true
        addSubview(createBtn)
    }
    // ラベル
    func labelSetting(text: String, y: CGFloat) -> UILabel {
        
        let label = UILabel()
        label.backgroundColor = color
        label.clipsToBounds = true
        label.layer.cornerRadius = 5
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.text = text
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.frame = CGRect(x: 40, y: y, width: Screen.w-80, height: 25)
        
        return label
    }
    // 現在地ピン
    func imageBtnSetting(btn: UIButton, name: String, x: CGFloat) {

        let image = UIImage(named: name)
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 15, y: 10, width: 30, height: 40)
        btn.addSubview(imageView)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.cornerRadius = 5
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        btn.frame = CGRect(x: x, y: 95, width: 60, height: 60)
        btn.addTarget(self, action: #selector(self.pinBtnSelected(_:)), for: .touchDown)
    }
    // 色ボタン
    func colorBtnSetting(btn: UIButton, color: UIColor, y: CGFloat) {
        
        btn.frame = CGRect(x: Screen.w/2+30, y: y, width: 90, height: 40)
        btn.backgroundColor = color
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.addTarget(self, action: #selector(self.colorBtnSelected(_:)), for: .touchDown)
    }
    
    // スライダー
    func sliderView(slider: UISlider, sliderColor: UIColor, initColor: CGFloat) {
        slider.frame = CGRect(x: 0, y: 0, width: Screen.w-120, height: 20)
        slider.isContinuous = true
        slider.thumbTintColor = sliderColor
        slider.maximumTrackTintColor = UIColor(white: 0.5, alpha: 0.2)
        slider.minimumTrackTintColor = sliderColor
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.center = CGPoint(x: Screen.w/2, y: Screen.h+20)
        // ボタンの色のrbg値を取得
        slider.setValue(Float(initColor), animated: true)
        slider.addTarget(self, action: #selector(self.colorIsBeingChanged(_:)), for: .valueChanged)
    }
    
    // 現在地ピンボタンが押された時
    @objc func pinBtnSelected(_ sender: UIButton) {
        sender.isSelected = true
        sender.backgroundColor = UIColor(white: 0, alpha: 0.1)
        for btn in btnArray[0] {
            if sender != btn {
                btn.isSelected = false
                btn.backgroundColor = UIColor.clear
            }
        }
        selectedPin = sender
    }
    
    // 色ボタンが押された時
    @objc func colorBtnSelected(_ sender: UIButton) {
        sender.isSelected = true
        sender.layer.borderWidth = 3
        sender.layer.borderColor = UIColor.red.cgColor
        for btn in btnArray[1] {
            if sender != btn {
                btn.isSelected = false
                btn.layer.borderWidth = 1
                btn.layer.borderColor = UIColor.lightGray.cgColor
            }
        }
        redSlider.setValue(Float(sender.backgroundColor!.rgba.r), animated: true)
        greenSlider.setValue(Float(sender.backgroundColor!.rgba.g), animated: true)
        blueSlider.setValue(Float(sender.backgroundColor!.rgba.b), animated: true)
    }
    
    // コレクションビュー（カラーパレット）を表示
    func paletteIsInScreen() {
        collectionView.frame = CGRect(x: 40, y: Screen.h-230, width: Screen.w-80, height: 160)
        for slider in sliderArray {
            slider.center = CGPoint(x: Screen.w/2, y: Screen.h+20)
        }
    }
    // Slidersを表示
    func RGBSliderViewIsInScreen() {
        collectionView.frame = CGRect(x: 40, y: Screen.h, width: Screen.w-80, height: Screen.h-560)
        var y = Screen.h-220
        for slider in sliderArray {
            slider.center = CGPoint(x: Screen.w/2, y: y)
            y += 60
        }
    }
    
    // SegmentControlが変更された時
    @objc func segmentChanged(_ segment: UISegmentedControl) {
        switch segment.selectedSegmentIndex {
        case 0:
            // パレットから色を選択
            RGBSliderViewIsInScreen()
            UIView.animate(withDuration: 0.5) {
                self.paletteIsInScreen()
            }
        case 1:
            // RBGで調整
            paletteIsInScreen()
            UIView.animate(withDuration: 0.5) {
                self.RGBSliderViewIsInScreen()
            }
        default:
            break
        }
    }
    
    // Slidersの値が変わった時
    @objc func colorIsBeingChanged(_ sender: UISlider!) {
        let color = UIColor(red: CGFloat(redSlider.value), green: CGFloat(greenSlider.value), blue: CGFloat(blueSlider.value), alpha: 1)
        changeColor(color: color)
    }
    // 色が変えられた時（RGB、カラーパレット）
    func changeColor(color: UIColor) {
        // 選ばれているボタンとそれにに対応するイメージの色を変更
        if btn1.isSelected == true {
            btn1.backgroundColor = color
            screen.backgroundColor = color
        } else if btn2.isSelected == true {
            btn2.backgroundColor = color
            label.backgroundColor = color
        } else {
            btn3.backgroundColor = color
            screen.layer.borderColor = color.cgColor
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// RGBを取得
extension UIColor {

    var rgba: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        let color = CIColor(cgColor: self.cgColor)
        return (color.red, color.green, color.blue, color.alpha)
    }
}

extension SettingView: UICollectionViewDelegate {
    // セルが選ばれた時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // セルの枠を初期化
        for cell in collectionView.visibleCells {
            cell.layer.borderColor = UIColor.clear.cgColor
        }
        // 選択したセルの枠を変更
        let cell = collectionView.cellForItem(at: indexPath)!
        cell.layer.borderColor = UIColor.red.cgColor
        
        let color = cell.backgroundColor!
        changeColor(color: color)
    }
}

extension SettingView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 35
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ColorPaletteCell
        //選択された時に色を付ける
        cell.layer.borderWidth = 1.5
        cell.layer.borderColor = UIColor.clear.cgColor
        
        let color = Color.colorArray[indexPath.item]
        cell.backgroundColor = color
        
        return cell
    }
}

extension SettingView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cellLength, height: cellLength)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
}

class ColorPaletteCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
