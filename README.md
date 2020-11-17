# VCModifier

Пакет для приминения изменений к UIViewController из SwiftUI. Выход из SwiftUI песочницы реализован через с помощью UIViewControllerRepresentable и свойства parent для UIViewController.

## Как пользоваться?

Приминение модификаторов ко View происходит следущим образом:
```
struct MyView: View {
    var body: some View {
        NavigationView {
            Text("Hello, world")
                .modifyViewController([NavigationSearchBar($text)])
        }
    }
}
```

Примечание: Данная реализация выбрана потому, что в этом случае не придется пладить множество UIViewRepresentable элементов, каждый из которых будет менять лишь один параметр.

## Куда запрягать коней?

Вы можете создавать любые модификации на свое усмотрение и добавлять из с помощью .modifyViewController, они должны лишь следовать простому протоколу:

```
public protocol VCModifier {
    // make - будет вызвыветься с событием viewWillAppear(_ animated: Bool) ViewController'а связанного с модификатором
    func make(_ vc: UIViewController)
    
    // update - будет обновляться по событию updateUIViewController из UIViewRepresentable 
    func update(_ vc: UIViewController)
}
```

Смещение make из UIViewRepresentable обусловлено тем, что выход на родительский ViewController в данном моменте не доступен.

## На примере:

Примечание: Из примера для экономии места убран инициализатор.

```
public class NavigationSearchBar: NSObject, VCModifier, UISearchResultsUpdating {
    @Binding var searchBarText: String?
    @Binding var isSearching: Bool
    var placeholder: String?
    var hidesWhenScrolling: Bool
    
    public func make(_ vc: UIViewController) {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = placeholder
        searchController.obscuresBackgroundDuringPresentation = false
        
        vc.navigationItem.hidesSearchBarWhenScrolling = hidesWhenScrolling
        vc.navigationItem.searchController = searchController
    }
    
    public func update(_ vc: UIViewController) {}
    
    public func updateSearchResults(for searchController: UISearchController) {
        self.searchBarText = searchController.searchBar.text
        self.isSearching = searchController.isActive
    }
}
```

Класс NavigationSearchBar соответствует протоколу VCModifier и имеет методы make и update. Метод make используется для создания и настройки выбранного элемента. Функция update в данном случае не имеет необходимости так как внешние состояния не будут влиять на данный элемент. Так же в данном классе реализован метод updateSearchResults для передачи данных из searchBar обратно во View посредством @Binding свойств.


## Поддерживаемые операционные системы

- iOS 13 или выше
- tvOS 13 или выше
