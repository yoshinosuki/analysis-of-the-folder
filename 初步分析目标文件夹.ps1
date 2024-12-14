function Get-FolderSize {
    param (
        [string]$folderPath
    )
    $totalSize = 0
    Get-ChildItem -Path $folderPath -Recurse -File | ForEach-Object {
        $totalSize += $_.Length
    }
    return $totalSize
}

function Get-FileTypesCount {
    param (
        [string]$folderPath
    )
    $fileTypesCount = @{}
    Get-ChildItem -Path $folderPath -Recurse -File | ForEach-Object {
        $extension = $_.Extension.ToLower()
        if ($fileTypesCount.ContainsKey($extension)) {
            $fileTypesCount[$extension]++
        } else {
            $fileTypesCount[$extension] = 1
        }
    }
    return $fileTypesCount
}

function Calculate-FoldersSize {
    param (
        [string]$rootFolder
    )
    $folderSizes = @{}

    # 计算根文件夹的大小和文件类型
    $folderSizes[$rootFolder] = @{
        Size = Get-FolderSize -folderPath $rootFolder
        FileTypes = Get-FileTypesCount -folderPath $rootFolder
    }

    # 计算子文件夹的大小和文件类型
    Get-ChildItem -Path $rootFolder -Directory | ForEach-Object {
        $folderPath = $_.FullName
        $folderSizes[$folderPath] = @{
            Size = Get-FolderSize -folderPath $folderPath
            FileTypes = Get-FileTypesCount -folderPath $folderPath
        }
    }

    return $folderSizes
}

function Save-ToJson {
    param (
        [string]$jsonFilePath,
        [hashtable]$data
    )
    $jsonData = $data | ConvertTo-Json -Depth 10
    Set-Content -Path $jsonFilePath -Value $jsonData
}

function Main {
    $rootFolder = Read-Host "请输入要计算的根文件夹路径"
    $folderSizes = Calculate-FoldersSize -rootFolder $rootFolder

    # 输出根文件夹的信息
    $rootSizeMB = [math]::Round($folderSizes[$rootFolder].Size / 1MB, 2)
    Write-Output "文件夹: $rootFolder, 大小: $rootSizeMB MB"
    Write-Output "文件类型统计:"
    foreach ($type in $folderSizes[$rootFolder].FileTypes.Keys) {
        $count = $folderSizes[$rootFolder].FileTypes[$type]
        Write-Output "$type : $count 个"
    }
    Write-Output ""

    # 输出子文件夹的信息
    foreach ($folder in $folderSizes.Keys | Where-Object { $_ -ne $rootFolder }) {
        $sizeMB = [math]::Round($folderSizes[$folder].Size / 1MB, 2)
        Write-Output "文件夹: $folder, 大小: $sizeMB MB"
        Write-Output "文件类型统计:"
        foreach ($type in $folderSizes[$folder].FileTypes.Keys) {
            $count = $folderSizes[$folder].FileTypes[$type]
            Write-Output "$type : $count 个"
        }
        Write-Output ""
    }

    # 确定 JSON 文件的保存位置
    $jsonFilePath = "C:\Users\surface\Desktop\fsdownload\output.json" 
    Save-ToJson -jsonFilePath $jsonFilePath -data $folderSizes
    Write-Output "统计结果已保存为: $jsonFilePath"
}


Main
& 'C:\Personal storage\app\python\python.exe' 'C:\Users\surface\code\check\check.py'
Pause