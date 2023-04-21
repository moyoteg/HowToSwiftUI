//
//  SandBox.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 2/16/21.
//

import SwiftUI
import MapKit
import NetworkExtension
import CoreLocation
import SystemConfiguration.CaptiveNetwork

import SwiftUIComponents
import SwiftUICharts
import SwiftUtilities
import CloudyLogs

// Permissions
import PermissionsKit
import NotificationPermission
import BluetoothPermission
import FaceIDPermission
import CameraPermission
import PhotoLibraryPermission
import NotificationPermission
import MicrophonePermission
import CalendarPermission
import ContactsPermission
import RemindersPermission
import SpeechRecognizerPermission
import LocationWhenInUsePermission
import LocationAlwaysPermission
import MotionPermission
import MediaLibraryPermission
import BluetoothPermission
import TrackingPermission
import FaceIDPermission
import SiriPermission
import HealthPermission

struct SandBox: View {
    
    /// *********
    // not using
    var colors = [Color.blue,  Color.pink, Color.green, Color.yellow, Color.purple] {
        didSet {
            pageCount = colors.count
        }
    }
    var symbols = ["car", "pencil", "bus", "star", "waveform.path.ecg.rectangle"]
    @State var currentPage: Int = 0
    @State var pageCount: Int = 0
    @State var direction: ReflectDirection = .bottom
    
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var locations = [MKPointAnnotation]()
    
    let data: [Double] = [-69, -70, -71, -71, -70, -70, -70, -69, -66]
    /// *********
    
    /// *********
    // using
    @State var title = "Wifi RSSI"
    @State var legend = ""
    @State var networkSSID: String = "--"
    @State var signalStrength: Double? = 0 {
        didSet {
            if let signalStrength = signalStrength {
                
                let historyCapacity = 10
                
                signalStrengthHistory.insert(signalStrength, at: 0)
                
                if self.signalStrengthHistory.count >= historyCapacity {
                    signalStrengthHistory.removeLast()
                }
                
            }
        }
    }
    @State var signalStrengthHistory: [Double] = []
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let locationManager = CLLocationManager()
    /// *********
    
    let height = 100.0
    let width = 150.0
    
    @State var percentage: Double = 0
    
    var currentWidth: Double {
        width * percentage/100
    }
    
    @State private var isPresented = false
    
    @State var listSelection: Lists = .symbol
    
    enum Lists: String, CaseIterable, Identifiable {
        
        var id: String { self.rawValue }
        
        case symbol
        case symbol2
    }
    
    var symbols2 = ["waveform.path.ecg.rectangle", "pencil", "star"]
    
    private var listToPresent: [String] {
        switch listSelection {
        case .symbol:
            return symbols
        case .symbol2:
            return symbols2
        }
    }
    
    static var longList:[String] = {
        
        var logs = [String]()
        
        for log in 1...100 {
            logs.append("log: \(log)")
        }
        
        return logs
    }()
    
    @State var showConsole = false
    
    @State var showInteractionLocation = false

    @State var newMessage = "test"

    public var body: some View {

//        MedicationConsumptionChart()
//        AnalogClock()
        SevenSegmentClock()
    }
    
}

struct MedicationConsumptionChart: View {
    @State private var medicationName: String = ""
    @State private var notes: String = ""
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    @State private var days: [Day] = []
    
//    private let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    var body: some View {
        Form {
            TextField("Medication Name", text: $medicationName)
            TextField("Notes", text: $notes)
            Picker(selection: $selectedMonth, label: Text("Month")) {
                ForEach(Month.allCases) { month in
                    Text(month.name).tag(month.rawValue)
                }
            }
            .onChange(of: selectedMonth, perform: { value in
                
                print("selectedMonth: \(selectedMonth)")
                
                updateDays()
            })
            
            Picker(selection: $selectedYear, label: Text("Year")) {
                ForEach(Calendar.current.component(.year, from: Date()) - 5..<Calendar.current.component(.year, from: Date()) + 5, id: \.self) {
                    Text("\($0)").tag($0)
                }
            }
            .onChange(of: selectedYear, perform: { selectedYear in
                
                print("selectedYear: \(selectedYear)")
                updateDays()
                
            })
            
            Section {
                ForEach($days) { day in
                    VStack {
                        
                        HStack {
                            Text("\(day.date.wrappedValue, formatter: MedicationConsumptionChart.dateFormat)")
                            Divider()
                            Picker(selection: day.time, label: Text("Time")) {
                                ForEach(Time.allCases, id: \.self) { time in
                                    Text(time.rawValue)
                                }
                            }
                        }

                        Picker(selection: day.status, label: Text("Status")) {
                            ForEach(Status.allCases) { status in
                                Text(status.rawValue).tag(status)
                            }
                        }
                        TextField("Notes", text: day.notes)
                    }
                }
            }

                .onAppear { updateDays() }
        }
    }
    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
//        formatter.dateFormat = "dd-MM-yyyy"
        formatter.dateFormat = "dd MMMM (yyyy)"

        return formatter
    }()

    func updateDays() {
        
        let numberOfDaysInMonth = numberOfDaysInMonth(month: self.selectedMonth, year: self.selectedYear)
        self.days = (1...numberOfDaysInMonth).compactMap {
            let dateComponents = DateComponents(year: self.selectedYear, month: self.selectedMonth, day: $0)
            guard let date = Calendar.current.date(from: dateComponents) else { return nil }
            return Day(date: date)
        }
    }

    func numberOfDaysInMonth(month: Int, year: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        return calendar.range(of: .day, in: .month, for: calendar.date(from: dateComponents)!)!.count
    }

//    func numberOfDaysInMonth(month: Int, year: Int) -> Int {
//        let dateComponents = DateComponents(year: year, month: month)
//        let calendar = Calendar.current
//        let date = calendar.date(from: dateComponents)
//        let range = calendar.range(of: .day, in: .month, for: date!)
//        return range?.count ?? 0
//    }
    
}

// Enum for options of time
enum Time: String, CaseIterable {
    case am = "AM"
    case pm = "PM"
}

enum Month: Int, CaseIterable, Identifiable {
    
    var id: Int { rawValue }
    
    case january = 1, february, march, april, may, june, july, august, september, october, november, december
    
    var name: String {
        switch self {
        case .january: return "January"
        case .february: return "February"
        case .march: return "March"
        case .april: return "April"
        case .may: return "May"
        case .june: return "June"
        case .july: return "July"
        case .august: return "August"
        case .september: return "September"
        case .october: return "October"
        case .november: return "November"
        case .december: return "December"
        }
    }
}


class Day: ObservableObject, Identifiable {
    var id: Date {
        date
    }
    @Published var date: Date
    @Published var time: Time = .am
    @Published var status: Status = .none
    @Published var notes: String = ""
    init(date: Date) {
        self.date = date
    }
}

enum Status: String, CaseIterable, Identifiable, Hashable {
    
    var id: String { rawValue }
    
    case caregiverInitial = "Caregiver Initial"
    case patientDeclined = "Patient Declined"
    case medicationDiscontinued = "Medication Discontinued"
    case patientHospitalized = "Patient Hospitalized"
    case takenOutOfFacility = "Taken Out Of Facility"
    case none = "None"
}


//struct ChartView: View {
//
//    @State private var selectedYear = Calendar.current.component(.year, from: Date())
//    @State private var selectedMonth = Calendar.current.component(.month, from: Date())
////    @State private var days: [Day] = (1...Calendar.current.component(.day, from: Date())).map { Day(date: DateComponents(year: Calendar.current.component(.year, from: Date()), month: Calendar.current.component(.month, from: Date()), day: $0).date!) }
//
//    @State private var days: [Day] = (1...Calendar.current.component(.day, from: Date()))
//        .compactMap {
//            if let date = DateComponents(year: Calendar.current.component(.year, from: Date()), month: Calendar.current.component(.month, from: Date()), day: $0).date {
//                return date
//            } else {
//                return nil
//            }
//
//        }
//        .map { Day(date: $0) }
//
//    var body: some View {
//        VStack {
//            HStack {
//                Picker(selection: $selectedYear, label: Text("Year")) {
//                    ForEach(Calendar.current.component(.year, from: Date()) - 5..<Calendar.current.component(.year, from: Date()) + 5) {
//                        Text("\($0)").tag($0)
//                    }
//                }.pickerStyle(WheelPickerStyle())
//
//                Picker(selection: $selectedMonth, label: Text("Month")) {
//                    ForEach(1..<12) {
//                        Text(DateFormatter().monthSymbols[$0-1]).tag($0)
//                    }
//                }.pickerStyle(WheelPickerStyle())
//
//            }
//            ScrollView {
//                VStack {
//                    ForEach($days) { day in
//                        DayView(day: day)
//                    }
//                }
//            }
//        }.onChange(of: selectedMonth, perform: { value in
//            self.days = (1...Calendar.current.range(of: .day, in: .month, for: DateComponents(year: self.selectedYear, month: value).date!)!.count).map { Day(date: DateComponents(year: self.selectedYear, month: value, day: $0).date!) }
//        }).onChange(of: selectedYear, perform: { value in
//            self.days = (1...Calendar.current.range(of: .day, in: .month, for: DateComponents(year: value, month: self.selectedMonth).date!)!.count).map { Day(date: DateComponents(year: value, month: self.selectedMonth, day: $0).date!) }
//        })
//    }
//}
//
//struct DayView: View {
//    @Binding var day: Day
//    var body: some View {
//        VStack {
//            Text("\(day.date, formatter: DateFormatter())")
//            Picker(selection: $day.status, label: Text("Status")) {
//                ForEach(Status.allCases) { status in
//                    Text(status.rawValue).tag(status)
//                }
//            }
//            TextField("Notes", text: $day.notes)
//        }
//    }
//}
//
//class Day: ObservableObject, Identifiable {
//
//    var id: TimeInterval {
//        date.timeIntervalSince1970
//    }
//    var date: Date
//    @Published var status: Status = .none
//    @Published var notes = ""
//    init(date: Date) {
//        self.date = date
//    }
//}
//
//import SwiftUI
//
//enum Status: String, CaseIterable, Identifiable {
//
//    var id: String {
//        return rawValue
//    }
//
//    case caregiverInitial = "Caregiver Initial"
//    case patientDeclined = "D"
//    case medicationDiscontinued = "D/C"
//    case patientHospitalized = "H"
//    case takenOutOfFacility = "Out"
//    case none = "None"
//}

