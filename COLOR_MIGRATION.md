# Color Migration Guide

## Mapping Warna Lama ke Warna Baru

### Warna Utama
- `AppColors.blue` → `AppColors.primary` (Soft Indigo #6366F1)
- `AppColors.blueLight` → `AppColors.primaryLight`
- `AppColors.blueDark` → `AppColors.primaryDark`

### Warna Secondary
- `AppColors.yellow` → `AppColors.secondary` atau `AppColors.warning` (Soft Teal/Amber)
- `AppColors.yellowLight` → `AppColors.secondaryLight` atau `AppColors.warningLight`
- `AppColors.yellowDark` → `AppColors.secondaryDark` atau `AppColors.warningDark`

### Status Colors
- `AppColors.green` → `AppColors.success` (Soft Green #10B981)
- `AppColors.greenLight` → `AppColors.successLight`
- `AppColors.greenDark` → `AppColors.successDark`

- `AppColors.red` → `AppColors.error` (Soft Red #EF4444)
- `AppColors.redLight` → `AppColors.errorLight`
- `AppColors.redDark` → `AppColors.errorDark`

### Background & Container Colors
- Background dengan opacity → Gunakan container colors:
  - `AppColors.green.withOpacity(0.1)` → `AppColors.successContainer`
  - `AppColors.red.withOpacity(0.1)` → `AppColors.errorContainer`
  - `AppColors.blue.withOpacity(0.1)` → `AppColors.primaryContainer` atau `AppColors.infoContainer`
  - `AppColors.yellow.withOpacity(0.1)` → `AppColors.warningContainer`

### Info Color
- Untuk informational UI → `AppColors.info` (Soft Blue #3B82F6)

### Accent Colors (Baru)
- `AppColors.accent1` (Soft Pink #EC4899)
- `AppColors.accent2` (Soft Amber #F59E0B) 
- `AppColors.accent3` (Soft Purple #8B5CF6)

### Gradient (Baru)
- `AppColors.primaryGradient` - Gradient Indigo ke Purple
- `AppColors.secondaryGradient` - Gradient Teal ke Cyan

## Contoh Penggunaan

### Before
```dart
Container(
  color: AppColors.blue,
  child: Icon(Icons.check, color: AppColors.white),
)
```

### After  
```dart
Container(
  decoration: BoxDecoration(
    gradient: AppColors.primaryGradient,  // Lebih modern!
  ),
  child: Icon(Icons.check, color: AppColors.white),
)
```

### Before (dengan opacity)
```dart
Container(
  decoration: BoxDecoration(
    color: AppColors.green.withOpacity(0.1),
    border: Border.all(color: AppColors.green),
  ),
)
```

### After
```dart
Container(
  decoration: BoxDecoration(
    color: AppColors.successContainer,  // Sudah termasuk opacity yang tepat
    border: Border.all(color: AppColors.success),
  ),
)
```
