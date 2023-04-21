//
//  CreateAnalogClock.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 4/21/23.
//

import SwiftUI

struct CreateAnalogClock: View {
    var body: some View {
        AnalogClock()
    }
}

struct CreateAnalogClock_Previews: PreviewProvider {
    static var previews: some View {
        CreateAnalogClock()
    }
}

struct AnalogClock: View {
    @State private var currentTime = Date()
    
    var body: some View {
        VStack {
            Text("Analog Clock")
                .font(.title)
                .padding()
            
            GeometryReader { geometry in
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .shadow(radius: 10)
                    
                    ForEach(1...12, id: \.self) { index in
                        let tickSize = index % 3 == 0 ? 12 : 6
                        let tickWidth: CGFloat = 2
                        let tickHeight = geometry.size.width / 2 - tickWidth - 24
                        let tickAngle = Double(index) * 30.0
                        let tickColor = index % 3 == 0 ? Color.orange : Color.black
                        TickView(size: CGFloat(tickSize), width: tickWidth, height: tickHeight, color: tickColor)
                            .offset(y: -tickHeight / 2)
                            .rotationEffect(Angle(degrees: tickAngle))
                    }
                    .rotationEffect(Angle(degrees: -90))
                    
                    HourHandView(angle: hourAngleFromTime(currentTime), width: 8, height: geometry.size.width / 2 - 80, color: .orange)
                        .rotationEffect(hourAngleFromTime(currentTime), anchor: .center)
                    
                    MinuteHandView(angle: minuteAngleFromTime(currentTime), width: 4, height: geometry.size.width / 2 - 60, color: .blue)
                        .rotationEffect(minuteAngleFromTime(currentTime), anchor: .center)
                    
                    SecondHandView(angle: secondAngleFromTime(currentTime), width: 2, height: geometry.size.width / 2 - 40, color: .red)
                        .rotationEffect(secondAngleFromTime(currentTime), anchor: .center)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .padding()
        .onAppear {
            let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                currentTime = Date()
            }
            timer.tolerance = 0.1
        }
    }
    
    func hourAngleFromTime(_ time: Date) -> Angle {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: time)
        let minute = calendar.component(.minute, from: time)
        let hourAngle = Angle(degrees: Double(hour * 30))
        let minuteAngle = Angle(degrees: Double(Double(minute) * 0.5))
        return hourAngle + minuteAngle
    }
    
    func minuteAngleFromTime(_ time: Date) -> Angle {
        let calendar = Calendar.current
        let minute = calendar.component(.minute, from: time)
        return Angle(degrees: Double(minute) * 6)
    }
    
    func secondAngleFromTime(_ time: Date) -> Angle {
        let calendar = Calendar.current
        let second = calendar.component(.second, from: time)
        return Angle(degrees: Double(second) * 6)
    }
}

struct TickView: View {
    let size: CGFloat
    let width: CGFloat
    let height: CGFloat
    let color: Color
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: width, height: height)
            .offset(y: -height / 2)
            .cornerRadius(width / 2)
    }
}

struct HourHandView: View {
    let angle: Angle
    let width: CGFloat
    let height: CGFloat
    let color: Color
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: width / 2, height: height / 2)
            .cornerRadius(width / 2)
            .offset(x: -width / 4, y: -height / 4)
    }
}

struct MinuteHandView: View {
    let angle: Angle
    let width: CGFloat
    let height: CGFloat
    let color: Color
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: width / 2, height: height / 2)
            .cornerRadius(width / 2)
            .offset(x: -width / 4, y: -height / 4)
    }
}

struct SecondHandView: View {
    let angle: Angle
    let width: CGFloat
    let height: CGFloat
    let color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .fill(color)
                .frame(width: width, height: width)
                .offset(y: -height)
            
            Rectangle()
                .fill(color)
                .frame(width: width, height: height)
                .rotationEffect(angle, anchor: .bottom)
        }
        .offset(y: -height / 2)
    }
}

//struct AnalogClock: View {
//    @State private var currentTime = Date()
//    @State private var selectedTime: Date = Date()
//
//    var body: some View {
//        VStack {
//            Text("Analog Clock")
//                .font(.title)
//                .padding()
//
//            GeometryReader { geometry in
//                ZStack {
//                    Circle()
//                        .fill(Color.white)
//                        .shadow(radius: 10)
//
//                    ForEach(1...12, id: \.self) { index in
//                        let tickSize = index % 3 == 0 ? 12 : 6
//                        let tickWidth: CGFloat = 2
//                        let tickHeight = geometry.size.width / 2 - tickWidth - 24
//                        let tickAngle = Double(index) * 30.0
//                        let tickColor = index % 3 == 0 ? Color.orange : Color.black
//                        TickView(size: CGFloat(tickSize), width: tickWidth, height: tickHeight, color: tickColor)
//                            .offset(y: -tickHeight / 2)
//                            .rotationEffect(Angle(degrees: tickAngle))
//                    }
//                    .rotationEffect(Angle(degrees: -90))
//
//                    HourHandView(angle: hourAngleFromTime(selectedTime), width: 8, height: geometry.size.width / 2 - 80, color: .orange)
//                        .rotationEffect(hourAngleFromTime(selectedTime), anchor: .center)
//
//                    MinuteHandView(angle: minuteAngleFromTime(selectedTime), width: 4, height: geometry.size.width / 2 - 60, color: .blue)
//                        .rotationEffect(minuteAngleFromTime(selectedTime), anchor: .center)
//
//                    SecondHandView(angle: secondAngleFromTime(selectedTime), width: 2, height: geometry.size.width / 2 - 40, color: .red)
//                        .rotationEffect(secondAngleFromTime(selectedTime), anchor: .center)
//                }
//                .frame(width: geometry.size.width, height: geometry.size.height)
//            }
//
//            HStack {
//                Text("Set time:")
//                DatePicker(
//                    "",
//                    selection: $selectedTime,
//                    displayedComponents: [.hourAndMinute, .date]
//                )
//                .labelsHidden()
//            }
//        }
//        .padding()
//        .onAppear {
//            let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//                currentTime = Date()
//            }
//            timer.tolerance = 0.1
//        }
//    }
//
//    func hourAngleFromTime(_ time: Date) -> Angle {
//        let calendar = Calendar.current
//        let hour = calendar.component(.hour, from: time)
//        let minute = calendar.component(.minute, from: time)
//        let hourAngle = Angle(degrees: Double(hour * 30))
//        let minuteAngle = Angle(degrees: Double(Double(minute) * 0.5))
//        return hourAngle + minuteAngle
//    }
//
//    func minuteAngleFromTime(_ time: Date) -> Angle {
//        let calendar = Calendar.current
//        let minute = calendar.component(.minute, from: time)
//        return Angle(degrees: Double(minute) * 6)
//    }
//
//    func secondAngleFromTime(_ time: Date) -> Angle {
//        let calendar = Calendar.current
//        let second = calendar.component(.second, from: time)
//        return Angle(degrees: Double(second) * 6)
//    }
//}

