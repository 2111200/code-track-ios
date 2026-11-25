# Project 21 – Coding Practice Tracker (SwiftUI, MVVM)

## Setup (5 minutes)
1. Xcode 15+ -> File > New > Project > iOS > App. Name: `CodingPracticeTracker`, Interface: SwiftUI, Language: Swift.
2. Delete the auto-generated `ContentView.swift` and the default `CodingPracticeTrackerApp.swift`.
3. Drag everything from this folder's `CodingPracticeTracker/` into the project (Copy items if needed, Create groups).
   When asked, replace the existing `Assets.xcassets` with the provided one (it contains the App Icon).
4. Target > Info tab > add key **Privacy - Face ID Usage Description** (`NSFaceIDUsageDescription`)
   with value: `Face ID is used to unlock your practice tracker.`
5. Target > General > Deployments: iOS 17.0, iPhone only, Portrait only (Device Orientation: untick Landscape).
6. Run on an iPhone simulator. Simulator Face ID: Features > Face ID > Enrolled, then Features > Face ID > Matching Face.
   Choose "Non-matching Face" to test the manual-login fallback.

## Structure (MVVM)
- Models/       Problem + enums (Difficulty, SolveStatus, Topic, Platform)
- Services/     ProblemStore (data + JSON persistence), BiometricService (Face ID), CredentialStore (manual login)
- ViewModels/   Auth, ManualLogin, Dashboard, ProblemList, ProblemDetail, ProblemForm (business logic + validation)
- Views/        Auth, Dashboard, Problems, Components (UI only)

## Feature -> file map
1 Face ID + manual login ........ AuthView, ManualLoginView, AuthViewModel, ManualLoginViewModel, BiometricService
2 Dashboard ..................... DashboardView, StatCard, DashboardViewModel
3 Problem List .................. ProblemListView, ProblemRowView, ProblemListViewModel
4 Add Problem ................... ProblemFormView, ProblemFormViewModel
5 Problem Details ............... ProblemDetailView, ProblemDetailViewModel
6 Edit Problem .................. ProblemFormView (edit mode)
7 Delete Problem ................ swipe in list + button with confirmation in detail
8 Search & Filter ............... searchable title search + topic / difficulty / status menu
9 Solve Status Tracking ......... SolveStatus enum, status menu in detail, status picker in form
