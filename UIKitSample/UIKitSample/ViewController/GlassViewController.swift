//
//  GlassViewController.swift
//  UIKitSample
//
//  Created by skw on 6/13/25.
//

import UIKit

/// iOS 26에서 추가된 Liquid Glass Sample
class GlassViewController: UIViewController {
    @IBOutlet private weak var firstBtn: UIButton!
    @IBOutlet private weak var secondBtn: UIButton!
    @IBOutlet private weak var slider: UISlider!
    @IBOutlet private weak var flagSwitch: UISwitch!
    @IBOutlet private weak var testImage: UIImageView!
    @IBOutlet private weak var testContainer: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

#if IOS26
        if #available(iOS 26.0, *) {
            var config = UIButton.Configuration.glass()
            config.subtitle = "First Button"
            firstBtn.configuration = config
//            firstBtn.setTitle("SSL Test", for: .normal)
//            firstBtn.roundCorners(corners: .allCorners, radius: 0.5)
//            firstBtn.configuration = .prominentGlass()
            
//            slider.trackConfiguration = .init(allowsTickValuesOnly: true, neutralValue: 0.2, numberOfTicks: 5)
//            slider.sliderStyle = .thumbless
            
            let effectView = UIVisualEffectView()
            effectView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 100, height: 100))
            testContainer.addSubview(effectView)
            effectView.roundCorners(corners: .allCorners, radius: 25)
            let glassEffect = UIGlassEffect()
            UIView.animate {
                effectView.effect = glassEffect
            }
        }
#endif
    }
    
    // MARK: - Private Func
    // Glass Effect Test Code
    // 뷰에 유리 이펙트 입히기
    private func testGlass() {
        // Adopting glass for custom views

        let effectView = UIVisualEffectView()
        effectView.frame = self.view.frame
        self.view.addSubview(effectView)

#if IOS26
        if #available(iOS 26.0, *) {
            let glassEffect = UIGlassEffect()
            UIView.animate {
                effectView.effect = glassEffect
            }
        }
#endif        
    }
}
