# Fix widget imports script
$files = Get-ChildItem -Path "lib/presentation/widgets" -Recurse -Filter "*.dart"

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    
    # Remove old individual core imports that are now in core.dart export
    $content = $content -replace "import '\.\.\/\.\.\/core\/constants\/app_colors\.dart';\r?\n", ""
    $content = $content -replace "import '\.\.\/\.\.\/core\/constants\/app_strings\.dart';\r?\n", ""
    $content = $content -replace "import '\.\.\/\.\.\/core\/constants\/app_theme\.dart';\r?\n", ""
    $content = $content -replace "import '\.\.\/\.\.\/core\/utils\/emotion_utils\.dart';\r?\n", ""
    
    # Fix relative paths for widgets in subdirectories
    $content = $content -replace "import '\.\.\/providers\/emotion_provider\.dart';", "import '../../providers/providers.dart';"
    $content = $content -replace "import '\.\.\/\.\.\/data\/models\/", "import '../../../data/"
    
    # Add core import if AppColors or AppStrings are used and core import is missing
    if (($content -match "AppColors\.|AppStrings\.|AppTheme\.|EmotionUtils\.") -and ($content -notmatch "import.*core\.dart")) {
        $content = $content -replace "(import 'package:flutter/material\.dart';\r?\n)", "`$1import '../../../core/core.dart';`n"
    }
    
    Set-Content $file.FullName -Value $content -NoNewline
    Write-Host "Fixed imports in: $($file.Name)"
}

Write-Host "Import fixes completed!" 