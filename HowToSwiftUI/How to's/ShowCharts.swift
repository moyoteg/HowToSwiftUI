//
//  ShowCharts.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 7/2/22.
//

import SwiftUI
import SwiftUICharts

struct ShowCharts: View {
    // using
    let data: [Double] = [-69, -70, -71, -71, -70, -70, -70, -69, -66]
    /// *********

    var body: some View {
        ScrollView {
            
            Divider()
            
            MultiLineChartView(data: [
                (data, GradientColors.green),
                ([90,99,78,111,70,60,77], GradientColors.purple),
                ([34,56,72,38,43,100,50], GradientColors.orngPink),
            ], title: "BLE RSSI")
            
            LineChartView(data: [8,23,54,32,12,37,7,23,43], title: "Title", legend: "Legendary") // legend is optional

            BarChartView(data: ChartData(values: [("2018 Q4",63150), ("2019 Q1",50900), ("2019 Q2",77550), ("2019 Q3",79600), ("2019 Q4",92550)]), title: "Sales", legend: "Quarterly") // legend is optional

            BarChartView(data: ChartData(points: [8,23,54,32,12,37,7,23,43]), title: "Title", legend: "Legendary") // legend is optional

            BarChartView(data: ChartData(points: [8,23,54,32,12,37,7,23,43]), title: "Title", form: ChartForm.small)

            BarChartView(data: ChartData(points:[1.23,2.43,3.37]) ,title: "A", valueSpecifier: "%.2f")

            let chartStyle = ChartStyle(
                backgroundColor: Color.black,
                accentColor: Colors.OrangeStart,
                secondGradientColor: Colors.OrangeEnd,
                textColor: Color.white,
                legendTextColor: Color.white,
                dropShadowColor: .gray )
            
            BarChartView(data: ChartData(points: [8,23,54,32,12,37,7,23,43]), title: "Title", style: chartStyle)
        }
    }
}

struct ShowCharts_Previews: PreviewProvider {
    static var previews: some View {
        ShowCharts()
    }
}