//class Day {
//    var date: Date
//    var option: MedicationOption
//    var notes: String
//
//    init(date: Date, option: MedicationOption = .none, notes: String = "") {
//        self.date = date
//        self.option = option
//        self.notes = notes
//    }
//}

//class Day {
//    var date: Date
//    var option: MedicationOption = .none
//    var notes: String = ""
//    init(date: Date) {
//        self.date = date
//    }
//}
//
//
//struct ChartView: View {
//    @State private var selectedYear = Calendar.current.component(.year, from: Date())
//    @State private var selectedMonth = Calendar.current.component(.month, from: Date())
//
//    @State private var days: [Day] = (1...31).map {
//        let date = Calendar.current.date(byAdding: .day, value: $0, to: Date())
//        return Day(date: date!)
//    }
//
//    var body: some View {
//
//        VStack {
//            HStack {
//                Text("Month:")
//                Picker(selection: $selectedMonth, label: Text("Month")) {
//                    ForEach(1..<13) { month in
//                        Text(DateFormatter().monthSymbols[month - 1]).tag(month)
//                    }
//                }.onChange(of: $selectedMonth) { value in
//                    updateNumberOfDays()
//                }
//
//                Text("Year:")
//                Picker(selection: $selectedYear, label: Text("Year")) {
//                    ForEach(Calendar.current.component(.year, from: Date()) - 5...Calendar.current.component(.year, from: Date()) + 5) {
//                        Text("\($0)").tag($0)
//                    }
//                }.onChange(of: $selectedYear) { value in
//                    updateNumberOfDays()
//                }
//
//            }
//            .padding()
//            List {
//                ForEach(days.indices) { day in
//                    DayView(day: self.$days[day])
//                }
//            }
//            Button(action: {
////                self.generatePDF()
//            }) {
//                Text("Generate PDF")
//            }
//        }
//    }
//
//    private func updateNumberOfDays() {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let dateString = "\(self.selectedYear)-\(self.selectedMonth)-01"
//        let date = dateFormatter.date(from: dateString)!
//        let range = Calendar.current.range(of: .day, in: .month, for: date)!
//        let numberOfDays = range.count
//        self.days = (1...numberOfDays).map { Day(day: $0) }
//    }
//
//    func daysInMonth(year: Int, month: Int) -> Int {
//        let dateComponents = DateComponents(year: year, month: month + 1)
//        let calendar = Calendar.current
//        let date = calendar.date(from: dateComponents)!
//        let range = calendar.range(of: .day, in: .month, for: date)!
//        return range.count
//    }
//}
//struct ChartView: View {
//    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
//    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date())
//    @State private var days: [Day] = (1...31).map { Day(day: $0, month: selectedMonth) }
//
//    var body: some View {
//        VStack {
//            Picker(selection: $selectedYear, label: Text("Year")) {
//                ForEach(1900...2100, id: \.self) {
//                    Text("\($0)")
//                }
//            }
//            Picker(selection: $selectedMonth, label: Text("Month")) {
//                ForEach(1...12, id: \.self) {
//                    Text("\($0)")
//                }
//            }
//            ScrollView {
//                ForEach(days) { day in
//                    DayView(day: $day)
//                }
//            }
//        }
//    }
//}
//
//class Day {
//    var day: Int
//    var month: Int
//    var option: Option = .none
//    var notes: String = ""
//
//    init(day: Int, month: Int) {
//        self.day = day
//        self.month = month
//    }
//}

//struct ChartView: View {
//
//    @State private var year = 2022
//    @State private var month = 1
//    @State private var days = [Day]()
//
//    private let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
//
//    var body: some View {
//        VStack {
//            HStack {
//                Picker("Year", selection: $year) {
//                    ForEach(1900...2050, id: \.self) {
//                        Text("\($0)")
//                    }
//                }
//                .pickerStyle(SegmentedPickerStyle())
//
//                Picker("Month", selection: $month) {
//                    ForEach(0..<months.count, id: \.self) {
//                        Text(months[$0])
//                    }
//                }
//                .pickerStyle(SegmentedPickerStyle())
//            }
//
//            ScrollView {
//                VStack {
//                    ForEach(1...daysInMonth(year: year, month: month), id: \.self) { day in
//                        DayView(day: self.$days[day - 1])
//                    }
//                }
//            }
//            Button(action: {
////                self.generatePDF()
//            }) {
//                Text("Generate PDF")
//            }
//        }
//    }
//
//    func daysInMonth(year: Int, month: Int) -> Int {
//        let dateComponents = DateComponents(year: year, month: month + 1)
//        let calendar = Calendar.current
//        let date = calendar.date(from: dateComponents)!
//        let range = calendar.range(of: .day, in: .month, for: date)!
//        return range.count
//    }
//}
                                                   
//struct ChartView: View {
//    @State private var year = 2022
//    @State private var month = 1
//    @State private var days = [Day]()
//    var body: some View {
//        VStack {
//            HStack {
//                Text("Year:")
//                Picker("Year", selection: $year) {
//                    ForEach(2020...2025, id: \.self) {
//                        Text("\($0)")
//                    }
//                }
//                .pickerStyle(WheelPickerStyle())
//
//                Text("Month:")
//                Picker("Month", selection: $month) {
//                    ForEach(1...12, id: \.self) {
//                        Text("\($0)")
//                    }
//                }
//                .pickerStyle(WheelPickerStyle())
//            }
//            .padding()
//
//            ScrollView {
//                ForEach(1...daysInMonth(year: year, month: month), id: \.self) { day in
//                    DayView(day: self.$days[day - 1])
//                }
//            }
//        }
//    }
//
//    func daysInMonth(year: Int, month: Int) -> Int {
//        let dateComponents = DateComponents(year: year, month: month)
//        let calendar = Calendar.current
//        let date = calendar.date(from: dateComponents)!
//        let range = calendar.range(of: .day, in: .month, for: date)!
//        return range.count
//    }
//}

//class Day {
//    var date: String
//    var option: String
//    var notes: String
//
//    init(date: String, option: String, notes: String) {
//        self.date = date
//        self.option = option
//        self.notes = notes
//    }
//}

//struct DayView: View {
//    @Binding var day: Day
//
//    let dateFormatter: DateFormatter = {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM/dd/yyyy"
//        return dateFormatter
//    }()
//
//    var body: some View {
//        VStack {
//            Text("\(day.date, formatter: dateFormatter)")
//            Picker("Option", selection: $day.option) {
//                ForEach(Option.allCases, id: \.self) { option in
//                    Text(option.rawValue)
//                }
//            }
//            .pickerStyle(SegmentedPickerStyle())
//            TextField("Notes", text: $day.notes)
//        }
//        .padding()
//    }
//}
//
//enum Option: String, CaseIterable {
//    case caregiverInitial = "Caregiver Initial"
//    case patientDeclined = "Patient Declined"
//    case medicationDiscontinued = "Medication Discontinued"
//    case patientHospitalized = "Patient Hospitalized"
//    case takenOutOfFacility = "Taken Out of Facility"
//    case none = "None"
//}

// ----------------------------------------

//import SwiftUI
//import UIKit
//
//enum Option: String, CaseIterable {
//    case caregiverInitial = "Caregiver Initial"
//    case declined = "D"
//    case discontinued = "D/C"
//    case hospital = "H"
//    case outOfFacility = "Out of Facility"
//    case none = "None"
//}
//
//class Day {
//    var option: Option
//    var notes: String
//    var date: Date
//
//    init(option: Option = .none, notes: String = "", date: Date) {
//        self.option = option
//        self.notes = notes
//        self.date = date
//    }
//}
//
//struct ChartView: View {
//
//    @State var selectedYear: Int = 2022
//    @State var selectedMonth: Int = 0
//
//    @State var days = [Day]()
//
//    @State private var showShareLink = false
//    @State private var fileURL: URL?
//
//    var daysInMonth: Int {
//        let dateComponents = DateComponents(year: selectedYear, month: selectedMonth)
//        let calendar = Calendar.current
//        let date = calendar.date(from: dateComponents)!
//        let range = calendar.range(of: .day, in: .month, for: date)!
//        return range.count
//    }
//
//    var body: some View {
//        VStack {
//            HStack {
//
//                Text("Year:")
//                Picker("Year", selection: $selectedYear) {
//                    ForEach(2000...2030, id: \.self) { year in
//                        Text("\(year)").tag(year)
//                    }
//                }
//
//                Text("Month:")
//                Picker("Month", selection: $selectedMonth) {
//                    ForEach(1...12, id: \.self) { month in
//                        Text("\(month)").tag(month)
//                    }
//                }
//            }
//            ScrollView {
//                ForEach(0..<30, id: \.self) { day in
//                    // Use the properties of the Day object
//                    Text("\(self.days[day].date)")
//                    Picker(selection: self.$days[day].option, label: Text("")) {
//                        ForEach(Option.allCases, id: \.self) { option in
//                            Text(option.rawValue)
//                        }
//                    }
//                    TextField("Notes", text: self.$days[day].notes)
//                }
//            }
//            Button(action: generatePDF) {
//                Text("Generate PDF")
//            }
//        }
//        .sheet(isPresented: $showShareLink) {
//            ActivityView(activityItems: [fileURL as Any], applicationActivities: nil)
//        }
//    }

//-------------------------------------------
    
//    func generatePDF() {
//        let pdfData = createPDFData()
//        if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//            let fileName = "\(selectedMonth)_\(selectedYear)_chart.pdf"
//            let fileURL = directory.appendingPathComponent(fileName)
//            do {
//                try pdfData.write(to: fileURL)
//                print("Successfully saved PDF to: \(fileURL)")
//            } catch {
//                print("Error saving PDF: \(error.localizedDescription)")
//            }
//        }
//    }
    
