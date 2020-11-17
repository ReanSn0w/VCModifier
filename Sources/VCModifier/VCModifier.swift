//
//  VCModifier.swift
//
//  Протокол VCModifier и элементы необходымые для его использования
//
//  Created by Дмитрий Папков on 17.11.2020.
//

import SwiftUI

public extension View {
    func modifyViewController(
        _ mods: [VCModifier]
    ) -> some View {
        self.background(VCModifierView(mods))
    }
}

public protocol VCModifier {
    func make(_ vc: UIViewController)
    func update(_ vc: UIViewController)
}

public struct VCModifierView: UIViewControllerRepresentable {
    var modifiers: [VCModifier]
    
    public init(_ mods: [VCModifier]) {
        self.modifiers = mods
    }
    
    public func makeUIViewController(context: Context) -> ModifierViewController {
        let vc = ModifierViewController()
        vc.modifiers = modifiers
        return vc
    }
    
    public func updateUIViewController(_ uiViewController: ModifierViewController, context: Context) {
        uiViewController.updateOperation()
    }
    
    public class ModifierViewController: UIViewController {
        var modifiers: [VCModifier] = []
        
        public override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            if let parent = self.parent {
                for mod in modifiers {
                    mod.make(parent)
                }
            }
        }
        
        func updateOperation() {
            if let parent = parent {
                for mod in modifiers {
                    mod.update(parent)
                }
            }
        }
    }
}
