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
    private let dotSize: CGFloat = 20
    private var dots: [CGPoint] = []
    private var dotRow = 5
    private var dotCol = 2
    private var isSetuped = false
    
    var margin = CGSize(width: 16, height: 16)
    var spacing = CGSize.zero
    
    // 사용자가 그린 패턴을 저장할 배열
    var patternDotIdx: [Int] = []
    
    private var originSize = CGSize.zero
    
    // 터치 이동 중인 점을 추적
    private var currentTouchDotIndex: Int?
    private var lastTouchPoint: CGPoint?
    
    // MARK: - Override Func
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// 초기 구성했던 크기에서 변동성이 생기면 패턴뷰 새로 설정
        if originSize != frame.size {
            originSize = frame.size
            setupDots()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if !isSetuped {
            return
        }
        
        // 점 그리기
        for dot in dots {
            let dotPath = UIBezierPath(ovalIn: CGRect(x: dot.x - dotSize / 2, y: dot.y - dotSize / 2, width: dotSize, height: dotSize))
            UIColor.black.setFill()
            dotPath.fill()
        }
        
        // 패턴 그리기 (사용자가 연결한 점들)
        let linePath = UIBezierPath()
        linePath.lineWidth = 3
        
        for (i, dotIdx) in patternDotIdx.enumerated() {
            if i == patternDotIdx.count - 1 {
                break
            }
            
            let startDot = dots[dotIdx]
            let endDot = dots[patternDotIdx[i + 1]]
            linePath.move(to: startDot)
            linePath.addLine(to: endDot)
            linePath.stroke()
        }
        
        // 현재 터치 중인 선 그리기 (사용자가 점을 이동시킬 때)
        if let lastTouchPoint = lastTouchPoint, let currentTouchDotIndex = currentTouchDotIndex {
            let startDot = dots[patternDotIdx.last ?? currentTouchDotIndex]
            linePath.move(to: startDot)
            linePath.addLine(to: lastTouchPoint)
            linePath.stroke()
        }
    }
    
    // 터치 이벤트 처리 (사용자가 점을 연결하는 패턴을 추적)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchPoint = touch.location(in: self)
        
        if let touchedDotIndex = getTouchedDotIndex(for: touchPoint), !patternDotIdx.contains(touchedDotIndex) {
            patternDotIdx.append(touchedDotIndex)
            setNeedsDisplay()
        }
        
        // 터치 시작 시 마지막 터치 포인트 초기화
        lastTouchPoint = touchPoint
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchPoint = touch.location(in: self)
        
        // 점에 닿지 않더라도 선을 그리기 위해 마지막 터치 포인트를 업데이트
        lastTouchPoint = touchPoint
        
        if let touchedDotIndex = getTouchedDotIndex(for: touchPoint), !patternDotIdx.contains(touchedDotIndex) {
            patternDotIdx.append(touchedDotIndex)
        }
        
        // 터치가 이동 중일 때, 그 이동 중인 점을 추적
        if let touchedDotIndex = getTouchedDotIndex(for: touchPoint) {
            currentTouchDotIndex = touchedDotIndex
        }
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentTouchDotIndex = nil
        lastTouchPoint = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentTouchDotIndex = nil
        lastTouchPoint = nil
    }
    
    // MARK: - Public Func
    /// 암호화된 패턴 반환
    func getPattern() -> String {
        return patternDotIdx.reduce("") { partialResult, value in
            partialResult + String(value)
        }
    }
    // 패턴 초기화
    func resetPattern() {
        patternDotIdx.removeAll()
        setNeedsDisplay()
    }
    
    // MARK: - Private Func
    /// 뷰 크기를 바탕으로 패턴뷰 설정
    private func setupDots() {
        dots.removeAll()
        isSetuped = true
        
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
