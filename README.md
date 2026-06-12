# CoreStash

CoreStash is an offline-first QR inventory collection and reporting platform built with Flutter. It uses a single codebase to deliver two platform-specific workflows: a mobile scanning client for field data collection and a desktop/web reporting client for inventory review and document generation.

Rather than relying on cloud infrastructure, user accounts, or backend services, CoreStash uses CSV files as its data interchange format. Inventory data can be collected on Android devices, transferred using any preferred method, and imported into the desktop or web application for reporting.

## Features

### Mobile Client (Android)

- Create and manage inventory batches
- Edit batch names and descriptions
- Scan QR codes using the device camera
- Automatic scan detection with cooldown protection
- Prevent duplicate QR entries across the entire database
- Import inventory data from CSV files
- Export batches to CSV files
- Offline local storage using Drift

### Desktop / Web Client

- Import inventory batches from CSV files
- Review inventory records
- Delete imported batches
- Generate formatted PDF reports
- Offline local storage using Drift

## Workflow

1. Create a batch on the Android application.
2. Scan inventory QR codes into the selected batch.
3. Export the batch as a CSV file.
4. Transfer the CSV file using any preferred method.
5. Import the CSV file into the desktop or web application.
6. Generate a PDF report for archival or distribution.

## Architecture

CoreStash follows a dual-client architecture powered by a shared Flutter codebase.

### Android Client

Responsible for inventory acquisition:

- Batch creation
- QR code scanning
- Local persistence
- CSV export

### Desktop / Web Client

Responsible for inventory reporting:

- CSV import
- Inventory review
- PDF generation
- Local persistence

No backend server, cloud synchronization service, or external database is required.

## Data Model

### Inventory Batch

| Field | Description |
|---------|-------------|
| id | Internal batch identifier |
| name | Batch name |
| description | Batch description |
| createdAt | Creation timestamp |

### Inventory

| Field | Description |
|---------|-------------|
| id | Internal inventory identifier |
| batchId | Parent batch reference |
| qrCode | Unique QR value |
| scannedAt | Scan timestamp |

### Duplicate Protection

CoreStash enforces global QR uniqueness. A QR code can only exist once within the local repository, preventing accidental duplicate inventory records across batches.

## CSV Interchange Format

CSV files contain inventory information required for transport between platforms.

Each record includes:

- QR code value
- Batch name
- Batch description
- Scan date

Database identifiers are intentionally excluded and regenerated during import.

## Technology Stack

- Flutter
- Drift
- Riverpod
- GoRouter
- Mobile Scanner
- CSV
- PDF
- Printing
- File Picker
- Share Plus

## Project Structure

```text
lib/
└── src
    ├── app
    ├── core
    │   ├── database
    │   ├── services
    │   └── utils
    ├── features
    │   ├── batch
    │   └── inventory
    └── shared
```

The project follows a feature-oriented structure with clear separation between presentation, state management, data access, and persistence layers.

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio or Android SDK
- Chrome (for web development)

### Install Dependencies

```bash
flutter pub get
```

### Generate Drift Files

```bash
dart run build_runner build
```

### Run on Android

```bash
flutter run
```

### Run on Web

```bash
flutter run -d chrome
```

### Build Web Release

```bash
flutter build web
```

## Future Improvements

- Direct device-to-device synchronization
- Additional report templates
- Windows and macOS distribution packages
- Advanced inventory metadata support
- Batch merge and reconciliation workflows

## About

CoreStash was developed as an internship project to explore offline-first inventory collection, cross-platform Flutter development, and lightweight reporting workflows without requiring dedicated backend infrastructure.
