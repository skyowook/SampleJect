//
//  DrawingPathsAndShapes.swift
//  SwiftUISample
//
//  Created by skw on 6/27/24.
//

import SwiftUI

struct BadgeBackground: View {
    var body: some View {
           GeometryReader { geometry in
               Path { path in
                   var width: CGFloat = min(geometry.size.width, geometry.size.height)
                   let height = width
                   let xScale: CGFloat = 0.832
                   let xOffset = (width * (1.0 - xScale)) / 2.0
                   width *= xScale
                   path.move(
                       to: CGPoint(
                           x: width * 0.95 + xOffset,
                           y: height * (0.20 + HexagonParameters.adjustment)
                       )
                   )

                   HexagonParameters.segments.forEach { segment in
                       path.addLine(
                           to: CGPoint(
                               x: width * segment.line.x + xOffset,
                               y: height * segment.line.y
                           )
                       )

                       path.addQuadCurve(
                           to: CGPoint(
                               x: width * segment.curve.x + xOffset,
                               y: height * segment.curve.y
                           ),
                           control: CGPoint(
                               x: width * segment.control.x + xOffset,
                               y: height * segment.control.y
                           )
                       )
                   }
               }
               .fill(.linearGradient(
                   Gradient(colors: [Self.gradientStart, Self.gradientEnd]),
                   startPoint: UnitPoint(x: 0.5, y: 0),
                   endPoint: UnitPoint(x: 0.5, y: 0.6)
               ))
           }
           .aspectRatio(1, contentMode: .fit)
       }
       static let gradientStart = Color(red: 239.0 / 255, green: 120.0 / 255, blue: 221.0 / 255)
       static let gradientEnd = Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255)
}

struct BadgeSymbol: View {
    static let symbolColor = Color(red: 79.0 / 255, green: 79.0 / 255, blue: 191.0 / 255)
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = min(geometry.size.width, geometry.size.height)
                let height = width * 0.75
                let spacing = width * 0.030
                let middle = width * 0.5
                let topWidth = width * 0.226
                let topHeight = height * 0.488
                
                path.addLines([
                    CGPoint(x: middle, y: spacing),
                    CGPoint(x: middle - topWidth, y: topHeight - spacing),
                    CGPoint(x: middle, y: topHeight / 2 + spacing),
                    CGPoint(x: middle + topWidth, y: topHeight - spacing),
                    CGPoint(x: middle, y: spacing)
                ])
                
                path.move(to: CGPoint(x: middle, y: topHeight / 2 + spacing * 3))
                path.addLines([
                    CGPoint(x: middle - topWidth, y: topHeight + spacing),
                    CGPoint(x: spacing, y: height - spacing),
                    CGPoint(x: width - spacing, y: height - spacing),
                    CGPoint(x: middle + topWidth, y: topHeight + spacing),
                    CGPoint(x: middle, y: topHeight / 2 + spacing * 3)
                ])
            }
            .fill(Self.symbolColor)
        }
    }
}

struct RotatedBadgeSymbol: View {
    let angle: Angle
    
    var body: some View {
        BadgeSymbol()
            .padding(-60)
            .rotationEffect(angle, anchor: .bottom)
    }
}

struct Badge: View {
    var badgeSymbols: some View {
        ForEach(0..<8) { index in
            RotatedBadgeSymbol(angle: .degrees(Double(index) / Double(8)) * 360.0)
        }.opacity(0.5)
    }
    
    var body: some View {
        ZStack {
            BadgeBackground()
            
            GeometryReader { geometry in
                badgeSymbols
                    .scaleEffect(1.0 / 4.0, anchor: .top)
                    .position(x: geometry.size.width / 2.0, y: (3.0 / 4.0) * geometry.size.height)
            }
        }.scaledToFit()
    }
}

#Preview {
//    BadgeBackground()
//    BadgeSymbol()
//    RotatedBadgeSymbol(angle: Angle(degrees: 5))
    Badge()
}
