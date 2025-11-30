import SwiftUI

struct LineGraphView: View {
    @Environment(\.colorScheme) private var colorScheme
    let entries: [HabitEntry]
    let accent: Color
    
    @State private var hoveredIndex: Int?

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
                ForEach(Array(points.enumerated()), id: \.offset) { index, point in
                    GraphPointHitArea(
                        accent: accent,
                        isHovered: hoveredIndex == index,
                        onHover: { isHovering in
                            withAnimation(.easeInOut(duration: 0.15)) {
                                hoveredIndex = isHovering ? index : nil
                            }
                        }
                    )
                    .position(point)
                }
                
                // Tooltip overlay
                if let index = hoveredIndex, index < entries.count, index < points.count {
                    GraphTooltip(
                        entry: entries[index],
                        position: points[index],
                        containerSize: size,
                        colorScheme: colorScheme
                    )
                    .allowsHitTesting(false)
                }
            }
        }
    }

    private func makePoints(for entries: [HabitEntry], in size: CGSize) -> [CGPoint] {
        guard !entries.isEmpty else { return [] }
        let values = entries.map { $0.value }
        
        // Use a fixed range from 0 to 1.0 (or higher if values exceed 100%)
        // This ensures the graph always represents 0% at bottom and 100% at top
        let minValue = 0.0
        let maxValue = max(values.max() ?? 1.0, 1.0)
        let range = maxValue - minValue
        let count = entries.count - 1

        return entries.enumerated().map { index, entry in
            let xFraction = count == 0 ? 0.5 : Double(index) / Double(count)
            let normalized = (entry.value - minValue) / range
            let y = (1 - normalized) * size.height
            return CGPoint(x: xFraction * size.width, y: y)
        }
    }
}

private struct GraphPointHitArea: View {
    let accent: Color
    let isHovered: Bool
    let onHover: (Bool) -> Void
    
    var body: some View {
        ZStack {
            // Invisible hit area
            Circle()
                .fill(Color.clear)
                .frame(width: 30, height: 30)
                .contentShape(Circle())
            
            // Visible point
            GraphPoint(accent: accent, isHovered: isHovered)
        }
        .onHover { isHovering in
            onHover(isHovering)
        }
    }
}

private struct GraphPoint: View {
    let accent: Color
    let isHovered: Bool
    
    var body: some View {
        Circle()
            .fill(Color.white)
            .frame(width: isHovered ? 12 : 8, height: isHovered ? 12 : 8)
            .overlay(
                Circle()
                    .stroke(accent, lineWidth: isHovered ? 3 : 2)
            )
            .shadow(color: accent.opacity(0.7), radius: isHovered ? 12 : 8, x: 0, y: 5)
    }
}

private struct GraphTooltip: View {
    let entry: HabitEntry
    let position: CGPoint
    let containerSize: CGSize
    let colorScheme: ColorScheme
    
    private var formattedDate: String {
        guard let date = entry.date else { return entry.label }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d"
        return formatter.string(from: date)
    }
    
    private var percentageText: String {
        "\(Int(entry.value * 100))%"
    }
    
    private var tooltipOffset: CGSize {
        let tooltipWidth: CGFloat = 100
        let tooltipHeight: CGFloat = 50
        let padding: CGFloat = 8
        
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = -tooltipHeight - padding
        
        // Adjust X if too close to edges
        if position.x < tooltipWidth / 2 + padding {
            xOffset = tooltipWidth / 2 - position.x + padding
        } else if position.x > containerSize.width - tooltipWidth / 2 - padding {
            xOffset = containerSize.width - tooltipWidth / 2 - position.x - padding
        }
        
        // Flip tooltip below if too close to top
        if position.y < tooltipHeight + padding + 20 {
            yOffset = padding + 20
        }
        
        return CGSize(width: xOffset, height: yOffset)
    }
    
    var body: some View {
        VStack(spacing: 2) {
            Text(formattedDate)
                .font(.caption2.weight(.medium))
                .foregroundStyle(colorScheme == .dark ? .white.opacity(0.7) : .secondary)
            Text(percentageText)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(colorScheme == .dark ? .white : .primary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(colorScheme == .dark ? Color(.darkGray) : Color.white)
                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        )
        .position(x: position.x + tooltipOffset.width, y: position.y + tooltipOffset.height)
        .transition(.opacity.combined(with: .scale(scale: 0.9)))
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
