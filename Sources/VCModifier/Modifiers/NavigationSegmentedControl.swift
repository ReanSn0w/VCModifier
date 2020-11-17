//
//  NavigationSegmentedControl.swift
//
//  Модификатор для использования SegmentedControl в NavigationView
//
//  Created by Дмитрий Папков on 17.11.2020.
//

import SwiftUI

public protocol NavigationSegmentedControlElement: CaseIterable, Equatable {
    func Title() -> String?
    func Image() -> UIImage?
}

public class NavigationSegmentedControl<Cases>: VCModifier where Cases: NavigationSegmentedControlElement {
    let titleView = UISegmentedControl()
    @Binding var selectedCase: Cases
    
    public init(_ selectedCase: Binding<Cases>) {
        self._selectedCase = selectedCase
    }
    
    public func make(_ vc: UIViewController) {
        for (num, segment) in Cases.allCases.enumerated() {
            titleView.insertSegment(action: selectItemAction, at: num, animated: false)
            
            if let title = segment.Title() {
                titleView.setTitle(title, forSegmentAt: num)
            }
            
            if let image = segment.Image() {
                titleView.setImage(image, forSegmentAt: num)
            }
        }
        
        vc.navigationItem.titleView = titleView
        
        // Обновление производится для начальной установки сегмента
        update(vc)
    }
    
    public func update(_ vc: UIViewController) {
        // TODO: - избавиться от DispatchQueue в данном месте
        // если убрать его сейчас, то вызов обновления VCModifier происходит раньше чем обновиться значение в @Binding 
        DispatchQueue.main.async { [weak self] in
            for (num, segment) in Cases.allCases.enumerated() {
                if self?.selectedCase == segment {
                    self?.titleView.selectedSegmentIndex = num
                }
            }
        }
    }
    
    var selectItemAction: UIAction {
        return UIAction { _ in
            for (num, segment) in Cases.allCases.enumerated() {
                if num == self.titleView.selectedSegmentIndex {
                    self.selectedCase = segment
                }
            }
        }
    }
}
