
### 脚本1：clean-maven.sh（清理Maven未完成下载文件）


**使用说明：**
1. 默认清理官方仓库：`./clean-maven.sh`
2. 指定自定义仓库路径：`./clean-maven.sh /path/to/custom/repo`
3. 执行后会显示将要删除的目录并要求确认

---

### 脚本2：check-port.sh（端口占用检查及处理）


**使用说明：**
1. 默认检查8080端口：`./check-port.sh`
2. 指定其他端口：`./check-port.sh 3000`
3. 会自动尝试终止占用进程，需要时请使用sudo执行

---

### 使用方法
1. 为脚本添加执行权限：
   ```bash
   chmod +x clean-maven.sh check-port.sh
   ```
2. 执行脚本：
   ```bash
   # 清理Maven仓库
   ./clean-maven.sh
   
   # 检查端口占用
   ./check-port.sh 8080
   
   # 需要root权限时
   sudo ./check-port.sh 80
   ```

**注意事项：**
- 清理Maven仓库操作会永久删除文件，请确认后再执行
- 端口检查脚本需要系统安装lsof工具（可通过`brew install lsof`或`apt-get install lsof`安装）
- 终止系统关键进程可能导致服务异常，请谨慎操作


---

### `clean-maven.bat`（无需参数的 Maven 仓库清理工具）
---

### 使用说明
1. **直接运行**：双击 `clean-maven.bat` 即可清理默认的 Maven 仓库路径（`%USERPROFILE%\.m2\repository`）。
2. **无需参数**：脚本会自动处理路径和文件查找，用户只需确认是否执行清理。
3. **交互提示**：
   - 扫描 `.lastUpdated` 文件并显示数量。
   - 列出所有需要清理的目录。
   - 用户确认后执行清理操作。
4. **错误处理**：
   - 如果 Maven 仓库目录不存在，会提示错误并退出。
   - 如果清理失败（如权限不足），会显示具体目录。

---

### 示例运行
#### 场景 1：Maven 仓库存在 `.lastUpdated` 文件
```
正在扫描.lastUpdated文件...
找到 5 个.lastUpdated文件。
以下目录将被清理：
  C:\Users\YourUser\.m2\repository\org\example\project1
  C:\Users\YourUser\.m2\repository\com\example\project2
确认清理以上目录？(Y/N) Y
正在清理...
已清理：C:\Users\YourUser\.m2\repository\org\example\project1
已清理：C:\Users\YourUser\.m2\repository\com\example\project2
清理操作完成。
```

#### 场景 2：Maven 仓库不存在 `.lastUpdated` 文件
```
正在扫描.lastUpdated文件...
未找到.lastUpdated文件，无需清理。
```

#### 场景 3：Maven 仓库目录不存在
```
错误：Maven仓库目录不存在 - C:\Users\YourUser\.m2\repository
请按任意键继续...
```

---

### 特性
1. **完全自动化**：无需输入参数，直接运行即可。
2. **路径兼容**：支持路径中的空格和特殊字符。
3. **目录去重**：避免重复清理同一目录。
4. **用户友好**：清晰的交互提示和错误信息。
5. **轻量高效**：基于批处理脚本，无需额外依赖。

---

### 注意事项
1. **权限问题**：如果 Maven 仓库目录受保护，可能需要以管理员身份运行脚本。
2. **不可逆操作**：清理操作会永久删除目录，请确认后再执行。
3. **路径限制**：如果路径过长（超过 260 字符），可能需要启用长路径支持（Windows 10+）。

---

### 扩展功能（可选）
如果需要支持自定义路径，可以在脚本开头添加以下代码：
```bat
:: 支持自定义路径（可选）
if not "%~1"=="" (
    set "maven_repo=%~1"
)
```
然后通过命令行指定路径：
```bat
clean-maven.bat "D:\custom\maven\repo"
```


### 2. check-port.bat（端口占用检查工具）

**使用说明：**
1. 默认检查8080：`check-port.bat`
2. 指定端口：`check-port.bat 3000`
3. 特性：
   - 进程信息展示
   - 二次确认机制
   - 自动处理多个PID
   - 管理员权限提示

---

### 使用前准备（以管理员身份运行CMD）：
```cmd
# 允许执行PowerShell脚本
powershell Set-ExecutionPolicy RemoteSigned -Force

# 创建脚本快捷方式（可选）
copy check-port.bat "%SystemRoot%\system32\"
copy clean-maven.ps1 "%USERPROFILE%\scripts\"
```

### 高级使用技巧：
1. **定时清理Maven仓库**：
   ```powershell
   # 创建计划任务（管理员权限）
   $trigger = New-JobTrigger -Daily -At 3am
   Register-ScheduledJob -Name "MavenCleanup" -FilePath "clean-maven.ps1" -Trigger $trigger
   ```

2. **端口检查工具增强**：
   ```bat
   :: 组合使用示例（检查端口并启动服务）
   check-port.bat 8080 && start my-service.exe
   ```

3. **跨平台兼容处理**：
   ```powershell
   # 同时支持Linux/Windows的混合脚本
   if ($IsWindows) {
       $mavenPath = "$env:USERPROFILE\.m2\repository"
   } else {
       $mavenPath = "~/.m2/repository"
   }
   ```

---

### 技术要点说明：
| 功能                | Linux实现               | Windows实现                   | 差异处理方案               |
|---------------------|-------------------------|-------------------------------|---------------------------|
| 路径处理            | ~扩展                  | 环境变量替换                  | 自动转换路径格式          |
| 文件查找            | find命令               | Get-ChildItem                | 统一递归搜索逻辑          |
| 进程终止            | kill命令               | taskkill命令                 | 错误代码兼容处理          |
| 参数验证            | 正则匹配               | 批处理格式检查               | 输入过滤机制              |
| 管理员权限          | sudo                   | UAC弹窗/右键管理员运行       | 显式提示用户              |

---

### 常见问题解决：
**Q1：clean-maven.ps1无法执行**
```powershell
# 临时解决方案：
powershell -ExecutionPolicy Bypass -File clean-maven.ps1

# 永久解决方案（管理员运行）：
Set-ExecutionPolicy RemoteSigned
```

**Q2：端口检查显示占用但无法终止**
```bat
:: 使用管理员权限运行
右键点击CMD/Powershell图标 -> 以管理员身份运行
```

**Q3：处理带空格的Maven路径**
```powershell
# 使用双引号包裹路径参数
.\clean-maven.ps1 -mavenRepo "C:\Program Files\maven repo"
```

**Q4：需要同时处理多个端口**
```bat
:: 使用循环处理多个端口
for %%p in (8080 3000 3306) do (
    check-port.bat %%p
)
```