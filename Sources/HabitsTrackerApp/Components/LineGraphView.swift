import SwiftUI

struct LineGraphView: View {
    let entries: [HabitEntry]
    let accent: Color

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            let points = makePoints(for: entries, in: size)
            let gradient = LinearGradient(colors: [accent.opacity(0.4), accent.opacity(0.05)], startPoint: .top, endPoint: .bottom)

            ZStack {
                GraphGrid()
                if points.count > 1 {
                    Path.closedArea(points: points, in: size)
                        .fill(gradient)
                        .opacity(0.7)
                    Path.polyline(points: points)
                        .stroke(accent, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                }
                ForEach(Array(points.enumerated()), id: \.offset) { _, point in
                    Circle()
                        .fill(Color.white)
                        .frame(width: 8, height: 8)
                        .overlay(
                            Circle()
                                .stroke(accent, lineWidth: 2)
                        )
                        .shadow(color: accent.opacity(0.7), radius: 8, x: 0, y: 5)
                        .position(point)
                }
            }
        }
    }

    private func makePoints(for entries: [HabitEntry], in size: CGSize) -> [CGPoint] {
        guard !entries.isEmpty else { return [] }
        let values = entries.map { $0.value }
        guard let minValue = values.min(), let maxValue = values.max() else { return [] }
        let range = max(maxValue - minValue, 1)
        let count = entries.count - 1

        return entries.enumerated().map { index, entry in
            let xFraction = count == 0 ? 0 : Double(index) / Double(count)
            let normalized = (entry.value - minValue) / range
            let y = (1 - normalized) * size.height
            return CGPoint(x: xFraction * size.width, y: y)
        }
    }
}

private struct GraphGrid: View {
    var body: some View {
        GeometryReader { geometry in
            let horizontalLines = 4
            let spacing = geometry.size.height / CGFloat(horizontalLines)

            ForEach(0...horizontalLines, id: \.self) { index in
                Path { path in
                    let y = CGFloat(index) * spacing
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                }
                .stroke(Color.white.opacity(0.08), style: StrokeStyle(lineWidth: 1, dash: [4, 8]))
            }
        }
    }
}

private extension Path {
    static func polyline(points: [CGPoint]) -> Path {
        var path = Path()
        guard let firstPoint = points.first else { return path }
        path.move(to: firstPoint)
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        return path
    }

    static func closedArea(points: [CGPoint], in size: CGSize) -> Path {
        var path = Path()
        guard let firstPoint = points.first, let lastPoint = points.last else { return path }
        path.move(to: CGPoint(x: firstPoint.x, y: size.height))
        path.addLine(to: firstPoint)
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        path.addLine(to: CGPoint(x: lastPoint.x, y: size.height))
        path.closeSubpath()
        return path
    }
}
