//
//  EmployeeListView.swift
//  Employee_Management_System
//
//  Created by Sai Krishna on 4/9/26.
//

import Foundation
import Combine
import SwiftUI


struct EmployeeListView: View {
    @StateObject var presenter: EmployeeListPresenter
    
    var body: some View {
        
        switch presenter.loadingState{
        case .idle:
            Color.white
                .onAppear(perform: {
                     presenter.initialLoad()
                })
                .ignoresSafeArea()
            
        case .loading:
            ProgressView()
        case .loaded:
            listView()
        case .error:
            errorScreen()
        }
    }
    
    func errorScreen() -> some View{
        VStack(spacing: 10){
            Text("Server Not Connected")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Please Connect To server")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Button(action: {
                presenter.initialLoad()
            }, label: {
                Text("Reload")
                    .padding(10)
                    .foregroundColor(.black)
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            })
            .padding()
        }
    }
    
    func listView() -> some View{
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(presenter.employeeModel.indices, id: \.self) { index in
                            
                            let employee = presenter.employeeModel[index]
                            let color = presenter.profileColorsArray[index % presenter.profileColorsArray.count]
                            
                            
                            rowView(employee: employee, profileColor: color)
                                .onTapGesture {
                                    presenter.openDetailsScreen(employee: employee, profileColor: color)
                                }
                            }
                    }
                    .padding()
                }
                .refreshable {
                    presenter.initialLoad()
                }
                .searchable(text: $presenter.searchText, prompt: "Search by name, role, or dept")
            }
            .navigationTitle("Employees")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        presenter.addEmployee()
                    }, label: {
                        Image(systemName: "plus")
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                            .bold()
                    })
                }
            }
    }
    
    func rowView(employee: EmployeeListModel, profileColor: String) -> some View{
        HStack(spacing: 16) {
            Circle()
                .fill(Color(hex: profileColor).opacity(0.2))
                .frame(width: 56, height: 56)
                .overlay(
                    Text(String(employee.name?.prefix(1) ?? "NA"))
                        .font(.title2.bold())
                        .foregroundColor(Color(hex: profileColor))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(employee.name ?? "NA")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(employee.role ?? "NA")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(employee.department ?? "NA")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(Capsule())
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(Color(UIColor.tertiaryLabel))
                .font(.system(size: 14, weight: .semibold))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.white)
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
        )
    }
}
