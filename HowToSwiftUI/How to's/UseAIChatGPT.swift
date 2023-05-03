//
//  UseAIChatGPT.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 1/17/23.
//

import SwiftUI

import SwiftUIComponents

struct UseAIChatGPT: View {
    var body: some View {
        
        ZStack {
            
            AnimatedGradientView()
            
            VStack {
                
                ChatThread()
                
            }
            
        }
        
    }
}

struct UseAIChatGPT_Previews: PreviewProvider {
    static var previews: some View {
        UseAIChatGPT()
    }
}

import SwiftUI
import Foundation

struct ChatThread: View {
    @State private var messages = [Message]()
    @State private var newMessage = ""
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var apiKey = "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"
    //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
    //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

    @State var CHATGPTtemperature = 0.0

var body: some View {

    Stepper("temperature \(CHATGPTtemperature, specifier: "%.1f")", value: $CHATGPTtemperature, in: 0.0...1.0, step: 0.1)
        .padding()
        .shadow(radius: 5)

//    Divider()

    TextField("Enter Chat GPT apiKey", text: $apiKey)
        .padding()
        .minimumScaleFactor(0.3)
//        .lineLimit(3)
        .shadow(radius: 5)
        .clearButton(text: $apiKey)

//    Divider()

    VStack {
        List {
            ForEach(messages) { message in
                HStack {
                    Text(message.sender)
                        .font(.caption)
                    Spacer()
                    Text(message.content)
                        .padding(.all, 10)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
        }

        HStack {
            TextField("Enter message", text: $newMessage)
                .clearButton(text: $newMessage)
                .minimumScaleFactor(0.3)
                .lineLimit(3)

            Button(action: {
                self.sendMessage()
            }) {
                Text("Send")
            }
        }
        .padding()
        .shadow(radius: 5)

    }
    .alert(isPresented: $showAlert) {
        Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
    }
}

func sendMessage() {
    if newMessage == "" {
        self.alertTitle = "Error"
        self.alertMessage = "Please enter a message to send."
        self.showAlert = true
        return
    }

    let message = Message(content: newMessage, sender: "Me")
    messages.append(message)
    newMessage = ""

    // Send message to chatgpt API
    let parameters:[String : Any] = [
        "prompt": message.content,
        "temperature": CHATGPTtemperature,
    ]
    let headers = ["Content-Type": "application/json", "Authorization": "Bearer \(apiKey)"]
    let request = NSMutableURLRequest(url: NSURL(string: "https://api.openai.com/v1/engines/davinci/completions")! as URL,
                                            cachePolicy: .useProtocolCachePolicy,
                                        timeoutInterval: 10.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])

    let session = URLSession.shared
    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            self.alertTitle = "Error"
            self.alertMessage = error!.localizedDescription
            self.showAlert = true
        } else {
            let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
            print(json)
            guard let responseText = json["choices"] as? [[String: Any]] else {
                self.messages.append(Message(content: "\(json)", sender: "API"))
                return
            }
            let responseMessage = responseText[0]["text"] as! String
            let responseSender = "API"
            self.messages.append(Message(content: responseMessage, sender: responseSender))
        }
    })

    dataTask.resume()
}
}

struct Message: Identifiable {
    var id: Int {
        var hasher = Hasher()
            hasher.combine(content)
            hasher.combine(sender)
        return hasher.finalize()
    }

    var content: String
    var sender: String
}

struct ChatThread_Previews: PreviewProvider {
    static var previews: some View {
        ChatThread()
    }
}

import SwiftUI

struct AnimatedGradientView: View {
    
    @State private var currentGradient = 0
    
    let gradients = [
        ["#F8FBFF", "#D9E2EC"],
        ["#F8D1CC", "#F8B1A3"],
        ["#F8B195", "#F67280"],
        ["#F9D423", "#F8B1CC"]
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient:
                    Gradient(
                        colors:
                            [
                                Color(hex: gradients[currentGradient][0]),
                                Color(hex: gradients[currentGradient][1]),
                            ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
        }
        .animation(Animation.default.speed(2).repeatForever(autoreverses: false), value: 0.3)
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
                self.currentGradient += 1
                if self.currentGradient == self.gradients.count {
                    self.currentGradient = 0
                }
            }
        }
    }
}

struct AnimatedGradientView_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedGradientView()
    }
}

// this code will show an animated gradient that will change every 2 sec.
// you can change the time interval to make it as you want also you can change the gradient colors or add more colors to the gradients array.

import SwiftUI

struct TemperatureStepper: View {
    @Binding var temperature: Double
    
