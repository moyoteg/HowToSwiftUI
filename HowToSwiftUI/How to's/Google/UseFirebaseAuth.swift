//
//  UseFirebaseAuth.swift
//  HowToSwiftUI
//
//  Created by Moi Gutierrez on 5/10/23.
//

import SwiftUI
import Foundation

import CloudyLogs
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

struct UseFirebaseAuth: View {
    
    var body: some View {
        
        NavigationStack {
            TabView {
                
                Authentication()
                    .tabItem {
                        Label("Firebase Auth", systemImage: "flame.fill")
                    }
                    .tag(0)
                
                LoginView()
                    .environmentObject(AuthenticationViewModel())
                    .tabItem {
                        Label("Google Sign-In", systemImage: "magnifyingglass")
                    }
                    .tag(1)
            }
        }
    }
}

public struct Authentication: View {
    
    @State var email = "test@test.com"
    @State var password = "123456"
    @State var showAlert = false
    @State var alertTitle = ""
    @State var alertMessage = ""
    
    @StateObject var viewModel = AuthenticationViewModel()
    
    public var body: some View {
        
        VStack {
            
            TextField("Email", text: $email)
            
            SecureField("Password", text: $password)
            
            Button(action: {
                login()
            }) {
                Text("Sign in")
            }
            
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                alertTitle = "Error"
                alertMessage = error.localizedDescription
                showAlert = true
            } else {
                alertTitle = "Success"
                alertMessage = "You have successfully logged in."
                showAlert = true
            }
        }
    }
}

import SwiftUI
import Combine
import FirebaseAnalyticsSwift

private enum FocusableField: Hashable {
    case email
    case password
}

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var focus: FocusableField?
    
    private func signInWithEmailPassword() {
        Task {
            if await viewModel.signInWithEmailPassword() == true {
                viewModel.authenticationState = .authenticated
                dismiss()
            }
        }
    }
    
    private func signInWithGoogle() {
        Task {
            if await viewModel.signInWithGoogle() == true {
                dismiss()
            }
        }
    }
    
    var body: some View {
        Form {
            Image(systemName: "flame.fill")
            
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Image(systemName: "at")
                TextField("Email", text: $viewModel.email)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .focused($focus, equals: .email)
                    .submitLabel(.next)
                    .onSubmit {
                        self.focus = .password
                    }
            }
            .padding(.vertical, 6)
            .background(Divider(), alignment: .bottom)
            .padding(.bottom, 4)
            
            HStack {
                Image(systemName: "lock")
                SecureField("Password", text: $viewModel.password)
                    .focused($focus, equals: .password)
                    .submitLabel(.go)
                    .onSubmit {
                        signInWithEmailPassword()
                    }
            }
            .padding(.vertical, 6)
            .background(Divider(), alignment: .bottom)
            .padding(.bottom, 8)
            
            if !viewModel.errorMessage.isEmpty {
                VStack {
                    Text(viewModel.errorMessage)
                        .foregroundColor(Color(UIColor.systemRed))
                }
            }
            
            Button(action: signInWithEmailPassword) {
                if viewModel.authenticationState != .authenticating {
                    Text("Login")
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                }
                else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                }
            }
            .disabled(!viewModel.isValid)
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)
            
            HStack {
                VStack { Divider() }
                Text("or")
                VStack { Divider() }
            }
            
            Button(action: signInWithGoogle) {
                Text("Sign in with Google")
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(alignment: .leading) {
                        Image("Google")
                            .resizable()
                            .frame(width: 30, height: 30, alignment: .center)
                    }
            }
            .foregroundColor(colorScheme == .dark ? .white : .black)
            .buttonStyle(.bordered)
            
            HStack {
                Text("Don't have an account yet?")
                Button(action: { viewModel.switchFlow() }) {
                    Text("Sign up")
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
            }
            .padding([.top, .bottom], 50)
            
        }
        .listStyle(.plain)
        .padding()
        .analyticsScreen(name: "\(Self.self)")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView()
            LoginView()
                .preferredColorScheme(.dark)
        }
        .environmentObject(AuthenticationViewModel())
    }
}

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

enum AuthenticationFlow {
    case login
    case signUp
}

@MainActor
class AuthenticationViewModel: ObservableObject {

    @Published var email: String = "test@test.com"
    @Published var password: String = "123456"
    @Published var confirmPassword: String = ""
    
    @Published var flow: AuthenticationFlow = .login
    
    @Published var isValid: Bool  = false
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var errorMessage: String = ""
    @Published var user: User?
    @Published var displayName: String = ""
    
    init() {
        registerAuthStateHandler()
        
        $flow
            .combineLatest($email, $password, $confirmPassword)
            .map { flow, email, password, confirmPassword in
                flow == .login
                ? !(email.isEmpty || password.isEmpty)
                : !(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
            }
            .assign(to: &$isValid)
    }
    
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
                self.user = user
                self.authenticationState = user == nil ? .unauthenticated : .authenticated
                self.displayName = user?.email ?? ""
            }
        }
    }
    
    func switchFlow() {
        flow = flow == .login ? .signUp : .login
        errorMessage = ""
    }
    
    private func wait() async {
        do {
            Logger.log("Wait")
            try await Task.sleep(nanoseconds: 1_000_000_000)
            Logger.log("Done")
        }
        catch { }
    }
    
    func reset() {
        flow = .login
        email = ""
        password = ""
        confirmPassword = ""
    }
}

extension AuthenticationViewModel {
    func signInWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        do {
            try await Auth.auth().signIn(withEmail: self.email, password: self.password)
            Logger.log("success")
            return true
        }
        catch  {
            Logger.log(error.localizedDescription)
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
    }
    
    func signUpWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        do  {
            try await Auth.auth().createUser(withEmail: email, password: password)
            return true
        }
        catch {
            Logger.log(error.localizedDescription)
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        }
        catch {
            Logger.log(error.localizedDescription)
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteAccount() async -> Bool {
        do {
            try await user?.delete()
            return true
        }
        catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}

enum AuthenticationError: Error {
    case tokenError(message: String)
}

extension AuthenticationViewModel {
    func signInWithGoogle() async -> Bool {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("No client ID found in Firebase configuration")
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            Logger.log("There is no root view controller!")
            return false
        }
        
        do {
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            
            let user = userAuthentication.user
            guard let idToken = user.idToken else { throw AuthenticationError.tokenError(message: "ID token missing") }
            let accessToken = user.accessToken
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                           accessToken: accessToken.tokenString)
            
            let result = try await Auth.auth().signIn(with: credential)
            let firebaseUser = result.user
            Logger.log("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "unknown")")
            return true
        }
        catch {
            Logger.log(error.localizedDescription)
            self.errorMessage = error.localizedDescription
            return false
        }
    }
}
