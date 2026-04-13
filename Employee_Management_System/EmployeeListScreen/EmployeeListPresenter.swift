//
//  EmployeeListPresenter.swift
//  Employee_Management_System
//
//  Created by Sai Krishna on 4/9/26.
//

import Foundation
import Combine

class EmployeeListPresenter: ObservableObject, ReloadData{
    
    @Published var employeeModel: [EmployeeListModel] = []
    @Published var allEmployees: [EmployeeListModel] = []
    @Published var employee: EmployeeListModel?
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var id: String = ""
    @Published var loadingState: LoadingState = .idle
    @Published var searchText: String = ""
    
    var profileColorsArray: [String] = [
        "#FF5733", // red-orange
        "#6C5CE7", // purple
        "#FF6B6B", // soft red
        "#4ECDC4", // teal
        "#1A73E8", // blue
        "#00B894", // green
        "#FDCB6E", // yellow
        "#E17055", // coral
        "#0984E3", // strong blue
        "#A29BFE"  // lavender
    ]
    private var cancellables = Set<AnyCancellable>()
    
    let interactor: EmployeeListInteractor
    let router: EmployeeListRouter
    
    init(interactor: EmployeeListInteractor, router: EmployeeListRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func initialLoad(){
        setupSearchPublisher()
        getAllEmployees()
    }
    
    
    func getAllEmployees(){
        self.loadingState = .loading
        Task{
            do{
                let response = try await interactor.getAllEmployees()
                await MainActor.run{
                    self.employeeModel = response
                    self.allEmployees = response
                    self.loadingState = .loaded
                    print(response)
                }
                
            }catch let error{
                await MainActor.run{
                    self.loadingState = .error
                    print("Error: ", error.localizedDescription)
                }
            }
        }
    }
    
    
//    func getEmployeeById(id :Int){
//        Task{
//            do{
//                let response = try await interactor.getEmployeeById(id: id)
//                await MainActor.run{
//                    self.employee = response
//                }
//            }catch let error{
//                print("Error: ", error.localizedDescription)
//            }
//        }
//    }
    
    func setupSearchPublisher() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] text in
                self?.filterEmployees(query: text)
            }
            .store(in: &cancellables)
    }
    
    func filterEmployees(query: String) {
        guard !query.isEmpty else {
            employeeModel = allEmployees
            return
        }
        
        let lowercasedQuery = query.lowercased()
        
        employeeModel = allEmployees.filter { employee in
            (employee.name?.lowercased().contains(lowercasedQuery) ?? false) ||
            (employee.role?.lowercased().contains(lowercasedQuery) ?? false) ||
            (employee.department?.lowercased().contains(lowercasedQuery) ?? false)
        }
    }
    
    func addEmployee(){
        router.navigateToAddEmployee(delegate: self)
    }
    
    func openDetailsScreen(employee: EmployeeListModel, profileColor: String){
        router.openDetailsScreen(employee: employee, profileColor: profileColor, delegate: self)
    }
}
