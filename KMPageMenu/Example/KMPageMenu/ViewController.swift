//
//  ViewController.swift
//  KMPageMenu
//
//  Created by hkm5558 on 04/19/2018.
//  Copyright (c) 2018 hkm5558. All rights reserved.
//

import UIKit
import KMPageMenu
fileprivate extension Selector {
    static let changeTitleLabelWidthType = #selector(ViewController.changeTitleLabelWidthType(sender:))
    
    static let changeIndicatorType = #selector(ViewController.changeIndicatorType(sender:))
    
    static let changeIndicatorWidthType = #selector(ViewController.changeIndicatorWidthType(sender:))
    
    static let changeLineIndicatorPosition = #selector(ViewController.changeLineIndicatorPosition(sender:))
}
public extension UIColor {
    
    ///  Random color.
    public static var random: UIColor {
        let r = Int(arc4random_uniform(255))
        let g = Int(arc4random_uniform(255))
        let b = Int(arc4random_uniform(255))
        return UIColor(red: r, green: g, blue: b)!
    }
    public convenience init?(red: Int, green: Int, blue: Int, transparency: CGFloat = 1) {
        guard red >= 0 && red <= 255 else { return nil }
        guard green >= 0 && green <= 255 else { return nil }
        guard blue >= 0 && blue <= 255 else { return nil }
        
        var trans = transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: trans)
    }
}

class ViewController: UIViewController {

    let titles = ["头条", "娱乐", "超长标题测试·厉害了", "体育", "头条号", "新时代", "深圳", "微资讯", "视频", "财经", "科技", "汽车", "时尚"]
    
    var width: CGFloat {
        get { return self.view.frame.width }
    }
    
    
    lazy var menu: KMPageMenu = {
        let m = KMPageMenu(frame: CGRect(x: 0, y: 40, width: width, height: 44), titles: titles)
        m.style.titleFont = UIFont.systemFont(ofSize: 14)
        view.addSubview(m)
        return m
    }()
    
    lazy var page: KMPagingViewController = {
        
        let viewControllers: [UIViewController] = titles.map { [weak self] _ in
            
            let vc: SettingViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: SettingViewController.self)) as! SettingViewController
            vc.view.backgroundColor = UIColor.random
            vc.changeTitleLabelWidthType.addTarget(self, action: .changeTitleLabelWidthType, for: .touchUpInside)
            vc.changeIndicatorType.addTarget(self, action: .changeIndicatorType, for: .touchUpInside)
            vc.changeIndicatorWidthType.addTarget(self, action: .changeIndicatorWidthType, for: .touchUpInside)
            vc.changeLineIndicatorPosition.addTarget(self, action: .changeLineIndicatorPosition, for: .touchUpInside)
            
            let btnColor = UIColor.random
            vc.view
                .subviews
                .filter {
                    $0.isKind(of: UIButton.self)
                }
                .forEach {
                    $0.backgroundColor = btnColor
                    $0.layer.cornerRadius = 22
                }
            
            return vc
        }
        
        let p = KMPagingViewController(viewControllers: viewControllers)
        
        p.view.frame = CGRect(x: 0,
                              y: menu.frame.maxY,
                              width: width,
                              height: view.frame.height - menu.frame.maxY)
        self.addChildViewController(p)
        p.didMove(toParentViewController: self)
        self.view.addSubview(p.view)
        
        return p
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        menu.applyIndicatorLineSizeToFit()
        
        menu.valueChange = { [weak self] index in
            self?.page.pagingToViewController(at: index)
        }
        
        menu.addTarget(self, action: #selector(menuValueChange(sender:)), for: .valueChanged)
        
        page.delegate = self
        page.didFinishPagingCallBack = { [weak self] (currentViewController, currentIndex)in
            self?.menu.setSelectIndex(index: currentIndex, animated: true)
        }
        
    }
    @objc func menuValueChange(sender: KMPageMenu) {
        print("selectIndex == \(sender.selectIndex)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func changeTitleLabelWidthType(sender: UIButton) {
        switch menu.style.labelWidthType {
        case .fixed:
            menu.applyLabelWidthSizeToFit()
        case .sizeToFit:
            menu.applyLabelWidthFixed()
        }
    }
    
    @objc func changeIndicatorType(sender: UIButton) {
        switch menu.style.indicatorStyle {
        case .cover:
            menu.applyIndicatorLineSizeToFit()
        case .line:
            menu.applyIndicatorCoverSizeToFit()
        }
    }
    
    @objc func changeIndicatorWidthType(sender: UIButton) {
        switch menu.style.indicatorStyle {
        case .cover(let widthType):
            switch widthType {
            case .fixed:
                menu.applyIndicatorCoverSizeToFit()
            case .sizeToFit:
                menu.applyIndicatorCoverFixed()
            }
        case .line(let widthType, _):
            switch widthType {
            case .fixed:
                menu.applyIndicatorLineSizeToFit()
            case .sizeToFit:
                menu.applyIndicatorLineFixed()
            }
        }
    }
    
    @objc func changeLineIndicatorPosition(sender: UIButton) {
        switch menu.style.indicatorStyle {
        case .cover:
            menu.applyLinePositionBottom()
        case .line(_, let position):
            switch position {
            case .top:
                menu.applyLinePositionBottom()
            case .bottom:
                menu.applyLinePositionTop()
            }
        }
    }
}

