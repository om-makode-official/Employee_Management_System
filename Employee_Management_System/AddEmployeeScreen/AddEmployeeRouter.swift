//
//  AddEmployeeRouter.swift
//  Employee_Management_System
//
//  Created by Sai Krishna on 4/9/26.
//

import Foundation

class AddEmployeeRouter{
    
    let popScreen: () -> Void
    let popToRootScreen: () -> Void
    
    init(popScreen: @escaping () -> Void,
         popToRootScreen: @escaping () -> Void) {
        self.popScreen = popScreen
        self.popToRootScreen = popToRootScreen
    }
    
    func goToBack(){
        self.popScreen()
    }
    func goToRootScreen(){
        self.popToRootScreen()
    }
}
