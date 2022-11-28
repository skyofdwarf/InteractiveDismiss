//
//  InteractiveDismissPresentationController.swift
//  InteractiveDismiss
//
//  Created by YEONGJUNG KIM on 2022/05/09.
//

import UIKit

public protocol InteractiveDismissPresentationDelegate {
    var nestedScrollView: UIScrollView? { get }
}

open class InteractiveDismissPresentationController: UIPresentationController {
    public enum Status {
        case waiting
        case panned(delta: CGFloat)
        case finished
        case cancelled(stopDecelerating: Bool)
    }
    
    private class PanningView: UIView {
        let panGestureRecognizer = UIPanGestureRecognizer()
    }
    
    private let panningView = PanningView()
    
    private var status: Status = .waiting
    private var adjustsContentOffset: Bool = false
    
    private let velocityThreshold: Double
    
    private var observer: NSKeyValueObservation?
    
    open override var presentedView: UIView? { panningView }
    
    public init(velocityThreshold: Double = 1000, presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        self.velocityThreshold = velocityThreshold
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    func processObserving(_ scrollView: UIScrollView, change: NSKeyValueObservedChange<CGPoint>) {
        guard let presentedView else { return }
        
        guard adjustsContentOffset else { return }
        
        print("contentOffset.y: \(scrollView.contentOffset.y), state: \(panningView.panGestureRecognizer.state.rawValue), isDecelerating: \(scrollView.isDecelerating)")
        
        let topInset = scrollView.contentInset.top + scrollView.safeAreaInsets.top
        let zeroWithInset = CGPoint(x: 0, y: -topInset)
            
        switch status {
        case .cancelled(let stopDecelerating):
            status = .waiting
            
            if stopDecelerating, scrollView.isDecelerating {
                scrollView.setContentOffset(zeroWithInset, animated: false)
                
            }
        case .panned:
            let offsetY = scrollView.contentOffset.y
            
            if offsetY < -topInset {
                scrollView.contentOffset = zeroWithInset
            } else if offsetY > -topInset {
                if presentedView.frame.origin.y > 0 {
                    scrollView.contentOffset = zeroWithInset
                }
            }
        default:
            break
        }
    }
    
    @objc func handlePanning(_ panGestureRecognizer: UIPanGestureRecognizer) {
        if let presenting = presentedViewController as? InteractiveDismissPresentationDelegate,
           let scrollView = presenting.nestedScrollView {
            handlePanning(scrollView: scrollView, recognizer: panGestureRecognizer)
        } else {
            handlePanning(recognizer: panGestureRecognizer)
        }
    }
    
    func handlePanning(recognizer: UIPanGestureRecognizer) {
        guard let presentedView,
              let containerView = recognizer.view else {
            return
        }
        
        switch recognizer.state {
        case .began:
            break
            
        case .changed:
            var delta: CGFloat = 0
            
            if presentedView.frame.origin.y >= 0 {
                let translation = recognizer.translation(in: containerView)
                recognizer.setTranslation(translation, in: containerView)
                
                delta = translation.y
            }
            
            status = .panned(delta: delta)
            
            if delta > 0 {
                var finalFrame = containerView.bounds
                finalFrame.origin.y += delta
                presentedView.frame = finalFrame
            }
            
        case .ended:
            let velocity = recognizer.velocity(in: containerView)
            let percentage = abs(max(0, presentedView.frame.origin.y) / containerView.bounds.height)
            
            var finished = false
            if velocity.y < -velocityThreshold {
                finished = false
            } else if velocityThreshold < velocity.y {
                finished = true
            } else {
                finished = percentage > 0.5
            }
            
            if finished {
                status = .finished
                presentedViewController.dismiss(animated: true)
            } else {
                status = .cancelled(stopDecelerating: false)
                
                UIViewPropertyAnimator(duration: 0.2, curve: .easeOut) {
                    presentedView.frame = containerView.bounds
                }.startAnimation()
            }
            
        case .cancelled:
            status = .cancelled(stopDecelerating: false)
            
            UIViewPropertyAnimator(duration: 0.2, curve: .easeOut) {
                presentedView.frame = containerView.bounds
            }.startAnimation()
            
        default:
            break
        }
    }
    
    func handlePanning(scrollView: UIScrollView, recognizer: UIPanGestureRecognizer) {
        guard let presentedView,
              let containerView = recognizer.view else {
            return
        }
        
        switch recognizer.state {
        case .began:
            break
            
        case .changed:
            let offsetY = scrollView.contentOffset.y
            let insetTop = scrollView.contentInset.top + scrollView.safeAreaInsets.top
            
            var delta: CGFloat = 0
            
            if offsetY >= -insetTop {
                let translation = recognizer.translation(in: containerView)
                recognizer.setTranslation(translation, in: containerView)
                
                delta = translation.y
            }
            
            status = .panned(delta: delta)
            
            if delta > 0 {
                var finalFrame = containerView.bounds
                finalFrame.origin.y += delta
                presentedView.frame = finalFrame
            }
            
        case .ended:
            let velocity = recognizer.velocity(in: containerView)
            let percentage = abs(max(0, presentedView.frame.origin.y) / containerView.bounds.height)

            var finished = false
            if velocity.y < -velocityThreshold {
                finished = false
            } else if velocityThreshold < velocity.y {
                finished = true
            } else {
                finished = percentage > 0.5
            }
            
            if finished {
                status = .finished
                
                presentedViewController.dismiss(animated: true)
            } else {
                let stopDecelerating = presentedView.frame.origin.y > 0
                status = .cancelled(stopDecelerating: stopDecelerating)
                
                let animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut) {
                    presentedView.frame = containerView.bounds
                }
                animator.startAnimation()
            }
            
        case .cancelled:
            status = .cancelled(stopDecelerating: true)
            
            let animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut) {
                presentedView.frame = containerView.bounds
            }
            animator.startAnimation()
            
        default:
            break
        }
    }

    open override func presentationTransitionWillBegin() {
        guard let containerView else { return }
        
        observer?.invalidate()
        observer = nil
        
        if let presenting = presentedViewController as? InteractiveDismissPresentationDelegate,
           let scrollView = presenting.nestedScrollView {
            observer = scrollView.observe(\.contentOffset, options: [.old, .new]) { [weak self] scrollView, change in
                self?.processObserving(scrollView, change: change)
            }
        }
        
        panningView.addSubview(presentedViewController.view)
        
        panningView.frame = containerView.bounds
        presentedViewController.view.frame = panningView.bounds
        
        panningView.addGestureRecognizer(panningView.panGestureRecognizer)
        
        panningView.panGestureRecognizer.addTarget(self, action: #selector(handlePanning(_:)))
        panningView.panGestureRecognizer.delegate = self
    }
}

extension InteractiveDismissPresentationController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return otherGestureRecognizer.view?.isKind(of: UIScrollView.self) ?? false
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let presenting = presentedViewController as? InteractiveDismissPresentationDelegate,
           let scrollView = presenting.nestedScrollView {
            
            let location = scrollView.convert(gestureRecognizer.location(in: nil), from: nil)
            
            if scrollView.bounds.contains(location) {
                adjustsContentOffset = true
                return scrollView.contentOffset.y == -(scrollView.contentInset.top + scrollView.safeAreaInsets.top)
            }
        }
        
        adjustsContentOffset = false
        return true
    }
}