//    func createPDFData() -> Data {
//        let pdfMetaData = [
//            kCGPDFContextCreator: "ChartView",
//            kCGPDFContextAuthor: "Your Name",
//            kCGPDFContextTitle: "\(selectedMonth) / \(selectedYear) Chart"
//        ]
//        let format = UIGraphicsPDFRendererFormat()
//        format.documentInfo = pdfMetaData as [String: Any]
//
//        let pageWidth = 8.5 * 72.0
//        let pageHeight = 11 * 72.0
//        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
//
//        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
//        let data = renderer.pdfData { (context) in
//            context.beginPage()
//
//            // ... add your code here to render the ChartView's contents to the PDF context ...
//
//        }
//        return data
//    }
//
//    func generatePDF() {
//        let pdfData = createPDFData()
//        if let directory = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first {
//            let fileName = "\(selectedMonth)_\(selectedYear)_chart.pdf"
//            fileURL = directory.appendingPathComponent(fileName)
//            do {
//                try pdfData.write(to: fileURL!)
//                print("Successfully saved PDF to: \(fileURL!)")
//                self.showShareLink.toggle()
//            } catch {
//                print("Error saving PDF: \(error.localizedDescription)")
//            }
//        }
//    }
//
//    func createPDFData() -> Data {
//        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 612, height: 792))
//
//        let pdfData = pdfRenderer.pdfData { (context) in
//            let contentView = ContentView()
//            let hostingController = UIHostingController(rootView: contentView)
//            hostingController.view.frame = CGRect(x: 0, y: 0, width: 612, height: 792)
//            context.cgContext.translateBy(x: 0, y: 792)
//            context.cgContext.scaleBy(x: 1, y: -1)
//            hostingController.view.layer.render(in: context.cgContext)
//        }
//        return pdfData
//    }
//}

//import SwiftUI
//
//struct ActivityView: UIViewControllerRepresentable {
//
//    var activityItems: [Any]
//    var applicationActivities: [UIActivity]?
//
//    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
//        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
//        return controller
//    }
//
//    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityView>) {}
//}
//
//import UIKit
//
//class PDFRendererView: UIView {
//    func render(_ chartView: ChartView, year: String, month: String, days: [String], to url: URL) {
//        // Create a PDF context with the desired size and file URL
//        let pdfContext = CGContext(url as CFURL, mediaBox: nil, nil)
//
//        // Get the current graphics context
//        UIGraphicsPushContext(pdfContext!)
//
//        // Render the ChartView's contents to the PDF context
////        chartView.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
//
//        // Add the year, month and each day to the PDF
//        let textFont = UIFont.systemFont(ofSize: 12)
//        let textColor = UIColor.black
//        let textAttributes = [NSAttributedString.Key.font: textFont, NSAttributedString.Key.foregroundColor: textColor]
//
//        let textRect = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.bounds.width, height: 20)
//        let textContent = "Year: \(year) Month: \(month)"
//        textContent.draw(in: textRect, withAttributes: textAttributes)
//
//        var currentY = textRect.origin.y + textRect.height
//        let dayHeight: CGFloat = 20
//        for (index, day) in days.enumerated() {
//            let dayRect = CGRect(x: self.bounds.origin.x, y: currentY, width: self.bounds.width, height: dayHeight)
//            let dayContent = "Day \(index + 1): \(day)"
//            dayContent.draw(in: dayRect, withAttributes: textAttributes)
//            currentY += dayHeight
//        }
//
//        // Clean up the graphics context
//        UIGraphicsPopContext()
//
//        // Close the PDF context
//        pdfContext?.closePDF()
//    }
//}

public extension View {
    var asImage: UIImage {
        // Must ignore safe area due to a bug in iOS 15+ https://stackoverflow.com/a/69819567/1011161
        let controller = UIHostingController(rootView: self.edgesIgnoringSafeArea(.top))
        let view = controller.view
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: CGPoint(x: 0, y: 0), size: targetSize)
        view?.backgroundColor = .clear

        let format = UIGraphicsImageRendererFormat()
        format.scale = 3 // Ensures 3x-scale images. You can customise this however you like.
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

// MARK: - Experimentations

extension MKPointAnnotation {
    static var example: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = "London"
        annotation.subtitle = "Home to the 2012 Summer Olympics."
        annotation.coordinate = CLLocationCoordinate2D(latitude: 51.5, longitude: -0.13)
        return annotation
    }
}

struct MapView: UIViewRepresentable {
    
    @Binding var centerCoordinate: CLLocationCoordinate2D
    
    var annotations: [MKPointAnnotation]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.showsTraffic = true
        mapView.showsBuildings = true
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        if annotations.count != view.annotations.count {
            view.removeAnnotations(view.annotations)
            view.addAnnotations(annotations)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
        }
    }
}


/*
 ZStack {
 ForEach(0..<3) { index in
 Image(systemName: "bus")
 .font(.system(size: 100))
 .zIndex(Double(2 - index))
 .offset(x: 10.0*CGFloat(index), y: -10.0*CGFloat(index))
 .opacity(1.0/(1.0 + Double(index)))
 .brightness(-1.0 + 1/(1 + Double(index)))
 
 }
 }
 */

/*
 import Charts
 import SwiftUI
 
 struct SalesSummary: Identifiable {
 let weekday: Date
 let sales: Int
 var id: Date { weekday }
 }
 let cupertinoData: [SalesSummary] = [
 // Monday
 .init (weekday: date(2022, 5, 2), sales: 54),
 /// Tuesday
 .init (weekday: date(2022, 5, 3), sales: 42),
 /// Wednesday
 .init (weekday: date (2022, 5, 4), sales: 88),
 /// Thursday
 .init (weekday: date(2022, 5, 5), sales: 49),
 /// Friday
 .init (weekday: date (2022, 5, 6), sales: 42),
 /// Saturday
 .init (weekday: date (2022, 5, 7), sales: 125),
 /// Sunday
 .init(weekday: date (2022, 5, 8), sales: 67)
 ]
 
 struct Series: Identifiable {
 let city: String
 let sales: [SalesSummary]
 var id: String { city }
 }
 
 let seriesData: [Series] = [
 .init(city: "Cupertino", sales: cupertinoData)
 .init(city: "San Francisco", sales: sfData),
 ]
 
 struct LocationsDetailsChart: View {
 var body: some View {
 Chart(seriesData) { series in
 ForEach(series.sales) { element in
 LineMark(
 X: .value ("Day", element.weekday, unit: .day),
 y: .value("Sales", element.sales)
 )
 .foregroundStyle(by: .value("City", .symbol(by: •value("City", series.city))))
 
 }
 }
 }
 }
 */

//import TensorFlowLiteSwift
//import SwiftUI
//import AVFoundation
//
//struct ImageClassifier: View {
//    @State private var image: UIImage?
//    @State private var classifier = ImageClassifier()
//    @State private var isLoading = false
//    @State private var results: [String] = []
//
//    var body: some View {
//        VStack {
//            if image != nil {
//                Image(uiImage: image!)
//                    .resizable()
//                    .scaledToFit()
//            } else {
//                Button(action: {
//                    self.isLoading = true
//                    self.classifier.classifyImage(image: self.image!) { results in
//                        self.results = results
//                        self.isLoading = false
//                    }
//                }) {
//                    Text("Classify Image")
//                }
//            }
//            if isLoading {
//                Text("Loading...")
//            } else {
//                List(results, id: \.self) { result in
//                    Text(result)
//                }
//            }
//        }
//    }
//}
//
//class ImageClassifier {
//    private let model = ImageClassifier()
//
//    func classifyImage(image: UIImage, completion: @escaping ([String]) -> Void) {
//        // Preprocess image
//        let inputTensor = image.tensor
//        // Run inference
//        let outputTensor = try! model.inference(inputs: [inputTensor])
//        // Postprocess output
//        let results = postprocess(outputTensor)
//        completion(results)
//    }
//
//    private func postprocess(_ outputTensor: Tensor) -> [String] {
//        // Convert output tensor to array of classification scores
//        let scores = outputTensor.data.map { Double($0) }
//        // Find index of highest scoring class
//        let maxScoreIndex = scores.argmax()
//        // Look up class label for index
//        let classLabel = labels[maxScoreIndex]
//        return [classLabel]
//    }
//}


/*
 
 Note that you will need to replace "YourCoreMLModel" with the name of your Core ML model.
 Also you will need to import the Camera module from a third party library to use CameraView if you don't have one you can use UIImagePickerController from UIKit.
 
 */
//import SwiftUI
//import CoreML
//import Vision
//
//struct ImageClassificationView: View {
//    @State private var image: UIImage?
//    @State private var classifications = [String]()
//
//    private let model: VNCoreMLModel = TortillaPackage()
//
//    var body: some View {
//        VStack {
//            // Use a camera view to capture an image
//            CameraView(source: )
//                .frame(height: 300)
//
//            // Display the classifications
//            List(classifications, id: \.self) { classification in
//                Text(classification)
//            }
//
//            .onChange(of: image) { newValue in
//                // Classify the image when it changes
//                if let image = image {
//                    classify(image: image)
//                }
//            }
//        }
//    }
//
//    private func classify(image: UIImage) {
//
//        // Convert the UIImage to a CIImage
//        let ciImage = CIImage(image: image)!
//
//        // Create a Core ML request
//        let request = VNCoreMLRequest(model: model) { request, error in
//            guard let results = request.results as? [VNClassificationObservation],
//                let topResult = results.first else {
//                    self.classifications = []
//                    return
//            }
//
//            // Update the classifications array with the top classification
//            self.classifications = [topResult.identifier]
//        }
//
//        // Perform the request on the CIImage
//        let handler = VNImageRequestHandler(ciImage: ciImage)
//        try? handler.perform([request])
//    }
//}


