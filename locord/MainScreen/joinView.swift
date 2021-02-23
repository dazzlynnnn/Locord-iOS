//
//  joinView.swift
//  locord
//
//  Created by 이해린 on 2021/02/09.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class joinView: UIViewController {
    
    var userModel = UserModel() // 인스턴스 생성

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var joinButton: UIButton!
    
    
    // 회원 확인 method
    func isUser(id: String) -> Bool {
        for user in userModel.users {
            if user.email == id {
                return true // 이미 회원인 경우
            }
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 키보드 내리기
        nameTextField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        emailTextField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        passwordTextField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        passwordConfirmTextField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        joinButton.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
    }
    
    
    @IBAction func didTapJoinButton(_ sender: Any) {
        // 옵셔널 바인딩 & 예외 처리 : Textfield가 빈문자열이 아니고, nil이 아닐 때
        guard let name = nameTextField.text, !name.isEmpty else { return }
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        guard let passwordConfirm = passwordConfirmTextField.text, !passwordConfirm.isEmpty else { return }

        func post() {
            struct Join: Encodable {
                let nickname: String
                let email: String
                let password: String
            }

            let join = Join(nickname: name, email: email, password: password)

            AF.request("https://b0dcd17f1cdf.ngrok.io/user/signup",
                       method: .post,
                       parameters: join,
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
        
        if password == passwordConfirm {
            if let removable = self.view.viewWithTag(102) {
                removable.removeFromSuperview()
            }
        }
        else {
            shakeTextField(textField: passwordConfirmTextField)
            let passwordConfirmLabel = UILabel(frame: CGRect(x: 68, y: 470, width: 279, height: 45))
            passwordConfirmLabel.text = "비밀번호가 다릅니다."
            passwordConfirmLabel.textColor = UIColor.red
            passwordConfirmLabel.tag = 102
            
            self.view.addSubview(passwordConfirmLabel)
        }
        
        if userModel.isValidEmail(id: email) && userModel.isValidPassword(pwd: password) && password == passwordConfirm {
            let joinFail: Bool = isUser(id: email)
            if joinFail {
                print("이메일 중복")
                shakeTextField(textField: emailTextField)
                let joinFailLabel = UILabel(frame: CGRect(x: 68, y: 510, width: 279, height: 45))
                joinFailLabel.text = "이미 가입된 이메일입니다."
                joinFailLabel.textColor = UIColor.red
                joinFailLabel.tag = 103
                
                self.view.addSubview(joinFailLabel)
            }
            else {
                post()
                print("가입 성공")
                if let removable = self.view.viewWithTag(103) {
                    removable.removeFromSuperview()
                }
                self.performSegue(withIdentifier: "showMap", sender: self)
            }
        }
        

    }

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
        if nameTextField.isFirstResponder {
            emailTextField.becomeFirstResponder()
        }
        else if emailTextField.isFirstResponder {
            passwordTextField.becomeFirstResponder()
        }
        else if passwordTextField.isFirstResponder {
            passwordConfirmTextField.becomeFirstResponder()
        }
    }

}
