//
//  PageViewController.swift
//  leaning
//
//  Created by Tenna on 2/12/2 R.
//  Copyright © 2 Reiwa Tenna. All rights reserved.
//

import Foundation
import UIKit

class PageViewController: UIPageViewController {

    var pageControl = UIPageControl()
    
    override func viewDidLoad() {
        self.setViewControllers([getFirst()], direction: .forward, animated: true, completion: nil)
        self.dataSource = self
        
        //PageControlの生成
        pageControl = UIPageControl(frame: CGRect(x: 0, y: self.view.frame.height-80, width: self.view.frame.width, height:50))
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        self.view.addSubview(pageControl)
        
        //マップに戻るボタン
        let backToMapBtn = UIButton()
        let imageB = UIImage(named: "batsu.png")
        let imageviewB = UIImageView(image: imageB)
        let imgWidthB: CGFloat = imageB!.size.width
        imageviewB.alpha = 0.6
        imageviewB.frame = CGRect(x: 0, y: 0, width: imgWidthB/1.4, height: imgWidthB/1.4)
        backToMapBtn.addSubview(imageviewB)
        
        backToMapBtn.frame = CGRect(x: 20, y: self.view.frame.height-45, width: imgWidthB/1.4, height: imgWidthB/1.4)
        self.view.addSubview(backToMapBtn)
        backToMapBtn.addTarget(self, action: #selector(PageViewController.backToMap), for: .touchDown)
        
    }
    
    @objc func backToMap() {
        print("backtomap")
        TutorialPage2.animationTimer?.invalidate()
        performSegue(withIdentifier: "goBack", sender: nil)
    }

    func getFirst() -> TutorialPage1 {
        print("first")
        return storyboard!.instantiateViewController(withIdentifier: "TutorialPage1") as! TutorialPage1
    }
    
    func getSecond() -> TutorialPage2 {
        print("second")
        return storyboard!.instantiateViewController(withIdentifier: "TutorialPage2") as! TutorialPage2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController is TutorialPage2 {
            // 2 -> 1
            pageControl.currentPage -= 1
            return getFirst()
        } else {
            // 1 -> end
            pageControl.currentPage -= 1
            return nil
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController is TutorialPage1 {
            // 1 -> 2
            pageControl.currentPage += 1
            return getSecond()
        } else {
            // 2 -> end
            pageControl.currentPage += 1
            return nil
        }
    }
}