//import SwiftUI
//import AVFoundation
//import CoreML
//import Vision
//
//struct LiveCameraClassificationView: View, AVCaptureVideoDataOutputSampleBufferDelegate {
//    @State private var classifications = [String]()
//    private let model = TortillaPackage()
//    private let session = AVCaptureSession()
//    @State private var previewLayer: AVCaptureVideoPreviewLayer?
//    private let videoOutput = AVCaptureVideoDataOutput()
//    private let queue = DispatchQueue(label: "videoQueue")
//    private var lastBuffer: CMSampleBuffer?
//    private var isShowingAlert = false
//
//    var body: some View {
//        ZStack {
//            // Use a camera view to capture an image
//            CameraPreviewView(session: session, previewLayer: $previewLayer)
//                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//            // Display the classifications
//            List(classifications, id: \.self) { classification in
//                Text(classification)
//            }
//        }
//        .onAppear(perform: startCamera)
//        .onDisappear(perform: stopCamera)
//    }
//
//    private func startCamera() {
//        // Request camera access
//        AVCaptureDevice.requestAccess(for: .video) { success in
//            guard success else { return }
//
//            // Set the session preset
//            self.session.sessionPreset = .high
//
//            // Set up the camera input
//            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
//            let input = try! AVCaptureDeviceInput(device: device)
//            self.session.addInput(input)
//
//            // Set up the video output
//            self.videoOutput.setSampleBufferDelegate(self, queue: self.queue)
//            self.videoOutput.alwaysDiscardsLateVideoFrames = true
//            self.session.addOutput(self.videoOutput)
//
//            // Set up the preview layer
//            self.previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
//            self.previewLayer?.frame = UIScreen.main.bounds
//            self.previewLayer?.videoGravity = .resizeAspectFill
//
//            // Start running the session
//            self.session.startRunning()
//        }
//    }
//
//    private func stopCamera() {
//        session.stopRunning()
//    }
//
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        // Only classify the buffer if it's different from the last buffer
//        guard lastBuffer != sampleBuffer else { return }
//        lastBuffer = sampleBuffer
//
//        // Get the pixel buffer from the sample buffer
//        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
//
//        // Create a Core ML request
//        let request = VNCoreMLRequest(model: TortillaPackage()) { request, error in
//            guard let results = request.results as? [VNClassificationObservation],
//                  let topResult = results.first else {
//                self.classifications = []
//                return
//            }
//        }
//    }
//}

//import SwiftUI
//import AVFoundation
//
//struct LiveCameraView: View {
//    @State private var isCameraAuthorized: Bool = false
//    private let session = AVCaptureSession()
//    private var previewLayer: AVCaptureVideoPreviewLayer?
//
//    var body: some View {
//        ZStack {
//            if self.isCameraAuthorized {
//                CameraPreviewView(session: session, previewLayer: $previewLayer)
//                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//            } else {
//                Text("Camera not authorized.")
//                    .foregroundColor(.red)
//                    .padding()
//            }
//        }
//        .onAppear(perform: checkAuthorization)
//    }
//
//    private func checkAuthorization() {
//        switch AVCaptureDevice.authorizationStatus(for: .video) {
//        case .authorized:
//            self.isCameraAuthorized = true
//            startSession()
//        case .notDetermined:
//            AVCaptureDevice.requestAccess(for: .video) { granted in
//                if granted {
//                    self.isCameraAuthorized = true
//                    DispatchQueue.main.async {
//                        self.startSession()
//                    }
//                }
//            }
//        case .denied:
//            self.isCameraAuthorized = false
//            print("User denied camera access.")
//        case .restricted:
//            self.isCameraAuthorized = false
//            print("Camera access restricted.")
//        @unknown default:
//            fatalError()
//        }
//    }
//
//    private func startSession() {
//        // Set the session preset
//        self.session.sessionPreset = .high
//
//        // Set up the camera input
//        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
//        let input = try! AVCaptureDeviceInput(device: device)
//        self.session.addInput(input)
//
//        // Set up the video output
//        let output = AVCaptureVideoDataOutput()
//        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
//        output.alwaysDiscardsLateVideoFrames = true
//        self.session.addOutput(output)
//
//        // Start the session
//        self.session.startRunning()
//    }
//}

//import SwiftUI
//import AVFoundation
//
//struct LiveCameraView: View {
//    @State private var isCameraAuthorized: Bool = false
//    private let session = AVCaptureSession()
//    @State private var previewLayer: AVCaptureVideoPreviewLayer?
//
//    var body: some View {
//        ZStack {
//            if self.isCameraAuthorized {
//                CameraPreviewView(session: session, previewLayer: $previewLayer)
//                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//            } else {
//                Text("Camera not authorized.")
//                    .foregroundColor(.red)
//                    .padding()
//            }
//        }
//        .onAppear(perform: checkAuthorization)
//    }
//
//    private func checkAuthorization() {
//        switch AVCaptureDevice.authorizationStatus(for: .video) {
//        case .authorized:
//            self.isCameraAuthorized = true
//            startSession()
//        case .notDetermined:
//            AVCaptureDevice.requestAccess(for: .video) { granted in
//                if granted {
//                    self.isCameraAuthorized = true
//                    DispatchQueue.main.async {
//                        self.startSession()
//                    }
//                }
//            }
//        case .denied:
//            self.isCameraAuthorized = false
//            print("User denied camera access.")
//        case .restricted:
//            self.isCameraAuthorized = false
//            print("Camera access restricted.")
//        @unknown default:
//            fatalError()
//        }
//    }
//
//    private func startSession() {
//        // Set the session preset
//        self.session.sessionPreset = .high
//
//        // Set up the camera input
//        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
//        let input = try! AVCaptureDeviceInput(device: device)
//        self.session.addInput(input)
//
//        // Set up the preview layer
//        previewLayer = AVCaptureVideoPreviewLayer(session: session)
//        previewLayer?.videoGravity = .resizeAspectFill
//        previewLayer?.frame = UIScreen.main.bounds
//
//        // Start the session
//        DispatchQueue.global(qos: .background).async {
//            self.session.startRunning()
//        }
//
//    }
//}

//struct CameraPreviewView: UIViewRepresentable {
//    let session: AVCaptureSession
//    @Binding var previewLayer: AVCaptureVideoPreviewLayer?
//
//    func makeUIView(context: Context) -> UIView {
//
//        let view = UIView(frame: .zero)
//
//        if let previewLayer = previewLayer {
//
//            view.layer.addSublayer(previewLayer)
//            return view
//
//        } else {
//            return view
//        }
//    }
//
//    func updateUIView(_ uiView: UIView, context: Context) {
//        previewLayer?.frame = uiView.bounds
//    }
//}
//
//
//import SwiftUI
//import AVFoundation
//import CoreML
//
//struct LiveCameraView: View {
//    @State private var isCameraAuthorized: Bool = false
//    @State private var currentPrediction: String = "..."
//    private let session = AVCaptureSession()
//    @State private var previewLayer: AVCaptureVideoPreviewLayer?
//    private let model = TortillaPackage()
//
//    var body: some View {
//        ZStack {
//            if self.isCameraAuthorized {
//                CameraPreviewView(session: session, previewLayer: $previewLayer)
//                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//                Text(currentPrediction)
//                    .padding()
//            } else {
//                Text("Camera not authorized.")
//                    .foregroundColor(.red)
//                    .padding()
//            }
//        }
//        .onAppear(perform: checkAuthorization)
//    }
//
//    private func checkAuthorization() {
//        switch AVCaptureDevice.authorizationStatus(for: .video) {
//        case .authorized:
//            self.isCameraAuthorized = true
//            startSession()
//        case .notDetermined:
//            AVCaptureDevice.requestAccess(for: .video) { granted in
//                if granted {
//                    self.isCameraAuthorized = true
//                    DispatchQueue.main.async {
//                        self.startSession()
//                    }
//                }
//            }
//        case .denied:
//            self.isCameraAuthorized = false
//            print("User denied camera access.")
//        case .restricted:
//            self.isCameraAuthorized = false
//            print("Camera access restricted.")
//        @unknown default:
//            fatalError()
//        }
//    }
//
//    private func startSession() {
//        // Set the session preset
//        self.session.sessionPreset = .high
//
//        // Set up the camera input
//        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
//        let input = try! AVCaptureDeviceInput(device: device)
//        self.session.addInput(input)
//
//        // Set up the video output
//        let output = AVCaptureVideoDataOutput()
//        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
//        self.session.addOutput(output)
//
//        // Set up the preview layer
//        previewLayer = AVCaptureVideoPreviewLayer(session: session)
//        previewLayer?.videoGravity = .resizeAspectFill
//        previewLayer?.frame = UIScreen.main.bounds
//
//        // Start the session
//        self.session.startRunning()
//    }
//}
//
//import UIKit
//import AVFoundation
//
//typealias ImageBufferHandler = ((_ imageBuffer: CMSampleBuffer) -> ())
//
//final class PreviewView: UIView ,AVCaptureVideoDataOutputSampleBufferDelegate{
//    private var captureSession: AVCaptureSession?
//    var imageBufferHandler: ImageBufferHandler?
//    private var videoConnection: AVCaptureConnection!
//
//    init() {
//        super.init(frame: .zero)
//
//        var allowedAccess = false
//        let blocker = DispatchGroup()
//        blocker.enter()
//        AVCaptureDevice.requestAccess(for: .video) { flag in
//            allowedAccess = flag
//            blocker.leave()
//        }
//        blocker.wait()
//
//        if !allowedAccess {
//            print("!!! NO ACCESS TO CAMERA")
//            return
//        }
//
//        // setup session
//        let session = AVCaptureSession()
//        session.beginConfiguration()
//
//        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
//                                                  for: .video, position: .unspecified) //alternate AVCaptureDevice.default(for: .video)
//        guard videoDevice != nil, let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!), session.canAddInput(videoDeviceInput) else {
//            print("!!! NO CAMERA DETECTED")
//            return
//        }
//        session.addInput(videoDeviceInput)
//        session.commitConfiguration()
//        self.captureSession = session
//
//        // setup video output
//        let videoDataOutput = AVCaptureVideoDataOutput()
//        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
//
//        videoDataOutput.alwaysDiscardsLateVideoFrames = true
//        let queue = DispatchQueue(label: "com.queue.videosamplequeue")
//        videoDataOutput.setSampleBufferDelegate(self, queue: queue)
//        guard captureSession!.canAddOutput(videoDataOutput) else {
//            fatalError()
//        }
//        captureSession!.addOutput(videoDataOutput)
//
//        videoConnection = videoDataOutput.connection(with: .video)
//
//    }
//
//    override class var layerClass: AnyClass {
//        AVCaptureVideoPreviewLayer.self
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
//        return layer as! AVCaptureVideoPreviewLayer
//    }
//
//    override func didMoveToSuperview() {
//        super.didMoveToSuperview()
//
//        if nil != self.superview {
//            self.videoPreviewLayer.session = self.captureSession
//            self.videoPreviewLayer.videoGravity = .resize
//            self.captureSession?.startRunning()
//
//        }
//        else {
//            self.captureSession?.stopRunning()
//        }
//    }
//
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        print("Got a frame!")
//
//        if connection.videoOrientation != .portrait {
//            connection.videoOrientation = .portrait
//            return
//        }
//
//        if let imageBufferHandler = imageBufferHandler
//        {
//            imageBufferHandler(sampleBuffer)
//        }
//    }
//}
//
//class CameraViewModel: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
//    var currentPrediction: String = "..."
//    private let model = TortillaPackage()
//
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
//
//        do {
////            let input = TortillaPackageInput(input_1: pixelBuffer)
//
//            let prediction = try model.prediction(input: pixelBuffer)
//            DispatchQueue.main.async {
//                self.currentPrediction = prediction.classLabel
//            }
//        } catch {
//            print(error)
//        }
//    }
//}

