//
//  Theme.swift
//  To-Do-App
//
//  Created by Rza Ismayilov on 26.06.22.
//

import RxRelay
import RxSwift
import CoreData

enum Theme: String {
    case dark = "dark", light = "light"
}

class ThemeController {
    
    private let defaults = UserDefaults.standard
    
    private let key = "THEME"
    
    public static let instance = ThemeController()
    
    private init() {}
    
    private lazy var activeTheme: Theme = {
        guard let rawStr = defaults.string(forKey: key) else { return .light }
        guard let theme = Theme(rawValue: rawStr) else { return .light }
        return theme
    }()
    
    public let themeRelay = PublishRelay<Theme>()

    @objc public func switchTheme() {
        switch self.activeTheme {
        case .dark:
            self.activeTheme = .light
        case .light:
            self.activeTheme = .dark
        }
        writeTheme()
        loadTheme()
    }
    
    public func loadTheme() {
        themeRelay.accept(activeTheme)
    }
    
    public func writeTheme() {
        defaults.set(self.activeTheme.rawValue, forKey: key)
    }
}
