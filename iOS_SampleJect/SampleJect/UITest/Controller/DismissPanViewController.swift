//
//  DismissPanViewController.swift
//  SampleJect
//
//  Created by ben on 2022/03/15.
//  Copyright © 2022 SinKyoUk. All rights reserved.
//

import UIKit

/// Pan Gesture를 활용한 dismiss 샘플
class DismissPanViewController: UIViewController {
    // MARK: - Variable
    @IBOutlet private weak var contentView: UIView!
    
    private var contentViewOrigin: CGPoint = CGPoint.zero
    private var contentViewSize: CGSize = CGSize.zero
    
    private var isOpened: Bool = false
    
    private var touchBeganContentPoint: CGPoint = CGPoint.zero
    private var dismissGesture: UIPanGestureRecognizer?
    
    // MARK: - Class Func
    class func open(from: UIViewController) {
        let contentController = DismissPanViewController(nibName: "DismissPanViewController", bundle: Bundle.main)
        contentController.modalPresentationStyle = .overFullScreen
        from.present(contentController, animated: false, completion: nil)
    }

    // MARK: - Override Func
    override func viewDidLoad() {
        super.viewDidLoad()

        dismissGesture = UIPanGestureRecognizer(target: self, action: #selector(dismissPanGesture(_:)))
        dismissGesture?.maximumNumberOfTouches = 1
        dismissGesture?.minimumNumberOfTouches = 1
        dismissGesture?.isEnabled = false
        contentView.isHidden = true
        self.view.addGestureRecognizer(dismissGesture!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        contentViewSize = contentView.frame.size
        contentViewOrigin = contentView.frame.origin
        open()
    }
    
    // MARK: - Private Func
    @objc private func dismissPanGesture(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            touchBeganContentPoint = self.contentView.frame.origin
        case .changed:
            let translation = gesture.translation(in: self.view)
            if touchBeganContentPoint.y + translation.y < contentViewOrigin.y {
                return
            }
            
            self.contentView.frame.origin = CGPoint(x: touchBeganContentPoint.x, y: touchBeganContentPoint.y + translation.y)
            
            debugPrint(gesture.velocity(in: self.view))
        case .ended:
            touchBeganContentPoint = CGPoint.zero
            
            if contentView.frame.origin.y - contentViewOrigin.y > contentViewSize.height * 0.3 {
                close()
            } else {
                toOrigin()
            }
        default:
            return
        }
    }
    
    private func open() {
        if isOpened {
            return
        }
        
        isOpened = true
        
        contentView.frame.origin = CGPoint(x: contentViewOrigin.x, y: contentViewOrigin.y + contentViewSize.height)
        contentView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.contentView.frame.origin = self.contentViewOrigin
        } completion: { isFinished in
            self.dismissGesture?.isEnabled = isFinished
        }
    }
    
    private func toOrigin() {
        dismissGesture?.isEnabled = false
        UIView.animate(withDuration: 0.2) {
            self.contentView.frame.origin = self.contentViewOrigin
        } completion: { isFinished in
            self.dismissGesture?.isEnabled = isFinished
        }

    }
    
    private func close() {
        self.dismissGesture?.isEnabled = false
        UIView.animate(withDuration: 0.2) {
            self.contentView.frame.origin = CGPoint(x: self.contentViewOrigin.x, y: self.contentViewOrigin.y + self.contentViewSize.height)
        } completion: { isFinish in
            if isFinish {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
}

extension DismissPanViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset = CGPoint.zero
            dismissPanGesture(scrollView.panGestureRecognizer)
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissPanGesture(scrollView.panGestureRecognizer)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        dismissPanGesture(scrollView.panGestureRecognizer)
    }
}
