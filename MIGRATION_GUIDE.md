# Migration Guide: Fixing Import Statements

## Overview

After restructuring the project, many import statements need to be updated to use the new export files and correct paths.

## 🔧 Quick Fix Patterns

### 1. Core Imports
**Before:**
```dart
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_theme.dart';
```

**After:**
```dart
import '../../../core/core.dart';  // From subdirectory screens
import '../../core/core.dart';     // From main screens directory
```

### 2. Provider Imports
**Before:**
```dart
import '../providers/emotion_provider.dart';
import '../providers/analysis_provider.dart';
```

**After:**
```dart
import '../../providers/providers.dart';  // From subdirectory screens
import '../providers/providers.dart';     // From main screens directory
```

### 3. Widget Imports
**Before:**
```dart
import '../widgets/analytics_card.dart';
import '../widgets/results_card.dart';
import '../widgets/analyze_button.dart';
```

**After:**
```dart
import '../../widgets/widgets.dart';  // From subdirectory screens
import '../widgets/widgets.dart';     // From main screens directory
```

### 4. Domain/Data Imports
**Before:**
```dart
import '../../domain/entities/analysis_result.dart';
import '../../data/models/user_model.dart';
```

**After:**
```dart
import '../../../domain/domain.dart';  // From subdirectory screens
import '../../../data/data.dart';      // From subdirectory screens
```

## 📁 Path Reference by Screen Location

### For screens in `lib/presentation/screens/admin/`
```dart
import '../../../core/core.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';
import '../../../domain/domain.dart';
import '../../../data/data.dart';
import '../core/core_screens.dart';      // For core screens
```

### For screens in `lib/presentation/screens/employee/`
```dart
import '../../../core/core.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';
import '../../../domain/domain.dart';
import '../../../data/data.dart';
import '../analysis/analysis_screens.dart';  // For analysis screens
```

### For screens in `lib/presentation/screens/core/`
```dart
import '../../../core/core.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';
import '../../../domain/domain.dart';
import '../../../data/data.dart';
```

## 🚀 Automated Fix Script

Create a PowerShell script to help with bulk replacements:

```powershell
# fix-imports.ps1
$patterns = @(
    @{
        Find = "import '../../core/constants/app_colors.dart';"
        Replace = "import '../../../core/core.dart';"
    },
    @{
        Find = "import '../../core/constants/app_strings.dart';"
        Replace = ""  # Remove - already included in core.dart
    },
    @{
        Find = "import '../../core/constants/app_theme.dart';"
        Replace = ""  # Remove - already included in core.dart
    },
    @{
        Find = "import '../providers/emotion_provider.dart';"
        Replace = "import '../../providers/providers.dart';"
    }
)

# Run for each file in subdirectories
Get-ChildItem -Path "lib/presentation/screens/" -Recurse -Filter "*.dart" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    foreach ($pattern in $patterns) {
        $content = $content -replace [regex]::Escape($pattern.Find), $pattern.Replace
    }
    Set-Content $_.FullName $content
}
```

## 🛠️ Manual Fix Steps

### Step 1: Fix Core Screens
1. Go to `lib/presentation/screens/core/`
2. Update imports in each file:
   - Replace `import '../../core/constants/` with `import '../../../core/core.dart';`
   - Remove duplicate core imports
   - Update provider imports

### Step 2: Fix Feature Screens
1. Go to each feature directory (`admin/`, `employee/`, `analysis/`, `analytics/`)
2. Update imports following the patterns above
3. Test each screen after fixing

### Step 3: Fix Widget Files
1. Go to `lib/presentation/widgets/`
2. Update imports in widget files that moved to subdirectories
3. Use `../../core/core.dart` pattern

## ⚠️ Common Issues

### Issue 1: Missing Classes After Import Fix
**Problem:** `AppColors` not found after using `core.dart`
**Solution:** Ensure `lib/core/core.dart` exports all constants files

### Issue 2: Circular Imports
**Problem:** Screen tries to import itself through export file
**Solution:** Import specific files instead of export files for local references

### Issue 3: Provider Not Found
**Problem:** `EmotionProvider` not accessible
**Solution:** Check if provider is included in `providers.dart` export file

## 🧪 Testing After Migration

### Verification Checklist
- [ ] App compiles without errors
- [ ] All screens load correctly
- [ ] Navigation works between screens
- [ ] Providers are accessible
- [ ] Colors and themes display correctly
- [ ] No circular import warnings

### Test Commands
```bash
# Check for compilation errors
flutter analyze

# Run the app
flutter run --debug

# Run tests
flutter test
```

## 🎯 Priority Order for Fixes

1. **High Priority** - Fix these first:
   - `role_selection_screen.dart` (app entry point)
   - `admin_navigation_screen.dart` (admin entry)
   - `employee_navigation_screen.dart` (employee entry)

2. **Medium Priority**:
   - Core screens (`dashboard_screen.dart`, `settings_screen.dart`)
   - Main feature screens

3. **Low Priority**:
   - Secondary screens
   - Utility screens

## 📝 Example Complete Fix

**Before (`lib/presentation/screens/core/dashboard_screen.dart`):**
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/emotion_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_theme.dart';
import '../widgets/connection_status_card.dart';
```

**After:**
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/core.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';
```

## 🎉 Benefits After Migration

- **Cleaner imports** - Single import line per layer
- **Better maintainability** - Clear dependency structure  
- **Easier refactoring** - Centralized exports
- **Faster development** - No need to hunt for file paths
- **Team consistency** - Everyone uses same import patterns

---

Following this guide will ensure all import statements are correctly updated for the new clean architecture structure. 