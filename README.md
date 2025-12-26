# N11 Colleague Connect Project: A Modern iOS Application Architecture Study

This project is a comprehensive iOS application developed to explore and implement modern software architecture and best practices. Built entirely in Swift UIKit, the application serves as a client for the GitHub API, allowing users to search, view, and manage a list of favorite users, all powered by a secure OAuth 2.0 authentication flow.

The core objective of this project was not just to build a functional app, but to architect a system that is **scalable, highly testable, and easily maintainable**, mirroring the standards of professional, large-scale iOS development.

## Core Architectural Philosophy: VIPER

The foundation of this application is the **VIPER (View, Interactor, Presenter, Entity, Router)** clean architecture pattern. This choice was deliberate to enforce a strict **Separation of Concerns (SoC)**, ensuring that each component of a feature module has a single, well-defined responsibility.

-   **View (`UIViewController`):** The "dumb" layer responsible only for displaying the UI. It is completely passive and driven by the Presenter. The entire UI is built programmatically using Auto Layout, with no Storyboards.
-   **Interactor:** The "business logic" layer. It orchestrates data from various sources, such as making network requests via the `APIClient` or fetching persisted data from the `FavoriteStorageService`. It is completely UI-agnostic.
-   **Presenter:** The "brain" of each module. It receives events from the View (e.g., button taps) and the Interactor (e.g., data fetched), processes this information, transforms raw data models (Entities) into UI-ready `PresentationModel`s, and sends simple display commands back to the View.
-   **Entity:** The raw `Codable` data models (`User`, `UserDetail`) that directly map to the GitHub API's JSON responses.
-   **Router:** Manages navigation and the construction of VIPER modules. It is the only component aware of how to instantiate and connect the V-I-P layers, and how to transition between different feature modules.

Communication between these layers is handled through a set of clearly defined contracts using **Protocol-Oriented Programming**, with an `Input/Output` naming convention to make the direction of data flow explicit.

## Key Technical Implementations & Features

### 1. Advanced, Protocol-Oriented Networking Layer

The network layer was designed to be completely abstract, reusable, and testable.

-   **`APIClient` as a Contract:** Instead of a concrete class, the `APIClient` is a `struct` of closures, defining a "menu" of capabilities (e.g., `searchUsers`, `getUserDetail`) without tying the application to a specific implementation.
-   **`Endpoint` Protocol:** Each API call is encapsulated in its own `Endpoint` struct. This provides a type-safe way to build `URLRequest`s, manage parameters, and define HTTP methods, eliminating messy and error-prone string manipulation.
-   **Modern Concurrency with `async/await`:** All network requests are performed asynchronously using Swift's modern concurrency features, resulting in clean, readable, and efficient code without nested completion handlers.
-   **Secure Credential Management:** Sensitive information such as `API_TOKEN`, `Client ID`, and `Client Secret` is kept out of the source code. It is managed securely using **`.xcconfig` files** and accessed at runtime through the `Info.plist`, a professional practice for handling secrets.

### 2. Modern & Data-Driven UI

The user interface is built programmatically and designed to be reactive to state changes.

-   **`UICollectionView` with Compositional Layout & DiffableDataSource:** The user list is rendered using a modern `UICollectionView`.
    -   **`CompositionalLayout`** is used to create a responsive, two-column grid that adapts to different screen sizes.
    -   **`DiffableDataSource`** powers all list updates. This provides automatic, animated, and crash-safe updates by calculating the difference between data states, which is vastly superior to `reloadData()`.
-   **Reusable & Configurable UI Components:**
    -   Shared components like `ProfileView`, `UserCell`, and `ErrorView` were built as standalone "LEGO pieces".
    -   A **`Configuration` struct pattern** was implemented for `ProfileView`, allowing the same component to be initialized with different style "themes" (`.cell` vs. `.detail`), making it incredibly flexible and reusable across different features.

### 3. Comprehensive State and Authentication Management

-   **Full OAuth 2.0 Flow:** The application implements a complete and secure user login flow.
    -   A `WKWebView` presents the GitHub authorization page.
    -   The app captures the `redirect_uri` using a custom **URL Scheme** (`n11peopleproject://auth`).
    -   The temporary `code` is extracted and exchanged for a permanent `access_token` via a `POST` request.
-   **Secure Token Persistence:** The fetched `access_token` is securely stored on the device using the **Keychain**, ensuring it is not lost between sessions and is protected by the operating system.
-   **Robust State Handling:** The ViewControllers are designed to handle multiple states beyond just the "loaded" state. This includes:
    -   **Loading State:** Displaying an `UIActivityIndicatorView` or a `SkeletonView` while data is being fetched.
    -   **Error State:** Presenting a dedicated, reusable `ErrorViewController` with a "Retry" option when an API call fails.
    -   **Empty State:** Showing an informative `EmptyStateView` when a search returns no results or the favorites list is empty.

### 4. Data Persistence

-   **`FavoriteStorageService`:** A dedicated service, following the **Singleton** pattern, was created to manage the user's list of favorite users. This service encapsulates the logic for reading from and writing to `UserDefaults`, providing a single source of truth for favorite data throughout the application. The `Interactor` layers communicate with this service to check and update favorite statuses.

This project was a deep dive into building a robust, scalable, and maintainable iOS application from the ground up, focusing on clean architecture, modern APIs, and a professional development workflow.