//struct AnalogClock: View {
//    @State private var currentTime = Date()
//
//    var body: some View {
//        VStack {
//            Text("Analog Clock")
//                .font(.title)
//                .padding()
//
//            GeometryReader { geometry in
//                ZStack {
//                    Circle()
//                        .fill(Color.white)
//                        .shadow(radius: 10)
//
//                    ForEach(1...12, id: \.self) { index in
//                        let tickSize = index % 3 == 0 ? 12 : 6
//                        let tickWidth: CGFloat = 2
//                        let tickHeight = geometry.size.width / 2 - tickWidth - 24
//                        let tickAngle = Double(index) * 30.0
//                        let tickColor = index % 3 == 0 ? Color.orange : Color.black
//                        TickView(size: CGFloat(tickSize), width: tickWidth, height: tickHeight, color: tickColor)
//                            .offset(y: -tickHeight / 2)
//                            .rotationEffect(Angle(degrees: tickAngle))
//                    }
//                    .rotationEffect(Angle(degrees: -90))
//
//                    HourHandView(angle: hourAngleFromTime(currentTime), width: 8, height: geometry.size.width / 2 - 80, color: .orange)
//                        .rotationEffect(hourAngleFromTime(currentTime), anchor: .center)
//
//                    MinuteHandView(angle: minuteAngleFromTime(currentTime), width: 4, height: geometry.size.width / 2 - 60, color: .blue)
//                        .rotationEffect(minuteAngleFromTime(currentTime), anchor: .center)
//
//                    SecondHandView(angle: secondAngleFromTime(currentTime), width: 2, height: geometry.size.width / 2 - 40, color: .red)
//                        .rotationEffect(secondAngleFromTime(currentTime), anchor: .center)
//                }
//                .frame(width: geometry.size.width, height: geometry.size.height)
//            }
//        }
//        .padding()
//        .onAppear {
//            let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//                currentTime = Date()
//            }
//            timer.tolerance = 0.1
//        }
//    }
//
//    func hourAngleFromTime(_ time: Date) -> Angle {
//        let calendar = Calendar.current
//        let hour = calendar.component(.hour, from: time)
//        let minute = calendar.component(.minute, from: time)
//        let hourAngle = Angle(degrees: Double(hour * 30))
//        let minuteAngle = Angle(degrees: Double(Double(minute) * 0.5))
//        return hourAngle + minuteAngle
//    }
//
//    func minuteAngleFromTime(_ time: Date) -> Angle {
//        let calendar = Calendar.current
//        let minute = calendar.component(.minute, from: time)
//        return Angle(degrees: Double(minute) * 6)
//    }
//
//    func secondAngleFromTime(_ time: Date) -> Angle {
//        let calendar = Calendar.current
//        let second = calendar.component(.second, from: time)
//        return Angle(degrees: Double(second) * 6)
//    }
//}

//struct TickView: View {
//    let size: CGFloat
//    let width: CGFloat
//    let height: CGFloat
//    let color: Color
//
//    var body: some View {
//        Rectangle()
//            .fill(color)
//            .frame(width: width, height: height)
//            .offset(y: -height / 2)
//            .cornerRadius(width / 2)
//    }
//}
//
//struct HourHandView: View {
//    let angle: Angle
//    let width: CGFloat
//    let height: CGFloat
//    let color: Color
//
//    var body: some View {
//        Rectangle()
//            .fill(color)
//            .frame(width: width / 2, height: height / 2)
//            .cornerRadius(width / 2)
//            .offset(x: -width / 4, y: -height / 4)
//    }
//}
//
//struct MinuteHandView: View {
//    let angle: Angle
//    let width: CGFloat
//    let height: CGFloat
//    let color: Color
//
//    var body: some View {
//        Rectangle()
//            .fill(color)
//            .frame(width: width / 2, height: height / 2)
//            .cornerRadius(width / 2)
//            .offset(x: -width / 4, y: -height / 4)
//    }
//}
//
//struct SecondHandView: View {
//    let angle: Angle
//    let width: CGFloat
//    let height: CGFloat
//    let color: Color
//
//    var body: some View {
//        ZStack {
//            Circle()
//                .fill(color)
//                .frame(width: width, height: width)
//                .offset(y: -height)
//
//            Rectangle()
//                .fill(color)
//                .frame(width: width, height: height)
//                .rotationEffect(angle, anchor: .bottom)
//        }
//        .offset(y: -height / 2)
//    }
//}
