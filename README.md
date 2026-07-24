# CareFlow — Hospital Management App

A comprehensive iOS hospital management application built with **SwiftUI** and **Core Data**, enabling patients to manage appointments, track medications, view medical reports, monitor health vitals, and connect with doctors.

---

## Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Core Data Model](#core-data-model)
- [App Flow](#app-flow)
- [Screens Overview](#screens-overview)
- [Setup & Installation](#setup--installation)
- [Dummy Data Seeding](#dummy-data-seeding)
- [Notifications](#notifications)

---

## Features

| Module | Capabilities |
|---|---|
| **Home Dashboard** | Greeting header, health summary card, metric counters, upcoming appointment preview, pending medicines list |
| **Appointments** | Book appointments with doctors (date + time slot picker), view upcoming/history, cancel, reschedule, delete with confirmation |
| **Doctors** | Browse, search, and filter by specialty. Add new doctors with photo picker. View doctor detail and book directly from profile |
| **Medical Reports** | Upload PDF reports (patient or hospital sourced), associate with doctors, search/filter, view inline with PDFKit, delete |
| **Medicine Tracker** | View all medicines, toggle taken status with live progress bar, water intake tracker (local state) |
| **User Profile** | Personal info, emergency contact with tap-to-call, insurance details, BMI calculator, QR code generation, health vitals chart (BPM & SpO2) with add-new-reading sheet and health alerts |
| **Notifications** | Local push notifications scheduled 0 minutes before appointments, instant confirmation notifications |
| **Splash Screen** | Animated branded splash screen ("CareFlow") with spring animations |

---

## Tech Stack

| Layer | Technology |
|---|---|
| UI Framework | SwiftUI |
| Persistence | Core Data (`NSPersistentContainer`) |
| Charts | Swift Charts (iOS 16+) |
| PDF Viewing | PDFKit (`UIViewRepresentable`) |
| QR Code Generation | Core Image (`CIFilter.qrCodeGenerator`) |
| Photo Selection | PhotosUI (`PhotosPicker`) |
| File Import | `UniformTypeIdentifiers` (`.pdf` import) |
| Notifications | UserNotifications (`UNUserNotificationCenter`) |
| Target | iOS 16+ / Xcode 15+ |

---

## Architecture

```
App Entry (Hospital_Management_AppApp)
    │
    ├── PersistenceController (Core Data Stack + Auto-Seeding)
    │
    ├── NotificationManager (Singleton — Local Notifications)
    │
    └── SplashScreenView (Animated, 2.5s)
            │
            └── RootTabView (6 Tabs)
                    │
                    ├── Tab 0: HomeScreen
                    ├── Tab 1: AppointmentBookingHistory
                    ├── Tab 2: DoctorsListView
                    ├── Tab 3: MedicalReportsDashboard
                    ├── Tab 4: UserProfileView
                    └── Tab 5: MedicineDetailView
```

**Design Patterns Used:**
- **MVVM-lite** — Views hold `@FetchRequest` for data, business logic in view methods
- **Singleton** — `PersistenceController.shared`, `NotificationManager.shared`
- **Environment Injection** — `managedObjectContext` and `User` passed via `.environment()` / `.environmentObject()`
- **Composition** — Reusable card components (`DoctorRowCard`, `AppointmentCardView`, `MedicineCardView`, `InfoRow`, etc.)

---

## Project Structure

```
Hospital Management App/
│
├── Hospital_Management_AppApp.swift          # App entry point
├── Persistence.swift                          # Core Data stack + seeding logic
│
├── Components/
│   ├── SplashScreen.swift                     # Animated launch screen
│   └── NotificationManager.swift              # Local notification manager
│
├── Extension/
│   └── DummyData.swift                        # Seed data for all entities
│
├── Hospital_Management_App.xcdatamodeld/      # Core Data model (7 entities)
│
├── View/
│   ├── TabView/
│   │   └── RootTabView.swift                  # Main tab bar (6 tabs)
│   │
│   ├── HomeScreen/
│   │   ├── ContentView.swift                  # Home dashboard
│   │   ├── HealthInfoCard.swift               # Static health summary card
│   │   ├── MetricCounterRow.swift             # Appointments/Reports/Medicines counters
│   │   ├── PendingMedicineScreen.swift        # Pending medicines list
│   │   └── Upcoming_Appointments/
│   │       └── UpcomingAppointmentCard.swift   # Next upcoming appointment card
│   │
│   ├── AppointmentPage/
│   │   ├── AppointmentBookingPage/
│   │   │   ├── Appointment_Booking.swift      # Date + time slot selection
│   │   │   ├── BookingSuccessView.swift       # Confirmation animation screen
│   │   │   └── DoctorBookingHeaderView.swift  # Doctor info header on booking page
│   │   │
│   │   └── AppointmentBookingHistory/
│   │       ├── AppointmentBookingHistory.swift # Upcoming/History segmented list
│   │       ├── AppointmentCardView.swift       # Individual appointment card
│   │       ├── AppointmentComponent.swift      # StatusBadge + Appointment extensions
│   │       └── RescheduleSheetView.swift       # Reschedule date/time sheet
│   │
│   ├── DoctorScreen/
│   │   ├── DoctorsListView.swift              # Searchable/filterable doctor list
│   │   ├── DoctorDetailScreen.swift           # Doctor profile + book button
│   │   ├── DoctorRowCard.swift                # Doctor list row card
│   │   ├── AddNewDoctorSheet.swift            # Add doctor form (PhotosPicker)
│   │   └── SpecialtyFilterView.swift          # Horizontal category filter chips
│   │
│   ├── MedicineScreen/
│   │   ├── MedicineDetailView.swift           # Medicine list + progress header
│   │   ├── MedicineCardView.swift             # Individual medicine card (toggle taken)
│   │   ├── MedicineProgressHeaderView.swift   # Green progress bar header
│   │   └── WaterIntakeCardView.swift          # Water intake tracker
│   │
│   ├── Report/
│   │   ├── MedicalReportsDashboard.swift      # Report list with search/filter
│   │   ├── UploadReportView.swift             # Upload PDF form (fileImporter)
│   │   ├── ReportRowCardView.swift            # Report list row card
│   │   ├── PdfViewer.swift                    # PDFKit UIViewRepresentable
│   │   └── SaveDataHelper.swift               # ReportDataManager save helper
│   │
│   └── UserProfile/
│       ├── UserProfileView.swift              # Profile screen (composes all cards)
│       ├── UserHeaderCardView.swift           # Name, patient ID, QR button
│       ├── UserInformationCardView.swift      # Personal info (name, DOB, gender, allergies)
│       ├── EmergencyContactCardView.swift     # Emergency contact + tap-to-call
│       ├── InsuranceDetailsCardView.swift     # Insurance provider, policy, coverage
│       ├── BMICalculator.swift                # BMI from height/weight + status
│       ├── UserHealthChart.swift              # Swift Charts BPM/SpO2 line graph
│       ├── UserHealthAddSheet.swift           # Add new vitals reading form
│       ├── UserStatItemView.swift             # Reusable stat item component
│       └── ExpanedQRModal.swift               # Full-screen QR code modal
│
└── Assets.xcassets/
    ├── AccentColor.colorset/
    ├── AppIcon.appiconset/
    ├── CustomColors/
    └── Images/
```

---

## Core Data Model

### Entity Relationship Diagram (Textual)

```
┌──────────┐     ┌────────────────┐     ┌──────────┐
│   User   │────▶│   Appointment  │◀────│  Doctor  │
└──────────┘     └────────────────┘     └──────────┘
     │                    │                    │
     │                    ▼                    │
     │            ┌────────────────┐           │
     │            │  Prescription  │◀──────────┘
     │            └────────────────┘
     │                    │
     │                    ▼
     │            ┌────────────────┐
     └───────────▶│    Medicine    │
                  └────────────────┘
     │
     ├───────────▶┌────────────────┐
     │            │   HealthLog    │
     │            └────────────────┘
     │
     └───────────▶┌────────────────┐
                  │     Report     │◀── Doctor
                  └────────────────┘
```

### Entity Details

#### User
| Attribute | Type | Description |
|---|---|---|
| id | UUID | Unique identifier |
| name | String | Full name |
| dob | Date | Date of birth |
| gender | String | Gender |
| bloodGroup | String | Blood group (e.g., "AB+") |
| height | String | Height in cm |
| weight | String | Weight in kg |
| allergies | String | Known allergies |
| phone | String | Phone number |
| email | String | Email address |
| address | String | Home address |
| emergencyContact | Int32 | Emergency contact number |
| insuranceDetails | String | Insurance provider |
| policyId | String | Policy number |
| **Relationships** | | → Appointments, Medicines, Prescriptions, Reports, HealthLogs |

#### Doctor
| Attribute | Type | Description |
|---|---|---|
| id | UUID | Unique identifier |
| name | String | Doctor name |
| department | String | Specialty (Cardiology, Neurology, etc.) |
| experienceYears | Int16 | Years of experience |
| qualification | String | Medical qualifications |
| about | String | Bio / description |
| imageData | Binary | Doctor photo (JPEG) |
| **Relationships** | | → Appointments, Prescriptions, Reports |

#### Appointment
| Attribute | Type | Description |
|---|---|---|
| id | UUID | Unique identifier |
| date | Date | Appointment date |
| timeSlot | String | Time slot (e.g., "09:00 AM") |
| status | String | "Scheduled", "Completed", "Cancelled", "Canceled" |
| **Relationships** | | → User, Doctor, Prescription |

#### Prescription
| Attribute | Type | Description |
|---|---|---|
| id | UUID | Unique identifier |
| notes | String | Doctor's notes |
| startDate | Date | Prescription start date |
| **Relationships** | | → User, Doctor, Appointment, Medicines |

#### Medicine
| Attribute | Type | Description |
|---|---|---|
| id | UUID | Unique identifier |
| name | String | Medicine name |
| dosage | String | Dosage (e.g., "5mg") |
| category | String | Category (e.g., "Blood Pressure") |
| frequency | String | Frequency (e.g., "Once daily") |
| nextTime | String | Next dose time |
| isTaken | Boolean | Taken status toggle |
| daysLeft | Int16 | Days remaining |
| **Relationships** | | → User, Prescription |

#### HealthLog
| Attribute | Type | Description |
|---|---|---|
| id | UUID | Unique identifier |
| bpm | Double | Heart rate |
| spo2 | Double | Blood oxygen level |
| date | Date | Reading date |
| **Relationships** | | → User |

#### Report
| Attribute | Type | Description |
|---|---|---|
| id | UUID | Unique identifier |
| title | String | Report title |
| reportType | String | Category (Pathology, Radiology, etc.) |
| uploadedBy | String | "Patient" or "Hospital" |
| date | Date | Upload date |
| fileData | Binary | PDF file data (external storage) |
| **Relationships** | | → User, Doctor |

---

## App Flow

### 1. Launch
```
App Launch → NotificationManager.requestNotificationPermission()
           → PersistenceController.shared (loads Core Data + seeds if empty)
           → SplashScreenView (animated "CareFlow" logo, 2.5s)
           → RootTabView
```

### 2. Home Screen (Tab 0)
- Fetches all Appointments and Medicines via `@FetchRequest`
- Filters to current user's data
- Displays:
  - **Header:** Greeting with user name + notification bell icon
  - **HealthInfoCard:** Static health summary (heart rate, BP, O₂, steps)
  - **MetricCountersRow:** Count of user's appointments, reports, and medicines
  - **UpcomingAppointmentCard:** Next upcoming (non-cancelled, non-completed) appointment with "See All" link
  - **PendingMedicinesSection:** Medicines where `isTaken == false`

### 3. Appointment Booking Flow
```
DoctorsListView → tap doctor → DoctorDetailScreen
    → "Book Appointment" → Appointment_Booking
        → Select date (DatePicker, future dates only)
        → Select time slot (grid of 5 available slots)
        → "Confirm Appointment"
            → Creates Appointment entity in Core Data
            → Schedules local notification (0 min before)
            → Sends instant confirmation notification
            → Shows BookingSuccessView with animation
            → "Go Back to Bookings" → switches to Appointments tab
```

### 4. Appointment Management
```
AppointmentBookingHistory
    ├── Segmented Picker: "Upcoming" (Scheduled) | "History" (Completed/Cancelled)
    ├── Each card shows: doctor image, name, department, status badge, date, time
    ├── "Scheduled" cards have:
    │   ├── "Cancel" → sets status to "Cancelled"
    │   └── "Reschedule" → opens RescheduleSheetView (new date + time slot)
    └── Swipe to delete → confirmation alert → permanently removes from Core Data
```

### 5. Doctor Management
```
DoctorsListView
    ├── Horizontal SpecialtyFilterView (All, Cardiology, Neurology, etc.)
    ├── Search bar (by name or department)
    ├── List of DoctorRowCards → tap → DoctorDetailScreen
    ├── Swipe to delete → confirmation alert
    └── "+" button → AddDoctorSheetView
        → PhotosPicker for doctor image
        → Form: name, department (menu), experience, qualification, about
        → "Save Doctor" → creates Doctor entity
```

### 6. Medical Reports Flow
```
MedicalReportsDashboard
    ├── Search bar (by report title)
    ├── Segmented filter: All | Patient | Hospital
    ├── List of DynamicReportRowCards → tap → PdfViewer (PDFKit)
    ├── Swipe to delete → confirmation alert
    └── "+" button → UploadReportView
        → Enter title, select category, associate doctor, select source (Patient/Hospital)
        → fileImporter for PDF attachment
        → "Save" → ReportDataManager.saveDynamicReport() → creates Report entity
```

### 7. Medicine Tracker
```
MedicineDetailView
    ├── MedicineProgressHeaderView (taken/total count + progress bar)
    ├── List of MedicineCardViews:
    │   → Shows name, dosage, category, frequency, next time, days left warning
    │   → Tap checkmark to toggle isTaken (saves to Core Data, refreshes parent)
    └── WaterIntakeCardView (local state, 8-glass tracker with add/remove)
```

### 8. User Profile
```
UserProfileView
    ├── UserHeaderCardView
    │   → Name, Patient ID (first 8 chars of UUID)
    │   → QR code button → ExpandedQRModalView (generates QR from patient ID)
    │   → Stats: Blood Group, Age (calculated from DOB), Weight
    │
    ├── UserInformationCardView
    │   → Full Name, Date of Birth, Gender, Allergies
    │
    ├── EmergencyContactCardView
    │   → Contact name, relationship, phone
    │   → Tap phone icon → UIApplication.shared.open(tel://)
    │
    ├── InsuranceDetailsCardView
    │   → Provider, Policy Number, Coverage type
    │
    ├── BMICalculatorView
    │   → Reads height/weight from User entity
    │   → Calculates BMI: weight / (height/100)²
    │   → Status: Underweight / Normal / Overweight / Obese
    │
    └── UserHealthChart
        → Segment picker: Heart Rate (BPM) | SpO2
        → Swift Charts line graph with point annotations
        → Y-axis scale: BPM [40–175], SpO2 [80–103]
        → "Add" button → UserHealthAddSheet
            → Enter date, BPM, SpO2
            → Saves HealthLog to Core Data
            → Validates readings:
              • BPM > max heart rate (220 - age) → alert
              • BPM < 50 → alert
              • SpO2 < 92% → alert
              • SpO2 > 100% → alert
```

---

## Dummy Data Seeding

On first launch, `PersistenceController.checkAndSeedDatabase()` seeds:

| Entity | Count | Details |
|---|---|---|
| User | 1 | Emily Rodriguez, AB+, Austin TX |
| Doctor | 5 | Alice Green (Cardiology), Brian Patel (Pediatrics), Clara Oswald (Neurology), David Kim (Orthopedics), Elena Rostova (Dermatology) |
| Appointment | 5 | Mix of Scheduled, Completed, and Canceled statuses |
| Prescription | 5 | Linked to appointments, with doctor notes |
| Medicine | 4 | Amlodipine, Metformin, Atorvastatin, Vitamin D3 |
| HealthLog | 5 | Monthly BPM and SpO2 readings over 5 months |

Seeding only runs once (when `User` entity count is 0).

---

## Notifications

**`NotificationManager`** (Singleton, `UNUserNotificationCenterDelegate`):

| Method | Purpose |
|---|---|
| `requestNotificationPermission()` | Requests alert, badge, and sound permissions |
| `ScheduleNotification(id:title:body:targetDate:minutesBefore:)` | Schedules a notification at `targetDate - minutesBefore` |
| `sendInstantNotification(id:title:body:)` | Sends notification after 10-second delay |
| `cancelNotification(id:)` | Cancels a pending notification by identifier |

**Current usage:**
- Appointment booking triggers both a scheduled and instant notification
- Scheduled notification fires at the appointment time (0 minutes before)

---

## Setup & Installation

### Requirements
- Xcode 15.0+
- iOS 16.0+ deployment target
- macOS Ventura 13.0+

### Steps
1. Clone the repository:
   ```bash
   git clone <repository-url>
   ```
2. Open the project:
   ```bash
   open "Hospital Management App.xcodeproj"
   ```
3. Add doctor images to `Assets.xcassets/Images/`:
   - Name them `doctor1`, `doctor2`, `doctor3`, `doctor4`, `doctor5`
   - Format: PNG or JPEG
4. Select a simulator or physical device (iOS 16+)
5. Build and run (`Cmd + R`)

> **Note:** The app auto-seeds dummy data on first launch. Delete and reinstall to re-seed.

---

## Design System

| Element | Value |
|---|---|
| Background | Warm beige `rgb(0.96, 0.95, 0.93)` with radial gradient overlays |
| Card Background | White with subtle shadows (`opacity: 0.03–0.04`) |
| Accent | Blue (`Color.blue`) for primary actions |
| Header Gradient | Brown tones `rgb(0.72, 0.58, 0.46)` → `rgb(0.55, 0.41, 0.30)` |
| Status Colors | Scheduled = Orange, Completed = Green, Cancelled = Red, Upcoming = Blue |
| Corner Radius | Cards: 16–24pt, Buttons: 14–16pt, Badges: 8–12pt |
| Typography | System font, bold for headers, medium for labels |
| Shadows | Light (`0.03–0.04` opacity, 6–8pt radius) |