//enum DayOption: String, CaseIterable {
//    case none = "None"
//    case caregiverInitial = "Caregiver Initial"
//    case patientDeclined = "D - Patient Declined/Spit Up Medication"
//    case medicationDiscontinued = "D/C - Medication Discontinued by DR Order"
//    case patientHospital = "H - Patient Taken to Hospital"
//    case outOfFacility = "Out of Facility"
//}

//struct ChartView: View {
//    @State private var selectedOptions = [Int: DayOption]()
//    @State private var notes = [String](repeating: "", count: 30)
//    var body: some View {
//        ScrollView {
//            VStack {
//                ForEach(0..<30, id: \.self) { day in
//                    VStack {
//                        HStack {
//                            Text("Day \(day + 1)")
//                            Picker("Options", selection: self.$selectedOptions[day]) {
//                                ForEach(DayOption.allCases, id: \.self) { option in
//                                    Text(option.rawValue).tag(option)
//                                }
//                            }
//                            .pickerStyle(SegmentedPickerStyle())
//                        }
//                        TextField("Notes", text: self.$notes[day])
//                    }
//                }
//            }
//        }
//    }
//}

//struct ChartView: View {
//    @State private var selectedYear = 2020
//    @State private var selectedMonth = 1
//    @State private var selectedOptions = [Int: DayOption]()
//    @State private var notes = [String](repeating: "", count: 31)
//
//    var body: some View {
//        ScrollView {
//            VStack {
//                HStack {
//                    Text("Year:")
//                    Picker("Year", selection: $selectedYear) {
//                        ForEach(2020...2030, id: \.self) {
//                            Text("\($0)")
//                        }
//                    }
//                    .pickerStyle(WheelPickerStyle())
//                }
//
//                HStack {
//                    Text("Month:")
//                    Picker("Month", selection: $selectedMonth) {
//                        ForEach(1...12, id: \.self) {
//                            Text("\($0)")
//                        }
//                    }
//                    .pickerStyle(WheelPickerStyle())
//                }
//                ForEach(1...daysInMonth(year: selectedYear, month: selectedMonth), id: \.self) { day in
//                    VStack {
//                        HStack {
//                            Text("Day \(day)")
//                            Picker("Options", selection: self.$selectedOptions[day-1]) {
//                                ForEach(DayOption.allCases, id: \.self) { option in
//                                    Text(option.rawValue).tag(option)
//                                }
//                            }
//                            .pickerStyle(SegmentedPickerStyle())
//                        }
//                        TextField("Notes", text: self.$notes[day-1])
//                    }
//                }
//                Button(action: {
//                    self.generatePDF()
//                }, label: {
//                    Text("Generate PDF")
//                })
//            }
//        }
//    }
//    func daysInMonth(year: Int, month: Int) -> Int {
//        let dateComponents = DateComponents(year: year, month: month)
//        let calendar = Calendar.current
//        let date = calendar.date(from: dateComponents)!
//        let range = calendar.range(of: .day, in: .month, for: date)!
//        return range.count
//    }
//    func generatePDF() {
//        // Code to generate PDF
//    }
//}

//struct ChartView: View {
//    @State private var selectedOptions = [DayOption](repeating: .none, count: 30)
//    @State private var notes = [String](repeating: "", count: 30)
//
//    var body: some View {
//        ScrollView {
//            VStack {
//                ForEach(0 ..< 30) { day in
//                    VStack {
//                        HStack {
//                            Text("Day \(day + 1)")
//                            Picker("Options", selection: self.$selectedOptions[day]) {
//                                ForEach(DayOption.allCases, id: \.self) { option in
//                                    Text(option.rawValue.capitalized).tag(option)
//                                }
//                            }
//                            .pickerStyle(SegmentedPickerStyle())
//                        }
//                        TextField("Notes", text: self.$notes[day])
//                    }
//                }
//            }
//        }
//        .padding()
//    }
//}

//struct ChartView: View {
//    @State private var selectedOptions = [Int: DayOption]()
//    @State private var notes = [Int: String]()
//    @State private var currentYear = Calendar.current.component(.year, from: Date())
//
//    var body: some View {
//        ScrollView {
//            VStack {
//                ForEach(1...31, id: \.self) { day in
//                    VStack {
//                        HStack {
//                            Text("\(day) \(self.currentYear)")
//                            Picker("Options", selection: self.$selectedOptions[day]) {
//                                ForEach(DayOption.allCases, id: \.self) { option in
//                                    Text(option.rawValue).tag(option)
//                                }
//                            }
//                            .pickerStyle(SegmentedPickerStyle())
//                        }
//                        TextField("Notes", text: self.$notes[day], onEditingChanged: { (changed) in
//                            if changed {
//                                self.notes[day] = ""
//                            }
//                        })
//                    }
//                }
//            }
//        }
//    }
//}

//struct ChartView: View {
//    @State private var selectedOptions = [Int: DayOption]()
//    @State private var currentYear = Calendar.current.component(.year, from: Date())
//
//    var body: some View {
//        ScrollView {
//            VStack {
//                ForEach(1...31, id: \.self) { day in
//                    HStack {
//                        Text("\(day) \(self.currentYear)")
//                        Picker("Options", selection: self.$selectedOptions[day]) {
//                            ForEach(DayOption.allCases, id: \.self) { option in
//                                Text(option.rawValue).tag(option)
//                            }
//                        }
//                        .pickerStyle(SegmentedPickerStyle())
//                    }
//                }
//            }
//        }
//    }
//}

