//
//  ViewController.swift
//  combine_textfield_tutorial
//
//  Created by 이성호 on 2023/06/05.
//

import UIKit
import Combine

final class ViewController: UIViewController {

    // MARK: - ui component
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .gray
        return textField
    }()
    
    private let checkPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .gray
        return textField
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("확인", for: .normal)
        button.backgroundColor = .red
        button.isEnabled = false
        return button
    }()
    
    // MARK: - property
    
    private var viewModel: ViewModel = ViewModel()
    private var mySubscription: Set<AnyCancellable> = []
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
        self.setupPublisher()
    }

    // MARK: - func
    
    private func setupLayout() {
        self.view.addSubview(self.passwordTextField)
        self.passwordTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        self.passwordTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.passwordTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(self.checkPasswordTextField)
        self.checkPasswordTextField.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 50).isActive = true
        self.checkPasswordTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.checkPasswordTextField.widthAnchor.constraint(equalTo: self.passwordTextField.widthAnchor, multiplier: 1).isActive = true
        self.checkPasswordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(self.nextButton)
        self.nextButton.topAnchor.constraint(equalTo: self.checkPasswordTextField.bottomAnchor, constant: 50).isActive = true
        self.nextButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.nextButton.widthAnchor.constraint(equalTo: self.passwordTextField.widthAnchor, multiplier: 1).isActive = true
        self.nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupPublisher() {
        // textField에서 나가는 이벤트가 뷰모델의 프로퍼티가 구독
        self.passwordTextField
            .myTextPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.passwordInput, on: self.viewModel)
            .store(in: &mySubscription)
        
        self.checkPasswordTextField
            .myTextPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.passwordConfirmInput, on: self.viewModel)
            .store(in: &mySubscription)
        
        // 뷰모델의 퍼블리셔를 버튼이 구독
        self.viewModel.isMatchPasswordInput
            .receive(on: DispatchQueue.main)
            .print()
            .assign(to: \.isValid, on: nextButton)
            .store(in: &mySubscription)
    }
}

extension UITextField {
    var myTextPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
        // UITextField 가져옴
            .compactMap { $0.object as? UITextField }
        // String 가져옴
            .map { $0.text ?? "" }
            .print()
        // AnyPublisher 로 변경
            .eraseToAnyPublisher()
    }
}

extension UIButton {
    var isValid: Bool {
        get {
            backgroundColor == .lightGray
        }
        set {
            backgroundColor = newValue ? .red : .lightGray
            isEnabled = newValue
        }
    }
}
