# InteractiveDismiss

[![CI Status](https://img.shields.io/travis/skyofdwarf/InteractiveDismiss.svg?style=flat)](https://travis-ci.org/skyofdwarf/InteractiveDismiss)
[![Version](https://img.shields.io/cocoapods/v/InteractiveDismiss.svg?style=flat)](https://cocoapods.org/pods/InteractiveDismiss)
[![License](https://img.shields.io/cocoapods/l/InteractiveDismiss.svg?style=flat)](https://cocoapods.org/pods/InteractiveDismiss)
[![Platform](https://img.shields.io/cocoapods/p/InteractiveDismiss.svg?style=flat)](https://cocoapods.org/pods/InteractiveDismiss)

InteractiveDismiss is a subclass of `UIPresentationController` for interactive modal dismiss.
It supports nested scroll views like UIScrollView, UITableView, and UICollectionView.
To use InteractiveDismiss, just adopt `UIViewControllerTransitioningDelegate` protocol and return an instance of InteractiveDismiss in `presentationController(forPresented:presenting:source:)`.
And then set .custom to `modalPresentationStyle` before calling `present(_:animated:completion)`.

```swift
extension YourModalViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        InteractiveDismissPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension YourModalViewController: InteractiveDismissPresenting {
    public var nestedScrollView: UIScrollView? { scrollView }
}

func presentModal() {
    let vc = YourModalViewController()
    
    vc.modalPresentationStyle = .custom
    vc.transitioningDelegate = vc
    
    self.present(vc, animated: true)
}
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

InteractiveDismiss is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'InteractiveDismiss'
```

## Author

skyofdwarf, skyofdwarf@gmail.com

## License

InteractiveDismiss is available under the MIT license. See the LICENSE file for more info.
