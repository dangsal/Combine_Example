//
//  ViewModel.swift
//  combine_textfield_tutorial
//
//  Created by 이성호 on 2023/06/05.
//

import Foundation
import Combine

final class ViewModel {

    @Published var passwordInput: String = ""
    @Published var passwordConfirmInput: String = ""
    
    lazy var isMatchPasswordInput: AnyPublisher<Bool, Never> = Publishers.CombineLatest($passwordInput, $passwordConfirmInput)
        .map( { (password: String, passwordConfirm: String) in
            if password == "" || passwordConfirm == "" {
                return false
            }
            if password == passwordConfirm {
                return true
            }
            else {
                return false
            }
        } )
        .eraseToAnyPublisher()
}
