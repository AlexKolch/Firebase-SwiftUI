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
    var body: some View {
        SignIn()
    }
}

struct SignIn : View {

    @State var user = ""
    @State var pass = ""
    @State var message = ""
    @State var alert = false
    @State var show = false

    var body : some View{
        VStack {
             Text("Sign In").fontWeight(.heavy).font(.largeTitle).padding([.top,.bottom], 20)
            VStack{

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

                        SecureField("Enter Your Password", text: $pass)

                        Divider()
                    }

                }.padding(.horizontal, 6)

            }.padding()
///Кнопка Sign In
            VStack{
                Button(action: {
                    //Code
                }) {
                    Text("Sign In").foregroundColor(.white).frame(width: UIScreen.main.bounds.width - 120).padding()
                }.background(Color(.green))
                    .clipShape(Capsule())
                    .padding(.top, 45)

                Text("(or)").foregroundColor(Color.gray.opacity(0.5)).padding(.top,30)

                HStack(spacing: 8) {
                    Text("Don't Have An Account ?").foregroundColor(Color.gray.opacity(0.5))
///Кнопка Sign Up
                    Button(action: {
                        //Code
                    }) {
                        Text("Sign Up")
                    }.foregroundColor(.blue)

                }.padding(.top, 25)
            }
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
