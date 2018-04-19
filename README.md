# KMPageMenu

<img src="https://img.shields.io/badge/Swift-4.0-orange.svg" />  <a href="https://cocoapods.org/pods/KMPageMenu">
<img src="https://img.shields.io/cocoapods/v/KMPageMenu.svg" alt="CocoaPods" />
</a>

<img src="https://github.com/hkm5558/KMPageMenu/blob/master/Screenshot/截图1.jpg" width="256">  <img src="https://github.com/hkm5558/KMPageMenu/blob/master/Screenshot/截图2.jpg" width="256">
    
## Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries. You can install it with the following command:

```bash
$ gem install cocoapods
```
#### Podfile

To integrate KMPageMenu into your Xcode project using CocoaPods, specify it in your `Podfile`:

In your Podfile
>`pod 'KMPageMenu'`

Then, run the following command:

```bash
$ pod install
```

## Requirements

This library requires `iOS 8.0+`

## Architecture

- `KMPageMenu`
- `KMPageMenuEnum`
- `KMPagingViewController`

## Usage
```swift
    //首先把 菜单 和 分页视图控制器 添加到视图上
    let menu = KMPageMenu(frame: CGRect(x: 0, y: 40, width: width, height: 44), titles: titles)
    m.style.titleFont = UIFont.systemFont(ofSize: 14)
    view.addSubview(menu)

    let page = KMPagingViewController(viewControllers: viewControllers)

    page.view.frame = CGRect(x: 0, y: menu.frame.maxY, width: width, height: view.frame.height - menu.frame.maxY)
    self.addChildViewController(page)
    page.didMove(toParentViewController: self)
    self.view.addSubview(page.view)

    // 菜单下标改变的回调
    menu.valueChange = { [weak self] index in
        self?.page.pagingToViewController(at: index)
    }
    
    // KMPageMenu 控件继承于 UIControl 所以也可以用监听 valueChanged 的方式
    menu.addTarget(self, action: #selector(menuValueChange(sender:)), for: .valueChanged)
    
    // 分页控制器切换完成的回调
    page.didFinishPagingCallBack = { [weak self] (currentViewController, currentIndex)in
        self?.menu.setSelectIndex(index: currentIndex, animated: true)
    }
    
    // KMPagingViewController 同时也提供了代理的回调
    // KMPagingViewControllerDelegate
    
    page.delegate = self
    
    func pagingController(_ pagingController: KMPagingViewController, didFinish currentViewController: UIViewController, currentIndex: Int) {
    
        print("selectIndex == \(currentIndex)")
        
    }
```
## Gif

<img src="https://github.com/hkm5558/KMPageMenu/blob/master/Screenshot/示例.gif" width="256">
    
## Author

hkm5558, szhuangkm@163.com

## License

KMPageMenu is available under the MIT license. See the LICENSE file for more info.
