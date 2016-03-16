//
//  LoadingView.swift
//  Shibuya
//
//  Created by SonTQ on 3/9/16.
//  Copyright © 2016 RikkeiSoft. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    //MARK: - Outlets
    @IBOutlet var view: UIView!
    @IBOutlet weak var wrapper: UIView!
    @IBOutlet weak var spinnerNW: UIView!
    @IBOutlet weak var spinnerSW: UIView!
    @IBOutlet weak var spinnerSE: UIView!
    @IBOutlet weak var spinnerNE: UIView!
    
    
    //MARK: - Constants variables
    let BASE_ALPHA: CGFloat = 0.3
    let TOTAL_DURATION: Double = 1.0
    let STEP_NUM = 8
    let STEP_START_1 = 0
    let STEP_START_2 = 3
    let STEP_START_3 = 4
    let STEP_START_4 = 7
    
    // MARK: - Variables
    var animating = false
    var step = 0
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        self.wrapper.hidden = true
        
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "LoadingView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        // 2. call super.init(frame:)
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    // MARK: - Custom functions
    func addToView(view: UIView){
        self.wrapper.hidden = true
        view.addSubview(wrapper)
    }
    
    func show(){
        wrapper.alpha = 0
        wrapper.hidden = false
        self.wrapper.superview?.bringSubviewToFront(self.wrapper)
        startAnimation()
        UIView.animateWithDuration(0.1, delay: 0.1, options: .CurveEaseIn, animations: { () -> Void in
            self.wrapper.alpha = 1.0
            }, completion: nil)
    }
    
    func dismiss(){
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.wrapper.alpha = 0.0
            }) { (finished) -> Void in
                self.stopAnimation()
        }
    }
    
    func startAnimation(){
        if animating {
            return
        }
        animating = true
        animate()
    }
    
    func animate(){
        step = (step + 1) % STEP_NUM
        let alpha1 = calcAlphaWithStep(STEP_START_1 + step)
        let alpha2 = calcAlphaWithStep(STEP_START_2 + step)
        let alpha3 = calcAlphaWithStep(STEP_START_3 + step)
        let alpha4 = calcAlphaWithStep(STEP_START_4 + step)
        UIView.animateWithDuration(TOTAL_DURATION / Double(STEP_NUM) , animations: { () -> Void in
            self.spinnerNW.alpha = alpha1
            self.spinnerNE.alpha = alpha2
            self.spinnerSW.alpha = alpha3
            self.spinnerSE.alpha = alpha4
            }) { (finished) -> Void in
                self.animate()
        }
    }
    
    func stopAnimation(){
        spinnerNW.layer.removeAllAnimations()
        spinnerNE.layer.removeAllAnimations()
        spinnerSW.layer.removeAllAnimations()
        spinnerSE.layer.removeAllAnimations()
        animating = false
    }
    
    func calcAlphaWithStep(step: Int)-> CGFloat {
        let maxLevel = STEP_NUM / 2
        let level = (step % STEP_NUM) - maxLevel
        let absLevel = labs(level)
        let alpha = BASE_ALPHA + ((1.0 - BASE_ALPHA) * CGFloat(absLevel) / CGFloat(maxLevel))
        return alpha
    }
    
}
