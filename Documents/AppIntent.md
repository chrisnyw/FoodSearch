# Implementing AppIntent with Siri Support in an iOS Project

## Introduction

AppIntent is a powerful framework introduced by Apple that enables developers to integrate app functionality with Siri, Shortcuts, Spotlight suggestions and other system features. This guide will walk you through implementing AppIntent with Siri support in your iOS project.

## Prerequisites
- Xcode 16 or later
- iOS 18 or later
- A project with Siri capability enabled

## Demostration
### Siri demo
<figure>
<img src="https://github.com/user-attachments/assets/5a627147-3713-471f-a187-0cb7626a1d9c" title="Siri Demo" alt="Siri Demo"/>
</figure>

### Shortcuts app demo
<figure>
<img src="https://github.com/user-attachments/assets/63503b42-6198-4420-a6ff-da9130455f10" width="200" title="Shortcuts App Demo 1" alt="Shortcuts App Demo 1"/>
<img src="https://github.com/user-attachments/assets/41ffc92d-51c2-4180-bd08-273756e93e70" width="200" title="Shortcuts App Demo 2" alt="Shortcuts App Demo 2"/>
<img src="https://github.com/user-attachments/assets/1831f5aa-7e23-4864-83fa-c57a8df68d4f" width="200" title="Shortcuts App Demo 3" alt="Shortcuts App Demo 3"/>
<img src="https://github.com/user-attachments/assets/cd4128b7-4df8-4ed6-8cbe-fc23703b5a01" width="200" title="Shortcuts App Demo 4" alt="Shortcuts App Demo 4"/>
</figure>

## Step 1: Enable Siri Capability
1. Open your Xcode project.
2. Navigate to **Signing & Capabilities**.
3. Click on **+ Capability** and add **Siri**.
4. Ensure your app's entitlements file includes `com.apple.developer.siri`.

## Step 2: Define an Intent Using an IntentDefinition File
1. In Xcode, go to **File > New > File**.
2. Select **SiriKit Intent Definition File** and name it (reference to `SearchFoodIntent.intentdefinition`).
3. Open the file and click on the **+** button to add a new Intent.
4. Configure the intent by setting:
   - **Intent Name**: SearchFood
   - **Category**: Search
   - **Title**: "Search Food"
   - **Parameter**: Add a new parameter named `foodName` of type `String`, `comparative` as custom Enum and `calroies` as Integer.

## Step 3: Generate Intent Classes
1. In the **SearchFoodIntent.intentdefinition** file, check **App Intents** and **Code Generation**.
2. Build the project to generate Swift code automatically.

## Step 4: Implement the Intent Handling
1. Open the generated `SearchFoodIntentHandler` Swift file.
2. Implement the handling logic:

```swift
import Intents

public class SearchFoodIntentHandler: NSObject, SearchFoodIntentHandling {
    public func handle(intent: SearchFoodIntent, completion: @escaping (SearchFoodIntentResponse) -> Void) {
        let foodName = intent.foodName
        let moreOrLess = intent.comparative
        let calories = intent.calories

        // Perform action based on the event data (e.g., start a timer, schedule, etc.)
        print("Starting event: \(foodName) with \(moreOrLess) than \(calories) calories")

        // Respond back to Siri
        let response = SearchFoodIntentResponse.success(food: foodName ?? "error")
    
        completion(response)
    }
}
```

## Step 5: Register the Intent Handler
In your `AppDelegate` or `SceneDelegate`, register the intent handler:

```swift
import Intents

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.registerSiri()
        return true
    }

    private func registerSiri() {
        INPreferences.requestSiriAuthorization { status in
            if status == .authorized {
                print("Hey, Siri!")
            } else {
                print("Nay, Siri!")
            }
        }
    }
}
```

## Step 6: Add AppShortcut to Call Siri
To allow Siri to recognize and call the intent via AppShortcut, modify your intent definition by adding an `AppShortcutProvider`:

```swift
import AppIntents

struct AppShortcuts: AppShortcutsProvider {
    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: SearchFood(),
            phrases: [
                "Open \(.applicationName) with input"
            ],
            shortTitle: "Find Food Nutrition Info",
            systemImageName: "fork.knife"
        )
    }
}
```

## Step 7: Testing the Intent
To test your AppIntent:

1. Open the Shortcuts app.
2. Create a new shortcut.
3. Search for your app's intents and select it.
4. Run the shortcut and verify that it works as expected.
5. Try calling Siri and saying, "Open FoodSearch with input." as defined in the AppShortcuts class.

## Step 8: Debugging and Logs
Use Xcode’s console to debug any issues. You can also check `Siri & Search` settings to ensure your app appears in suggestions.

## Troubleshooting
Sometime when Siri cannot recognize your voice input even it matches the statement defined in AppShortcut class, try the following steps in order to make it work:
1. Delete and reinstall the debug app to simulator
2. Quit and start Simulator
3. If the above steps didn't work, try `Earse all Content and Settins` in simulator

## Conclusion
By integrating AppIntent with Siri using an IntentDefinition file, you streamline your app’s interaction with voice commands and automation. Continue exploring the AppIntents framework to extend your app’s functionality further.

## References
- [Apple Developer Documentation](https://developer.apple.com/documentation/appintents)
- [Integrating actions with Siri and Apple Intelligence](https://developer.apple.com/documentation/appintents/integrating-actions-with-siri-and-apple-intelligence)
- [Shortcuts and SiriKit](https://developer.apple.com/sirikit/)
