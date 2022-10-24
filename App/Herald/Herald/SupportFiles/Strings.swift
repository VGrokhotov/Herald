//
//  Strings.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 24.01.2022.
//

import Foundation
import Localizer

class Strings {
    
    // MARK: - Common
    static let logout = String(.en("Logout"), .ru("Выход"))
    static let success = String(.en("Success"), .ru("Успешно!"))
    static let ok = String(.en("OK"), .ru("ОК"))
    static let attention = String(.en("Attention!"), .ru("Внимание!"))
    static let cancel = String(.en("Cancel"), .ru("Отмена"))
    static let retry = String(.en("Retry"), .ru("Повторить"))
    static let error = String(.en("Error occurred"), .ru("Ошибка"))
    static let badMessage = String(.en("Something went wrong"), .ru("Что-то пошло не так!"))
    
    // MARK: - VC titles
    static let loginTitle = String(.en("Login"), .ru("Логинимся"))
    static let signUpTitle = String(.en("Sign up"), .ru("Создаем аккаунт"))
    static let verificatioTitle = String(.en("Almost done!"), .ru("Почти готово!"))
    
    // MARK: - Side Menu
    static let profileSideMenuTitle = String(.en("Profile"), .ru("Профиль"))
    static let settingsSideMenuTitle = String(.en("Settings"), .ru("Настройки"))
    static let logoutSideMenuTitle = String(.en("Logout"), .ru("Выйти"))
    static let developedByTitle = String(.en("Developed by VGrokhotov"), .ru("Заимплементил VGrokhotov"))
    
    // MARK: - Empty data
    static let defaultEmptyDataMessage = String(.en("Nothing here yet"), .ru("Здесь пусто"))
    static let defaultEmptyDataNote = String(
        .en("It seems you don't have any chat 🥲"),
        .ru("Кажется, вы еще никому не написали🥲")
    )
}
