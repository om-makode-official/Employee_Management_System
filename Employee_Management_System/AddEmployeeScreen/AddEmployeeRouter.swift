//
//  AddEmployeeRouter.swift
//  Employee_Management_System
//
//  Created by Sai Krishna on 4/9/26.
//

import Foundation

class AddEmployeeRouter{
    
    let popScreen: () -> Void
    
    init(popScreen: @escaping () -> Void) {
        self.popScreen = popScreen
    }
    
    func goToBack(){
        self.popScreen()
    }
}
