//
//  PatternView.swift
//  UIKitSample
//
//  Created by skw on 2/13/25.
//

import UIKit

/// 패턴 뷰
class PatternView: UIView {
    // MARK: - Property
    private var dotSize: CGFloat = 20
    private var dots: [CGPoint] = []
    private var dotRow = 3
    private var dotCol = 3
    
    var margin = CGSize(width: 16, height: 16)
    var spacing = CGSize.zero
    
    // 사용자가 그린 패턴을 저장할 배열
    var patternDotIdx: [Int] = []
    
    private var originSize = CGSize.zero
    
    // MARK: - Override Func
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// 초기 구성했던 크기에서 변동성이 생기면 패턴뷰 새로 설정
        if originSize != frame.size {
            originSize = frame.size
            setupDots()
        }
    }
    
    private var linePath = UIBezierPath()
    private var movingPath = UIBezierPath()
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // 점 그리기
        for dot in dots {
            let dotPath = UIBezierPath(ovalIn: CGRect(x: dot.x - dotSize / 2, y: dot.y - dotSize / 2, width: dotSize, height: dotSize))
            UIColor.black.setFill()
            dotPath.fill()
        }
        
        UIColor.blue.setStroke()
        linePath.stroke()
        
        UIColor.green.setStroke()
        movingPath.stroke()
    }
    
    // 터치 이벤트 처리 (사용자가 점을 연결하는 패턴을 추적)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchPoint = touch.location(in: self)
        
        patternDotIdx.removeAll()
        
        if let touchedDotIndex = getTouchedDotIndex(for: touchPoint), !patternDotIdx.contains(touchedDotIndex) {
            patternDotIdx.append(touchedDotIndex)
            
            linePath.move(to: dots[touchedDotIndex])
            linePath.lineWidth = 3
            
            movingPath.move(to: dots[touchedDotIndex])
            setNeedsDisplay()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if patternDotIdx.isEmpty {
            return
        }
        
        guard let touch = touches.first else { return }
        let touchPoint = touch.location(in: self)
        
        if let touchedDotIndex = getTouchedDotIndex(for: touchPoint), !patternDotIdx.contains(touchedDotIndex) {
            linePath.addLine(to: dots[touchedDotIndex])
            patternDotIdx.append(touchedDotIndex)
        }
        
        // 현재 터치 중인 선 그리기 (사용자가 점을 이동시킬 때)
        movingPath.removeAllPoints()
        movingPath.move(to: dots[patternDotIdx.last!])
        movingPath.lineWidth = 3
        movingPath.addLine(to: touchPoint)
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        linePath.removeAllPoints()
        movingPath.removeAllPoints()
        
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        linePath.removeAllPoints()
        movingPath.removeAllPoints()
        
        setNeedsDisplay()
    }
    
    // MARK: - Public Func
    /// 암호화된 패턴 반환
    func getPattern() -> String {
        return patternDotIdx.reduce("") { partialResult, value in
            partialResult + String(value)
        }
    }
    
    // MARK: - Private Func
    private func initPath() {
        for dot in dots {
            let dotPath = UIBezierPath(ovalIn: CGRect(x: dot.x - dotSize / 2, y: dot.y - dotSize / 2, width: dotSize, height: dotSize))
            UIColor.black.setFill()
            dotPath.fill()
        }
    }
    
    /// 뷰 크기를 바탕으로 패턴뷰 설정
    private func setupDots() {
        dots.removeAll()
        
        spacing.width = (originSize.width - margin.width * 2.0 - CGFloat(dotCol) * dotSize) / CGFloat(dotCol - 1)
        spacing.height = (originSize.height - margin.height * 2.0 - CGFloat(dotRow) * dotSize) / CGFloat(dotRow - 1)
        
        let dotAnchor = dotSize / 2
        
        for row in 0..<dotRow {
            for col in 0..<dotCol {
                let x = dotAnchor + margin.width + CGFloat(col) * (dotSize + spacing.width)
                let y = dotAnchor + margin.height + CGFloat(row) * (dotSize + spacing.height)
                dots.append(CGPoint(x: x, y: y))
            }
        }
        
        setNeedsDisplay()
    }
    
    private func getTouchedDotIndex(for point: CGPoint) -> Int? {
        for (index, dot) in dots.enumerated() {
            if abs(dot.x - point.x) < dotSize / 2 && abs(dot.y - point.y) < dotSize / 2 {
                return index
            }
        }
        return nil
    }
}
