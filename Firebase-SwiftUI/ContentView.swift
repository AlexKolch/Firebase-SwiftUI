//
//  ContentView.swift
//  Firebase-SwiftUI
//
//  Created by Алексей Колыченков on 04.10.2023.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

struct ContentView: View {
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    @State var show: Bool = true

    var body: some View {
        VStack {
            if status {
                Home()
            } else {
                SignIn()
            }
        }.animation(.spring(), value: show)
            .onAppear() {
                NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main) { _ in
                    let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                    self.status = status
                }
            }
    }
}
//MARK: - Домашняя страница
struct Home: View {
    var body: some View {
        VStack {
            Text("Home").fontWeight(.bold)
            Button {
                UserDefaults.standard.set(false, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
            } label: {
                Text("Logout")
            }
        }
    }
}
//MARK: - Авторизация
struct SignIn : View {

    @State var user = ""
    @State var pass = ""
    @State var message = ""
    @State var showAlert = false
    @State var showSignUp = false

    var body : some View{
        VStack {
            VStack{
                Text("Sign In").fontWeight(.heavy).font(.largeTitle).padding([.top,.bottom], 20)

                VStack(alignment: .leading){
                    ///TextFields
                    VStack(alignment: .leading){
                        Text("Username").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))

                        HStack{
                            TextField("Enter Your Username", text: $user)

                            if user != ""{
                                Image("check")
                            }
                        }

                        Divider()

                    }.padding(.bottom, 15)

                    VStack(alignment: .leading){
                        Text("Password").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))

                        SecureField("Enter Your Password", text: $pass)

                        Divider()
                    }
                }.padding(.horizontal, 6)

                ///Кнопка Sign In
                Button(action: {
                    signInWithEmail(email: self.user, password: self.pass) { verified, status in
                        if !verified {
                            self.message = status
                            self.showAlert.toggle()
                        } else {
                            UserDefaults.standard.set(true, forKey: "status") //Сохраняем статус входа
                            NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                        }
                    }
                }) {
                    Text("Sign In").foregroundColor(.white).frame(width: UIScreen.main.bounds.width - 120).padding()
                }.background(Color(.systemMint))
                    .clipShape(Capsule())
                    .padding(.top, 45)

            }.padding()
                .alert(isPresented: $showAlert) {

                    Alert(title: Text("Error"), message: Text(self.message), dismissButton: .default(Text("Ok")))

                }
            VStack {

                Text("(or)").foregroundColor(Color.gray.opacity(0.5)).padding(.top,30)

                HStack(spacing: 8) {
                    Text("Don't Have An Account ?").foregroundColor(Color.gray.opacity(0.5))
                    ///Кнопка Registration
                    Button(action: {
                        self.showSignUp.toggle()
                    }) {
                        Text("Sign Up")
                    }.foregroundColor(.blue)

                }.padding(.top, 25)

            }.sheet(isPresented: $showSignUp) {
                SignUp(showSignUp: self.$showSignUp)
            }
        }
    }
}

//MARK: - Регистрация
struct SignUp : View {

    @State var user = ""
    @State var pass = ""
    @State var message = ""
    @State var showAlert = false
    @Binding var showSignUp : Bool

    var body : some View {
        VStack {
            Text("Sign Up").fontWeight(.heavy).font(.largeTitle).padding([.top,.bottom], 20)

            VStack(alignment: .leading){

                VStack(alignment: .leading){
                    Text("Username").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))

                    HStack{
                        TextField("Enter Your Username", text: $user)

                        if user != ""{
                            Image("check").foregroundColor(Color.init(.label))
                        }
                    }
                    Divider()

                }.padding(.bottom, 15)

                VStack(alignment: .leading){
                    Text("Password").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                    HStack {
                        SecureField("Enter Your Password", text: $pass)
                        if pass.count >= 6 {
                            Image("check").foregroundColor(Color.init(.label))
                        }
                    }

                    Divider()
                }
            }.padding(.horizontal, 6)

            ///Кнопка Sign Up
            Button(action: {
                signUpWithEmail(email: self.user, password: self.pass) { verified, status in
                    if !verified {
                        self.message = status
                        self.showAlert.toggle()
                    } else {
                        UserDefaults.standard.set(true, forKey: "status")
                        self.showSignUp.toggle()
                        NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                    }
                }
            }) {
                Text("Sign Up ").foregroundColor(.white).frame(width: UIScreen.main.bounds.width - 120).padding()
            }.background(Color(.systemMint))
                .clipShape(Capsule())
                .padding(.top, 45)

        }.padding()
            .alert(isPresented: $showAlert) {

                Alert(title: Text("Error"), message: Text(self.message), dismissButton: .default(Text("Ok")))

            }
    }
}

///Вход в приложение
func signInWithEmail(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
    Auth.auth().signIn(withEmail: email, password: password) { res, err in
        if err != nil {
            completion(false, (err?.localizedDescription)!)
            return
        }

        completion(true, (res?.user.email)!)
    }
}
///Регистрация в приложение
func signUpWithEmail(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
    Auth.auth().createUser(withEmail: email, password: password) { res, err in
        if err != nil {
            completion(false, (err?.localizedDescription)!)
            return
        }

        completion(true, (res?.user.email)!)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