import SwiftUI

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
//                    Rectangle()
//                        .fill(Color.black)
//                        .frame(width: 2, height: geometry.size.width / 4)
//
//                    Rectangle()
//                        .fill(Color.black)
//                        .frame(width: geometry.size.width / 4, height: 2)
//
//                    HandView(angle: angleFromTime(currentTime), width: 2, height: geometry.size.width / 2 - 80, color: .blue)
//                        .offset(y: -geometry.size.width / 4)
//                        .rotationEffect(Angle(degrees: Double(Calendar.current.component(.second, from: currentTime) * 6)))
//
//                    HandView(angle: hourAngleFromTime(currentTime), width: 8, height: 80, color: .orange)
//                        .frame(width: 8, height: geometry.size.width / 2)
//                        .offset(y: -geometry.size.width / 4)
//                }
//            }
//        }
//        .onAppear {
//            let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//                currentTime = Date()
//            }
//            timer.tolerance = 0.1
//        }
//    }
//
//    func angleFromTime(_ time: Date) -> Angle {
//        let calendar = Calendar.current
//        let second = calendar.component(.second, from: time)
//        return Angle(degrees: Double(second) * 6)
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
//}
//

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
//struct HandView: View {
//    let angle: Angle
//    let width: CGFloat
//    let height: CGFloat
//    let color: Color
//
//    var body: some View {
//        Rectangle()
//            .fill(color)
//            .frame(width: width, height: height)
//            .rotationEffect(angle)
//    }
//}
//
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
//                    HandView(angle: angleFromTime(currentTime), width: 2, height: geometry.size.width / 2 - 80, color: .orange)
//                        .offset(y: -geometry.size.width / 4)
//                        .rotationEffect(hourAngleFromTime(currentTime))
//
//                    HandView(angle: angleFromTime(currentTime), width: 2, height: geometry.size.width / 2 - 100, color: .blue)
//                        .offset(y: -geometry.size.width / 4)
//                        .rotationEffect(secondAngleFromTime(currentTime))
//                        .offset(y: -geometry.size.width / 4)
//                }
//                .frame(width: geometry.size.width, height: geometry.size.height)
//            }
//        }
//        .onAppear {
//            let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//                currentTime = Date()
//            }
//            timer.tolerance = 0.1
//        }
//    }
//
//    func angleFromTime(_ time: Date) -> Angle {
//        let calendar = Calendar.current
//        let second = calendar.component(.second, from: time)
//        return Angle(degrees: Double(second) * 6)
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
//                ClockView(width: geometry.size.width, height: geometry.size.height, currentTime: $currentTime)
//            }
//        }
//        .onAppear {
//            let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//                currentTime = Date()
//            }
//            timer.tolerance = 0.1
//        }
//    }
//}
//
//struct ClockView: View {
//    let width: CGFloat
//    let height: CGFloat
//    @Binding var currentTime: Date
//
//    var body: some View {
//        ZStack {
//            Circle()
//                .fill(Color.white)
//                .shadow(radius: 10)
//
//            TickMarksView(width: width, height: height)
//
//            HourHandView(angle: hourAngleFromTime(currentTime), width: 8, height: height / 2 - 80, color: .orange)
//
//            SecondHandView(angle: secondAngleFromTime(currentTime), width: 2, height: height / 2 - 100, color: .blue)
//        }
//        .frame(width: width, height: height)
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
//    func secondAngleFromTime(_ time: Date) -> Angle {
//        let calendar = Calendar.current
//        let second = calendar.component(.second, from: time)
//        return Angle(degrees: Double(second) * 6)
//    }
//}
//
//struct TickMarksView: View {
//    let width: CGFloat
//    let height: CGFloat
//
//    var body: some View {
//        ForEach(1...12, id: \.self) { index in
//            let tickSize = index % 3 == 0 ? 12 : 6
//            let tickWidth: CGFloat = 2
//            let tickHeight = height / 2 - tickWidth - 24
//            let tickAngle = Double(index) * 30.0
//            let tickColor = index % 3 == 0 ? Color.orange : Color.black
//            TickView(size: CGFloat(tickSize), width: tickWidth, height: tickHeight, color: tickColor)
//                .offset(y: -tickHeight / 2)
//                .rotationEffect(Angle(degrees: tickAngle))
//        }
//        .rotationEffect(Angle(degrees: -90))
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
//            .frame(width: width, height: height)
//            .rotationEffect(angle)
//            .offset(y: -height / 2)
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
//        Rectangle()
//            .fill(color)
//            .frame(width: width, height: height)
//            .rotationEffect(angle)
//            .offset(y: -height / 2)
//
//        Circle()
//            .fill(color)
//            .frame(width: width, height: width)
//            .offset(y: -height)
//    }
//}
//
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
//                ClockView(width: geometry.size.width, height: geometry.size.height, currentTime: $currentTime)
//            }
//        }
//        .onAppear {
//            let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//                currentTime = Date()
//            }
//            timer.tolerance = 0.1
//        }
//    }
//}
//
//struct ClockView: View {
//    let width: CGFloat
//    let height: CGFloat
//    @Binding var currentTime: Date
//
//    var body: some View {
//        ZStack {
//            Circle()
//                .fill(Color.white)
//                .shadow(radius: 10)
//
//            TickMarksView(width: width, height: height)
//
//            HourHandView(angle: hourAngleFromTime(currentTime), width: 8, height: height / 2 - 80, color: .orange)
//                .rotationEffect(hourAngleFromTime(currentTime), anchor: .center)
//                .offset(y: -height / 4)
//
//            SecondHandView(angle: secondAngleFromTime(currentTime), width: 2, height: height / 2 - 100, color: .blue)
//                .rotationEffect(secondAngleFromTime(currentTime), anchor: .center)
//                .offset(y: -height / 4)
//        }
//        .frame(width: width, height: height)
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
//    func secondAngleFromTime(_ time: Date) -> Angle {
//        let calendar = Calendar.current
//        let second = calendar.component(.second, from: time)
//        return Angle(degrees: Double(second) * 6)
//    }
//}
//
//
//struct TickMarksView: View {
//    let width: CGFloat
//    let height: CGFloat
//
//    var body: some View {
//        ForEach(1...12, id: \.self) { index in
//            let tickSize = index % 3 == 0 ? 12 : 6
//            let tickWidth: CGFloat = 2
//            let tickHeight = height / 2 - tickWidth - 24
//            let tickAngle = Double(index) * 30.0
//            let tickColor = index % 3 == 0 ? Color.orange : Color.black
//            TickView(size: CGFloat(tickSize), width: tickWidth, height: tickHeight, color: tickColor)
//                .offset(y: -tickHeight / 2)
//                .rotationEffect(Angle(degrees: tickAngle))
//        }
//        .rotationEffect(Angle(degrees: -90))
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
//            .frame(width: width, height: height)
//            .rotationEffect(angle)
//            .offset(y: -height / 2)
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
//                .rotationEffect(angle)
//                .offset(y: -height / 2)
//        }
//    }
//}
//
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
//                        .offset(y: -geometry.size.width / 4)
//
//                    SecondHandView(angle: secondAngleFromTime(currentTime), width: 2, height: geometry.size.width / 2 - 100, color: .blue)
//                        .rotationEffect(secondAngleFromTime(currentTime), anchor: .center)
//                        .offset(y: -geometry.size.width / 4)
//                }
//                .frame(width: geometry.size.width, height: geometry.size.height)
//            }
//        }
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
//    func secondAngleFromTime(_ time: Date) -> Angle {
//        let calendar = Calendar.current
//        let second = calendar.component(.second, from: time)
//        return Angle(degrees: Double(second) * 6)
//    }
//}
//
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
//            .frame(width: width, height: height)
//            .rotationEffect(angle)
//            .offset(y: -height / 2)
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

import SwiftUI

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
//
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

//struct SevenSegmentClock: View {
//    let digitWidth: CGFloat = 10
//    let digitHeight: CGFloat = 20
//
//    @State private var currentTime = Date()
//
//    var body: some View {
//        VStack {
//            Text("Seven Segment Clock")
//                .font(.title)
//                .padding()
//
//            HStack {
//                ForEach(0..<2) { i in
//                    VStack {
//                        SegmentView(isOn: [true, true, true, false, true, true, true], width: digitWidth, height: digitHeight)
//                        SegmentView(isOn: [false, false, true, false, false, true, false], width: digitWidth, height: digitHeight)
//                    }
//                    .padding(.trailing, 10)
//                }
//
//                VStack {
//                    SegmentView(isOn: [true, true, true, false, true, true, true], width: digitWidth, height: digitHeight)
//                    SegmentView(isOn: [false, false, true, false, false, true, false], width: digitWidth, height: digitHeight)
//                }
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
//}
//
//struct SegmentView: View {
//    let isOn: [Bool]
//    let width: CGFloat
//    let height: CGFloat
//
//    var body: some View {
//        VStack {
//            Rectangle()
//                .fill(isOn[0] ? Color.red : Color.gray)
//                .frame(width: width, height: height)
//                .cornerRadius(width / 2)
//            HStack {
//                Rectangle()
//                    .fill(isOn[5] ? Color.red : Color.gray)
//                    .frame(width: width / 2, height: height)
//                    .cornerRadius(width / 2)
//                Rectangle()
//                    .fill(isOn[1] ? Color.red : Color.gray)
//                    .frame(width: width / 2, height: height)
//                    .cornerRadius(width / 2)
//            }
//            Rectangle()
//                .fill(isOn[6] ? Color.red : Color.gray)
//                .frame(width: width, height: height)
//                .cornerRadius(width / 2)
//            HStack {
//                Rectangle()
//                    .fill(isOn[4] ? Color.red : Color.gray)
//                    .frame(width: width / 2, height: height)
//                    .cornerRadius(width / 2)
//                Rectangle()
//                    .fill(isOn[2] ? Color.red : Color.gray)
//                    .frame(width: width / 2, height: height)
//                    .cornerRadius(width / 2)
//            }
//            Rectangle()
//                .fill(isOn[3] ? Color.red : Color.gray)
//                .frame(width: width, height: height)
//                .cornerRadius(width / 2)
//        }
//    }
//}


//struct SevenSegmentClock: View {
//    @State private var currentTime = Date()
//
//    var body: some View {
//        VStack {
//            Text("Seven Segment Clock")
//                .font(.title)
//                .padding()
//
//            HStack {
//                DigitView(digit: hourDigitFromTime(currentTime, segmentIndex: 0))
//                DigitView(digit: hourDigitFromTime(currentTime, segmentIndex: 1))
//                DigitSeparatorView()
//                DigitView(digit: minuteDigitFromTime(currentTime, segmentIndex: 0))
//                DigitView(digit: minuteDigitFromTime(currentTime, segmentIndex: 1))
//                DigitSeparatorView()
//                DigitView(digit: secondDigitFromTime(currentTime, segmentIndex: 0))
//                DigitView(digit: secondDigitFromTime(currentTime, segmentIndex: 1))
//            }
//            .padding(.horizontal, 20)
//
//        }
//        .padding(.top, 40)
//        .onAppear {
//            let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//                currentTime = Date()
//            }
//            timer.tolerance = 0.1
//        }
//    }
//
//    func hourDigitFromTime(_ time: Date, segmentIndex: Int) -> Int {
//        let calendar = Calendar.current
//        let hour = calendar.component(.hour, from: time)
//        if segmentIndex == 0 {
//            return hour / 10
//        } else {
//            return hour % 10
//        }
//    }
//
//    func minuteDigitFromTime(_ time: Date, segmentIndex: Int) -> Int {
//        let calendar = Calendar.current
//        let minute = calendar.component(.minute, from: time)
//        if segmentIndex == 0 {
//            return minute / 10
//        } else {
//            return minute % 10
//        }
//    }
//
//    func secondDigitFromTime(_ time: Date, segmentIndex: Int) -> Int {
//        let calendar = Calendar.current
//        let second = calendar.component(.second, from: time)
//        if segmentIndex == 0 {
//            return second / 10
//        } else {
//            return second % 10
//        }
//    }
//}
//
//struct DigitView: View {
//    let digit: Int
//
//    var body: some View {
//        VStack(spacing: 10) {
//            SegmentView(isOn: segmentsForDigit(digit: digit)[0])
//                .rotationEffect(.degrees(90))
//            HStack(spacing: 10) {
//                SegmentView(isOn: segmentsForDigit(digit: digit)[5])
//                    .rotationEffect(.degrees(-90))
//                Spacer()
//                Spacer()
//                SegmentView(isOn: segmentsForDigit(digit: digit)[1])
//                    .rotationEffect(.degrees(-90))
//            }
//            SegmentView(isOn: segmentsForDigit(digit: digit)[6])
//                .rotationEffect(.degrees(90))
//            HStack(spacing: 10) {
//                SegmentView(isOn: segmentsForDigit(digit: digit)[4])
//                    .rotationEffect(.degrees(-90))
//                Spacer()
//                Spacer()
//                SegmentView(isOn: segmentsForDigit(digit: digit)[2])
//                    .rotationEffect(.degrees(-90))
//            }
//            SegmentView(isOn: segmentsForDigit(digit: digit)[3])
//                .rotationEffect(.degrees(90))
//        }
//    }
//
//    func segmentsForDigit(_ digit: Int) -> [Bool] {
//        switch digit {
//        case 0:
//            return [true, true, true, false, true, true, true]
//        case 1:
//            return [false, false, true, false, false, true, false]
//        case 2:
//            return [true, false, true, true, true, false, true]
//        case 3:
//            return [true, false, true, true, false, true, true]
//        case 4:
//            return [false, true, true, true, false, true, false]
//        case 5:
//            return [true, true, false, true, false, true, true]
//        case 6:
//            return [true, true, false, true, true, true, true]
//        case 7:
//            return [true, false, true, false, false, true, false]
//        case 8:
//            return [true, true, true, true, true, true, true]
//        case 9:
//            return [true, true, true, true, false, true, true]
//        default:
//            return []
//        }
//    }
//
//}
//
//struct DigitSeparatorView: View {
//    var body: some View {
//        VStack {
//            Rectangle()
//                .frame(width: 2, height: 14)
//                .cornerRadius(2)
//            Spacer()
//                .frame(height: 10)
//            Rectangle()
//                .frame(width: 2, height: 14)
//                .cornerRadius(2)
//        }
//    }
//}
//
//struct SegmentView: View {
//    var isOn: Bool
//
//    var body: some View {
//        RoundedRectangle(cornerRadius: 3)
//            .fill(isOn ? Color.red : Color.gray)
//            .frame(width: 20, height: 60)
//            .rotationEffect(isOn ? Angle(degrees: 90) : Angle(degrees: 0))
//    }
//}