extension ViewController: KMPagingViewControllerDelegate {
    func pagingController(_ pagingController: KMPagingViewController, didFinish currentViewController: UIViewController, currentIndex: Int) {
        print("selectIndex == \(currentIndex)")
//        menu.setSelectIndex(index: currentIndex, animated: true)
    }
}

// MARK: - 指示器类型
extension KMPageMenu {
    
    /// 标题自适应宽度
    func applyLabelWidthSizeToFit() {
        var aStyle = self.style
        aStyle.labelWidthType = .sizeToFit(minWidth: 20)
        self.style = aStyle
    }
    /// 标题固定宽度
    func applyLabelWidthFixed() {
        var aStyle = self.style
        aStyle.labelWidthType = .fixed(width: 100)
        self.style = aStyle
    }
    
    /// 横线指示器自适应宽度
    func applyIndicatorLineSizeToFit() {
        var aStyle = self.style
        aStyle.indicatorColor = .red
        aStyle.indicatorPendingHorizontal = 8
        aStyle.indicatorStyle = .line(widthType: .sizeToFit(minWidth: 20), position: .bottom((margin: 1, height: 2)))
        self.style = aStyle
    }
    /// 横线指示器固定宽度
    func applyIndicatorLineFixed() {
        var aStyle = self.style
        aStyle.indicatorColor = .red
        aStyle.indicatorPendingHorizontal = 8
        aStyle.indicatorStyle = .line(widthType: .fixed(width: 30), position: .bottom((margin: 1, height: 2)))
        self.style = aStyle
    }
    /// 遮罩指示器自适应宽度
    func applyIndicatorCoverSizeToFit() {
        var aStyle = self.style
        aStyle.indicatorColor = UIColor(white: 0.9, alpha: 1)
        aStyle.indicatorPendingHorizontal = 18
        aStyle.indicatorStyle = .cover(widthType: .sizeToFit(minWidth: 20))
        self.style = aStyle
    }
    /// 遮罩指示器固定宽度
    func applyIndicatorCoverFixed() {
        var aStyle = self.style
        aStyle.indicatorColor = UIColor(white: 0.9, alpha: 1)
        aStyle.indicatorPendingHorizontal = 16
        aStyle.indicatorStyle = .cover(widthType: .fixed(width: 50))
        self.style = aStyle
    }
    
    /// 横线指示器在上
    func applyLinePositionTop() {
        var aStyle = self.style
        let widthType = aStyle.indicatorStyle.widthType
        aStyle.indicatorColor = .red
        aStyle.indicatorPendingHorizontal = 8
        aStyle.indicatorStyle = .line(widthType: widthType, position: .top((margin: 1, height: 2)))
        self.style = aStyle
    }
    /// 横线指示器在下
    func applyLinePositionBottom() {
        var aStyle = self.style
        let widthType = aStyle.indicatorStyle.widthType
        aStyle.indicatorColor = .red
        aStyle.indicatorPendingHorizontal = 8
        aStyle.indicatorStyle = .line(widthType: widthType, position: .bottom((margin: 1, height: 2)))
        self.style = aStyle
    }
}
