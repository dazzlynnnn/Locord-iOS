//
//  loginView.swift
//  locord
//
//  Created by 이해린 on 2021/02/09.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class loginView: UIViewController {

    var userModel = UserModel() // 인스턴스 생성
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // 로그인 method
    func loginCheck(id: String, pwd: String) -> Bool {
        for user in userModel.users {
            if user.email == id && user.password == pwd {
                return true // 로그인 성공
            }
        }
        return false
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 키보드 내리기
        emailTextField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        passwordTextField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        loginButton.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        
    } // end of viewDidLoad
    
    
    @IBAction func didTapLoginButton(_ sender: UIButton) {
        // 옵셔널 바인딩 & 예외 처리 : Textfield가 빈문자열이 아니고, nil이 아닐 때
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        
        func post() {
            struct Login: Encodable {
                let email: String
                let password: String
            }

            let login = Login(email: email, password: password)

            AF.request("https://40c623720049.ngrok.io/user/login",
                       method: .post,
                       parameters: login,
                       
                       encoder: JSONParameterEncoder.default).response { response in
                debugPrint(response)
            }
        }
        
        if userModel.isValidEmail(id: email){
            if let removable = self.view.viewWithTag(100) {
                removable.removeFromSuperview()
            }
        }
        else {
            shakeTextField(textField: emailTextField)
            let emailLabel = UILabel(frame: CGRect(x: 68, y: 350, width: 279, height: 45))
            emailLabel.text = "이메일 형식을 확인해 주세요"
            emailLabel.textColor = UIColor.red
            emailLabel.tag = 100
            
            self.view.addSubview(emailLabel)
        } // 이메일 형식 오류
        
        if userModel.isValidPassword(pwd: password){
            if let removable = self.view.viewWithTag(101) {
                removable.removeFromSuperview()
            }
        }
        else{
            shakeTextField(textField: passwordTextField)
            let passwordLabel = UILabel(frame: CGRect(x: 68, y: 435, width: 279, height: 45))
            passwordLabel.text = "비밀번호 형식을 확인해 주세요"
            passwordLabel.textColor = UIColor.red
            passwordLabel.tag = 101
            
            self.view.addSubview(passwordLabel)
        } // 비밀번호 형식 오류
        
        if userModel.isValidEmail(id: email) && userModel.isValidPassword(pwd: password) {
            let loginSuccess: Bool = loginCheck(id: email, pwd: password)
            if loginSuccess {
                post()
                print("로그인 성공")
                post()
                if let removable = self.view.viewWithTag(102) {
                    removable.removeFromSuperview()
                }
                self.performSegue(withIdentifier: "showMap", sender: self)
            }
            else {
                print("로그인 실패")
                shakeTextField(textField: emailTextField)
                shakeTextField(textField: passwordTextField)
                let loginFailLabel = UILabel(frame: CGRect(x: 68, y: 510, width: 279, height: 45))
                loginFailLabel.text = "아이디나 비밀번호가 다릅니다."
                loginFailLabel.textColor = UIColor.red
                loginFailLabel.tag = 102
                
                self.view.addSubview(loginFailLabel)
            }
        }
    } // end of didTapLoginButton
    
    
    // TextField 흔들기 애니메이션
    func shakeTextField(textField: UITextField) -> Void{
        UIView.animate(withDuration: 0.2, animations: {
            textField.frame.origin.x -= 10
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                textField.frame.origin.x += 20
            }, completion: { _ in
                UIView.animate(withDuration: 0.2, animations: {
                    textField.frame.origin.x -= 10
                })
            })
        })
    }
    
    
    // 다음 누르면 입력창 넘어가기, 완료 누르면 키보드 내려가기
    @objc func didEndOnExit(_ sender: UITextField) {
        if emailTextField.isFirstResponder {
            passwordTextField.becomeFirstResponder()
        }
    }
    
    @IBAction func kakaoLogin(_ sender: Any) {
        if let url = URL(string: "https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=582d94458100da17890f0de665515131&redirect_uri=https://40c623720049.ngrok.io/user/login/kakao"){
            UIApplication.shared.open(url, options: [:])
//            AF.request("https://40c623720049.ngrok.io/user/login/kakao",
//                       method: .get,
//                       parameters: "Content-Type : application/json",
//                       encoder: JSONParameterEncoder.default).response { response in
//                debugPrint(response)
//            }
        }
    }
    
    @IBAction func googleLogin(_ sender: Any) {
        if let url = URL(string: "https://accounts.google.com/o/oauth2/v2/auth/oauthchooseaccount?response_type=code&client_id=728473065211-9duhsnuiqoht6fao951m4s34a9pu7mqp.apps.googleusercontent.com&scope=profile%20email&state=YB4fxo3fSR-IwgkL_uXiCAqTuQaqIFcGcstSxUd3tNo%3D&redirect_uri=http%3A%2F%2F9bd2cc92bbd0.ngrok.io%2Fuser%2Flogin%2Fgoogle&flowName=GeneralOAuthFlow") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
}