//struct SevenSegmentClock: View {
//    @State private var currentTime = Date()
//    let segmentWidth: CGFloat = 20
//    let segmentHeight: CGFloat = 50
//
//    var body: some View {
//        HStack(spacing: 0) {
//            DigitView(digit: hourDigitFromTime(currentTime, segmentIndex: 0), segmentWidth: segmentWidth, segmentHeight: segmentHeight)
//            DigitView(digit: hourDigitFromTime(currentTime, segmentIndex: 1), segmentWidth: segmentWidth, segmentHeight: segmentHeight)
//            DigitSeparatorView(height: segmentHeight)
//            DigitView(digit: minuteDigitFromTime(currentTime, segmentIndex: 0), segmentWidth: segmentWidth, segmentHeight: segmentHeight)
//            DigitView(digit: minuteDigitFromTime(currentTime, segmentIndex: 1), segmentWidth: segmentWidth, segmentHeight: segmentHeight)
//            DigitSeparatorView(height: segmentHeight)
//            DigitView(digit: secondDigitFromTime(currentTime, segmentIndex: 0), segmentWidth: segmentWidth, segmentHeight: segmentHeight)
//            DigitView(digit: secondDigitFromTime(currentTime, segmentIndex: 1), segmentWidth: segmentWidth, segmentHeight: segmentHeight)
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
//    func hourDigitFromTime(_ time: Date, segmentIndex: Int) -> Int {
//        let calendar = Calendar.current
//        let hour = calendar.component(.hour, from: time)
//        if segmentIndex == 0 {
//            return hour / 10
//        } else {
//            return hour % 10
//        }
//    }
//
//    func minuteDigitFromTime(_ time: Date, segmentIndex: Int) -> Int {
//        let calendar = Calendar.current
//        let minute = calendar.component(.minute, from: time)
//        if segmentIndex == 0 {
//            return minute / 10
//        } else {
//            return minute % 10
//        }
//    }
//
//    func secondDigitFromTime(_ time: Date, segmentIndex: Int) -> Int {
//        let calendar = Calendar.current
//        let second = calendar.component(.second, from: time)
//        if segmentIndex == 0 {
//            return second / 10
//        } else {
//            return second % 10
//        }
//    }
//}


//struct DigitView: View {
//    var number: Int
//
//    private let segments: [[Bool]] = [        [true, true, true, true, true, true, false],
//        [false, true, true, false, false, false, false],
//        [true, true, false, true, true, false, true],
//        [true, true, true, true, false, false, true],
//        [false, true, true, false, false, true, true],
//        [true, false, true, true, false, true, true],
//        [true, false, true, true, true, true, true],
//        [true, true, true, false, false, false, false],
//        [true, true, true, true, true, true, true],
//        [true, true, true, true, false, true, true]
//    ]
//
//    var body: some View {
//        VStack(spacing: 4) {
//            SegmentView(isOn: segments[number][0])
//                .rotationEffect(.degrees(90))
//                .frame(maxWidth: .infinity)
//            HStack(spacing: 4) {
//                SegmentView(isOn: segments[number][1])
//                    .rotationEffect(.degrees(180))
//                SegmentView(isOn: segments[number][2])
//                    .rotationEffect(.degrees(180))
//            }
//            SegmentView(isOn: segments[number][3])
//                .rotationEffect(.degrees(90))
//                .frame(maxWidth: .infinity)
//            HStack(spacing: 4) {
//                SegmentView(isOn: segments[number][4])
//                    .rotationEffect(.degrees(180))
//                SegmentView(isOn: segments[number][5])
//                    .rotationEffect(.degrees(180))
//            }
//            SegmentView(isOn: segments[number][6])
//                .rotationEffect(.degrees(90))
//                .frame(maxWidth: .infinity)
//        }
//        .frame(width: 60)
//    }
//}

//struct DigitView: View {
//    let digit: Int
//    let segmentWidth: CGFloat
//    let segmentHeight: CGFloat
//
//    private let segmentSpacing: CGFloat = 5
//
//    var body: some View {
//        HStack(spacing: 0) {
//            SegmentView(isOn: segmentsForDigit(digit: digit, segmentIndex: 0), width: segmentWidth, height: segmentHeight)
//                .frame(width: segmentWidth, height: segmentHeight)
//            VStack(spacing: segmentSpacing) {
//                SegmentView(isOn: segmentsForDigit(digit: digit, segmentIndex: 1), width: segmentWidth, height: segmentHeight)
//                    .frame(width: segmentWidth, height: segmentHeight)
//                SegmentView(isOn: segmentsForDigit(digit: digit, segmentIndex: 2), width: segmentWidth, height: segmentHeight)
//                    .frame(width: segmentWidth, height: segmentHeight)
//            }
//            .frame(width: segmentWidth, height: segmentHeight * 2 + segmentSpacing)
//            SegmentView(isOn: segmentsForDigit(digit: digit, segmentIndex: 3), width: segmentWidth, height: segmentHeight)
//                .frame(width: segmentWidth, height: segmentHeight)
//            VStack(spacing: segmentSpacing) {
//                SegmentView(isOn: segmentsForDigit(digit: digit, segmentIndex: 4), width: segmentWidth, height: segmentHeight)
//                    .frame(width: segmentWidth, height: segmentHeight)
//                SegmentView(isOn: segmentsForDigit(digit: digit, segmentIndex: 5), width: segmentWidth, height: segmentHeight)
//                    .frame(width: segmentWidth, height: segmentHeight)
//            }
//            .frame(width: segmentWidth, height: segmentHeight * 2 + segmentSpacing)
//            SegmentView(isOn: segmentsForDigit(digit: digit, segmentIndex: 6), width: segmentWidth, height: segmentHeight)
//                .frame(width: segmentWidth, height: segmentHeight)
//        }
//    }
//
//    func segmentsForDigit(digit: Int, segmentIndex: Int) -> [Bool] {
//        switch digit {
//        case 0:
//            return [true, true, true, false, true, true, true]
//        case 1:
//            return [false, false, true, false, false, true, false]
//        case 2:
//            return [true, false, true, true, true, false, true]
//        case 3:
//            return [true, false, true, true, false, true, true]
//        case 4:
//            return [false, true, true, true, false, true, false]
//        case 5:
//            return [true, true, false, true, false, true, true]
//        case 6:
//            return [true, true, false, true, true, true, true]
//        case 7:
//            return [true, false, true, false, false, true, false]
//        case 8:
//            return [true, true, true, true, true, true, true]
//        case 9:
//            return [true, true, true, true, false, true, true]
//        default:
//            return [false, false, false, false, false, false, false]
//        }
//    }
//}

//struct DigitView: View {
//    let digit: Int
//    let segmentWidth: CGFloat
//    let segmentHeight: CGFloat
//
//    private let segmentsForDigits = [
//        [true, true, true, false, true, true, true], // 0
//        [false, false, true, false, false, true, false], // 1
//        [true, false, true, true, true, false, true], // 2
//        [true, false, true, true, false, true, true], // 3
//        [false, true, true, true, false, true, false], // 4
//        [true, true, false, true, false, true, true], // 5
//        [true, true, false, true, true, true, true], // 6
//        [true, false, true, false, false, true, false], // 7
//        [true, true, true, true, true, true, true], // 8
//        [true, true, true, true, false, true, true]  // 9
//    ]
//
//    var body: some View {
//        HStack(spacing: 0) {
//            ForEach(0..<7) { index in
//                if index == 0 || index == 3 || index == 6 {
//                    DigitSeparatorView(height: segmentHeight)
//                }
//                SegmentView(isOn: segmentsForDigits[digit][index], width: segmentWidth, height: segmentHeight, color: .red)
//            }
//        }
//    }
//}
//
//struct SegmentView: View {
//    let isOn: Bool
//    let width: CGFloat
//    let height: CGFloat
//    let color: Color
//
//    var body: some View {
//        Rectangle()
//            .fill(isOn ? color : .gray)
//            .frame(width: width, height: height)
//            .cornerRadius(4)
//    }
//}
//
//struct DigitSeparatorView: View {
//    let height: CGFloat
//
//    var body: some View {
//        Rectangle()
//            .fill(Color.gray)
//            .frame(width: 2, height: height)
//    }
//}




//struct SegmentView: View {
//    var isOn: Bool
//
//    var body: some View {
//        GeometryReader { geometry in
//            Path { path in
//                let width = geometry.size.width
//                let height = geometry.size.height
//                let x = geometry.size.width / 2
//                let y = geometry.size.height / 2
//
//                path.move(to: CGPoint(x: x - width/2 + 10, y: y - height/2))
//                path.addLine(to: CGPoint(x: x + width/2 - 10, y: y - height/2))
//                path.addLine(to: CGPoint(x: x + width/2, y: y - height/2 + 10))
//                path.addLine(to: CGPoint(x: x + width/2, y: y + height/2 - 10))
//                path.addLine(to: CGPoint(x: x + width/2 - 10, y: y + height/2))
//                path.addLine(to: CGPoint(x: x - width/2 + 10, y: y + height/2))
//                path.addLine(to: CGPoint(x: x - width/2, y: y + height/2 - 10))
//                path.addLine(to: CGPoint(x: x - width/2, y: y - height/2 + 10))
//
//                path.closeSubpath()
//            }
//            .fill(isOn ? Color.red : Color.gray)
//        }
//        .aspectRatio(1, contentMode: .fit)
//    }
//}

