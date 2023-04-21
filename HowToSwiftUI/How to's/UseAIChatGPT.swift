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
            let responseText = json["choices"] as! [[String: Any]]
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

//struct Color {
//    var hex: String
//    var red: Double {
//        return Double((Int(hex, radix: 16)! >> 16) & 0xFF) / 255
//    }
//    var green: Double {
//        return Double((Int(hex, radix: 16)! >> 8) & 0xFF) / 255
//    }
//    var blue: Double {
//        return Double((Int(hex, radix: 16)!) & 0xFF) / 255
//    }
//    var color: Color {
//        return Color(hex: hex)
//    }
//}

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

//this code will create a stepper that will allow you to go from 0.0 to 1.0 and the value will be displayed in the text view.
// you can change the range from 0.0 to 1.0 to any other range that you need.
// the stepper value will be rounded to 2 decimal places only.


/*
import SwiftUI

struct ChatThread: View {
    
    @State var newMessage: String
    
    @State private var messages = [
        Message(content: "Hey, how's it going?", sender: "John"),
        Message(content: "Not too bad, how about you?", sender: "Jane"),
        Message(content: "I'm good, thanks for asking. What's up?", sender: "John"),
        Message(content: "Just wanted to catch up and see how things are going.", sender: "Jane"),
        Message(content: "Things are going well, thanks for asking. How about you?", sender: "John"),
        Message(content: "I'm good too, thanks. Let's catch up again soon.", sender: "Jane")
    ]
    
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
                            .background(Color.gray)
                            .cornerRadius(10)
                    }
                }
            }
            HStack {
                TextField("Enter message", text: $newMessage)
                Button(action: {
                    self.messages.append(Message(content: self.newMessage, sender: "Me"))
                    self.newMessage = ""
                }) {
                    Text("Send")
                }
            }
            .padding()
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

struct ChatThread_Previews: PreviewProvider {
    static var previews: some View {
        ChatThread(newMessage: "hellow world")
    }
}
*/
// -------------

