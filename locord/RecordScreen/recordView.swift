//
//  recordView.swift
//  locord
//
//  Created by 이해린 on 2021/02/17.
//

import UIKit
import EmojiPicker

class recordView: UIViewController {

    @IBOutlet weak var dateField : DateTextfield!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var diarytext: UITextView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var emojiButton : UIButton!
    
    let imagePicker = UIImagePickerController() //이미지 처리
    let emojipickerVC = EmojiPicker.viewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        self.dateField.dateChanged = {date in print(date)}
    }
    
    //이미지 처리
    @IBAction func addImage(_ sender: UIButton){
        let imageAlert = UIAlertController(title: "사진 가져오기", message: nil, preferredStyle: .actionSheet)
        let imageLibrary = UIAlertAction(title: "앨범", style: .default){(action) in self.openLibrary()}
        let cancel = UIAlertAction(title: "취소", style: .default, handler: nil)
        
        imageAlert.addAction(imageLibrary)
        imageAlert.addAction(cancel)
        present(imageAlert, animated: true, completion: nil)
    }
    //앨범 열기
    func openLibrary(){
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    //alert 함수
    func showAlertOkNo(msg: String){
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "네", style: .default) { (action) in
            self.showAlert(msg: "등록 완료!")
        }
        let noButton = UIAlertAction(title: "아니오", style: .default, handler: nil)
        alert.addAction(okButton)
        alert.addAction(noButton)
        present(alert, animated: true, completion: nil)
    }
    func showAlert(msg: String){
//        print(self.dateField.text)
//        print(self.image.image)
//        print(self.diarytext.text)
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    //등록하기 버튼 눌렀을 때
    @IBAction func enrollPressed(_ sender: UIButton){
        showAlertOkNo(msg: "이대로 등록하시겠습니까?")
    }
    
    //키보드 밖을 누르면 키보드 자동으로 사라지게
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        diarytext.endEditing(true)
    }
    
    @IBAction func emojiTouch(_ sender: UIButton){
        emojipickerVC.sourceRect = emojiButton.frame
        //emojipickerVC.popoverPresentationController?.sourceView = image
        emojipickerVC.size = CGSize(width: 300, height: 400)
        emojipickerVC.delegate=self
        emojipickerVC.dismissAfterSelected = true
        present(emojipickerVC, animated: true, completion: nil)
    }
}

//이미지 extension
extension recordView : UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    //image를 위한 delegate 추가
    //사진 선택이 끝나고 실행될 메서드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            image.image = chosenImage
        }
        dismiss(animated: true, completion: nil)
    }
}

extension recordView : EmojiPickerViewControllerDelegate{
    func emojiPickerViewController(_ controller: EmojiPickerViewController, didSelect emoji: String){
        emojiButton.setTitle(emoji, for: .normal)
    }
}