//struct SegmentView: View {
//    var isOn: Bool
//    var width: CGFloat
//    var height: CGFloat
//    var color: Color
//
//    var body: some View {
//        GeometryReader { geometry in
//            let path = Path { path in
//                path.move(to: CGPoint(x: width / 2, y: 0))
//                path.addLine(to: CGPoint(x: width, y: height / 2))
//                path.addLine(to: CGPoint(x: width, y: height / 2 + geometry.size.height - height))
//                path.addLine(to: CGPoint(x: width / 2, y: geometry.size.height))
//                path.addLine(to: CGPoint(x: 0, y: height / 2 + geometry.size.height - height))
//                path.addLine(to: CGPoint(x: 0, y: height / 2))
//                path.addLine(to: CGPoint(x: width / 2, y: 0))
//            }
//            .offset(x: (geometry.size.width - width) / 2)
//
//            Rectangle()
//                .fill(isOn ? color : .clear)
//                .frame(width: width, height: height)
//                .mask(path.fill(style: FillStyle(eoFill: true)))
//        }
//    }
//}

//struct SegmentView: View {
//    let isOn: [Bool]
//    let width: CGFloat
//    let height: CGFloat
//    let color: Color
//
//    var body: some View {
//        VStack(spacing: 0) {
//            Rectangle()
//                .fill(isOn[0] ? color : .gray)
//                .frame(width: width, height: height / 6)
//            HStack(spacing: 0) {
//                Rectangle()
//                    .fill(isOn[1] ? color : .gray)
//                    .frame(width: width / 6, height: height / 3)
//                Spacer()
//                Rectangle()
//                    .fill(isOn[2] ? color : .gray)
//                    .frame(width: width / 6, height: height / 3)
//            }
//            Rectangle()
//                .fill(isOn[3] ? color : .gray)
//                .frame(width: width, height: height / 6)
//            HStack(spacing: 0) {
//                Rectangle()
//                    .fill(isOn[4] ? color : .gray)
//                    .frame(width: width / 6, height: height / 3)
//                Spacer()
//                Rectangle()
//                    .fill(isOn[5] ? color : .gray)
//                    .frame(width: width / 6, height: height / 3)
//            }
//            Rectangle()
//                .fill(isOn[6] ? color : .gray)
//                .frame(width: width, height: height / 6)
//        }
//    }
//
//    init(isOn: [Bool], width: CGFloat, height: CGFloat, color: Color = .red) {
//        self.isOn = isOn
//        self.width = width
//        self.height = height
//        self.color = color
//    }
//}
//
//
//
//struct DigitSeparatorView: View {
//    var body: some View {
//        Rectangle()
//            .fill(Color.white)
//            .frame(width: 4, height: 16)
//    }
//}


//struct SevenSegmentClock: View {
//    @State private var currentTime = Date()
//
//    var body: some View {
//        VStack {
//            Text("Seven Segment Clock")
//                .font(.title)
//                .padding()
//
//            GeometryReader { geometry in
//                let segmentWidth = geometry.size.width / 12
//                let segmentHeight = geometry.size.height / 6
//
//                HStack {
//                    DigitView(digit: hourDigitFromTime(currentTime, segmentIndex: 0), segmentWidth: segmentWidth, segmentHeight: segmentHeight)
//                    DigitView(digit: hourDigitFromTime(currentTime, segmentIndex: 1), segmentWidth: segmentWidth, segmentHeight: segmentHeight)
//                    DigitSeparatorView(height: segmentHeight)
//                    DigitView(digit: minuteDigitFromTime(currentTime, segmentIndex: 0), segmentWidth: segmentWidth, segmentHeight: segmentHeight)
//                    DigitView(digit: minuteDigitFromTime(currentTime, segmentIndex: 1), segmentWidth: segmentWidth, segmentHeight: segmentHeight)
//                    DigitSeparatorView(height: segmentHeight)
//                    DigitView(digit: secondDigitFromTime(currentTime, segmentIndex: 0), segmentWidth: segmentWidth, segmentHeight: segmentHeight)
//                    DigitView(digit: secondDigitFromTime(currentTime, segmentIndex: 1), segmentWidth: segmentWidth, segmentHeight: segmentHeight)
//                }
//                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
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
//    func hourDigitFromTime(_ time: Date, segmentIndex: Int) -> Int {
//        let calendar = Calendar.current
//        let hour = calendar.component(.hour, from: time)
//        return segmentIndex == 0 ? hour / 10 : hour % 10
//    }
//
//    func minuteDigitFromTime(_ time: Date, segmentIndex: Int) -> Int {
//        let calendar = Calendar.current
//        let minute = calendar.component(.minute, from: time)
//        return segmentIndex == 0 ? minute / 10 : minute % 10
//    }
//
//    func secondDigitFromTime(_ time: Date, segmentIndex: Int) -> Int {
//        let calendar = Calendar.current
//        let second = calendar.component(.second, from: time)
//        return segmentIndex == 0 ? second / 10 : second % 10
//    }
//}
//
//struct DigitView: View {
//    let digit: Int
//    let segmentWidth: CGFloat
//    let segmentHeight: CGFloat
//
//    private let segmentsForDigits = [
//        [true, true, true, false, true, true, true], // 0
//        [false, false, true, false, false, true, false], // 1
//        [true, false, true, true, true, false, true], // 2
//        [true, false, true, true, false, true, true], // 3
//        [false, true, true, true, false, true, false], // 4
//        [true, true, false, true, false, true, true], // 5
//        [true, true, false, true, true, true, true], // 6
//        [true, false, true, false, false, true, false], // 7
//        [true, true, true, true, true, true, true], // 8
//        [true, true, true, true, false, true, true]  // 9
//    ]
//
//    var body: some View {
//        HStack(spacing: 0) {
//            ForEach(0..<7) { index in
//                if index == 0 || index == 3 || index == 6 {
//                    DigitSeparatorView(height: segmentHeight)
//                }
//                SegmentView(isOn: segmentsForDigits[digit][index], width: segmentWidth, height: segmentHeight, color: .red)
//            }
//        }
//    }
//}
//
//struct SegmentView: View {
//    let isOn: Bool
//    let width: CGFloat
//    let height: CGFloat
//    let color: Color
//
//    var body: some View {
//        Rectangle()
//            .fill(isOn ? color : .gray)
//            .frame(width: width, height: height)
//            .cornerRadius(4)
//    }
//}
//
//struct DigitSeparatorView: View {
//    let height: CGFloat
//
//    var body: some View {
//        Rectangle()
//            .fill(Color.gray)
//            .frame(width: 2, height: height)
//    }
//}

struct SegmentView: View {
    let isOn: Bool
    let width: CGFloat
    let height: CGFloat
    let color: Color
    
    var body: some View {
        Rectangle()
            .fill(isOn ? color : .gray)
            .frame(width: width, height: height)
            .cornerRadius(4)
    }
}

struct DigitSeparatorView: View {
    let height: CGFloat
    
    var body: some View {
        Rectangle()
            .fill(Color.gray)
            .frame(width: 2, height: height)
    }
}

struct DigitView: View {
    let digit: Int
    let segmentWidth: CGFloat
    let segmentHeight: CGFloat
    
    private let segmentsForDigits = [
        [true, true, true, false, true, true, true], // 0
        [false, false, true, false, false, true, false], // 1
        [true, false, true, true, true, false, true], // 2
        [true, false, true, true, false, true, true], // 3
        [false, true, true, true, false, true, false], // 4
        [true, true, false, true, false, true, true], // 5
        [true, true, false, true, true, true, true], // 6
        [true, false, true, false, false, true, false], // 7
        [true, true, true, true, true, true, true], // 8
        [true, true, true, true, false, true, true]  // 9
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<7) { index in
                if index == 0 || index == 3 || index == 6 {
                    DigitSeparatorView(height: segmentHeight)
                }
                SegmentView(isOn: segmentsForDigits[digit][index], width: segmentWidth, height: segmentHeight, color: .red)
            }
        }
    }
}

struct SevenSegmentClock: View {
    @State private var currentTime = Date()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        let segmentWidth = UIScreen.main.bounds.width / 16
        let segmentHeight = UIScreen.main.bounds.height / 8
        
        VStack {
            HStack {
                DigitView(digit: hourDigitFromTime(currentTime, segmentIndex: 0), segmentWidth: segmentWidth, segmentHeight: segmentHeight)
                DigitView(digit: hourDigitFromTime(currentTime, segmentIndex: 1), segmentWidth: segmentWidth, segmentHeight: segmentHeight)
            }
            HStack {
                DigitView(digit: minuteDigitFromTime(currentTime, segmentIndex: 0), segmentWidth: segmentWidth, segmentHeight: segmentHeight)
                DigitView(digit: minuteDigitFromTime(currentTime, segmentIndex: 1), segmentWidth: segmentWidth, segmentHeight: segmentHeight)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .onReceive(timer) { input in
            self.currentTime = input
        }
    }
    
    func hourDigitFromTime(_ time: Date, segmentIndex: Int) -> Int {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: time)
        let digitString = String(hour / 10) + String(hour % 10)
        return Int(String(digitString[digitString.index(digitString.startIndex, offsetBy: segmentIndex)]))!
    }
    
    func minuteDigitFromTime(_ time: Date, segmentIndex: Int) -> Int {
        let calendar = Calendar.current
        let minute = calendar.component(.minute, from: time)
        let digitString = String(minute / 10) + String(minute % 10)
        return Int(String(digitString[digitString.index(digitString.startIndex, offsetBy: segmentIndex)]))!
    }
}