    var body: some View {
        Stepper("temperature \(temperature, specifier: "%.1f")", value: $temperature, in: 0.0...1.0, step: 0.1)
    }
}

struct StepperView_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureStepper(temperature: .constant(0.5))
    }
}

/*
struct ChatThread: View {
    @State private var messages = [Message]()
    @State private var newMessage = ""
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var apiKey = "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"
    @State private var temperature = 0.0

    var body: some View {
        VStack {
            List {
                ForEach(messages) { message in
                    HStack {
                        Text(message.sender)
                            .font(.caption)
                        Spacer()
                        Text(message.content)
                            .padding(.all, 10)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
            }

            HStack {
                TextField("Enter message", text: $newMessage)
                    .clearButton(text: $newMessage)
                    .minimumScaleFactor(0.3)
                    .lineLimit(3)

                Button(action: {
                    self.sendMessage()
                }) {
                    Text("Send")
                }
            }
            .padding()
            .shadow(radius: 5)

            Stepper("Temperature \(temperature, specifier: "%.1f")", value: $temperature, in: 0.0...1.0, step: 0.1)
                .padding()
                .shadow(radius: 5)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    func sendMessage() {
        Task {
            if newMessage == "" {
                self.alertTitle = "Error"
                self.alertMessage = "Please enter a message to send."
                self.showAlert = true
                return
            }

            let message = Message(content: newMessage, sender: "Me")
            messages.append(message)
            newMessage = ""

            // Send message to chatgpt API
            let parameters:[String : Any] = [
                "prompt": message.content,
                "temperature": temperature,
            ]
            let headers = ["Content-Type": "application/json", "Authorization": "Bearer \(apiKey)"]
            let request = NSMutableURLRequest(url: NSURL(string: "https://api.openai.com/v1/engines/davinci/completions")! as URL,
                                                    cachePolicy: .useProtocolCachePolicy,
                                                timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])

            do {
                let (data, response) = try await URLSession.shared.data(for: request as URLRequest)
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    print(json)
                    guard let responseText = json["choices"] as? [[String: Any]] else {
                        self.messages.append(Message(content: "\(json)", sender: "API"))
                        return
                    }
                    let responseMessage = responseText[0]["text"] as! String
                    let responseSender = "API"
                    self.messages.append(Message(content: responseMessage, sender: responseSender))
                } else {
                    print(response)
                    self.alertTitle = "Error"
                    self.alertMessage = "Unexpected response from server."
                    self.showAlert = true
                }
            } catch {
                self.alertTitle = "Error"
                self.alertMessage = error.localizedDescription
                self.showAlert = true
            }
        }
    }


}

struct Message: Identifiable {
    var id: Int {
        var hasher = Hasher()
        hasher.combine(content)
        hasher.combine(sender)
        return hasher.finalize()
    }

    var content: String
    var sender: String
}

struct CompletionRequest: Codable {
    let prompt: String
    let max_tokens: Int
    let temperature: Double
    let n: Int
    let stop: [String]
    let model: String

    init(prompt: String, temperature: Double, apiKey: String) {
        self.prompt = prompt
        self.temperature = temperature
        self.max_tokens = 50
        self.n = 1
        self.stop = ["\n"]
        self.model = "davinci"
    }
}

struct CompletionResponse: Codable {
    let choices: [Choice]
}

struct Choice: Codable {
    var text: String
    var index: Int?
    var logprobs: Logprobs?
    var finishReason: String?
    var selectedTokens: [Int]?
    var context: String?
    var prompt: String?
    
    enum CodingKeys: String, CodingKey {
        case text
        case index
        case logprobs
        case finishReason = "finish_reason"
        case selectedTokens = "selected_tokens"
        case context
        case prompt
    }
}

struct Logprobs: Codable {
    var tokens: [[String: Double]]
    var textOffset: [Int]
    var tokenOffset: [Int]
    var topLogprobs: [String: Double]
    
    enum CodingKeys: String, CodingKey {
        case tokens
        case textOffset = "text_offset"
        case tokenOffset = "token_offset"
        case topLogprobs = "top_logprobs"
    }
}

// Color Extension
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        if scanner.scanHexInt64(&rgbValue) {
            let r = Double((rgbValue & 0xff0000) >> 16) / 255.0
            let g = Double((rgbValue & 0xff00) >> 8) / 255.0
            let b = Double(rgbValue & 0xff) / 255.0
            self.init(red: r, green: g, blue: b)
            return
        }
        self.init(red: 0, green: 0, blue: 0)
    }
}
*/
