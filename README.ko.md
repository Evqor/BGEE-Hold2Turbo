# BGEE-Hold2Turbo

[English README](README.md)

**BGEE-Hold2Turbo**는 *Baldur's Gate: Enhanced Edition* 실행을 감지해 포함된 Cheat Engine 테이블을 자동으로 열고, 게임이 종료되면 이 스크립트가 실행한 Cheat Engine 프로세스도 함께 닫아주는 작은 보조 유틸입니다.

BGEE 게임 파일을 직접 패치하지 않습니다. 대신 **AutoHotkey v2**와 **Cheat Engine**을 함께 사용합니다.

- AutoHotkey는 `Baldur.exe` / `Baldur64.exe`를 감지하고, 게임 창이 준비되면 포함된 Cheat Engine 테이블을 엽니다.
- Cheat Engine 테이블은 BGEE 자동 부착 항목을 준비합니다.
- 실제 Speedhack 동작은 Cheat Engine이 처리합니다.

누르고 있을 키나 터보 배속을 바꾸고 싶다면 Cheat Engine의 핫키 설정을 사용하세요.

싱글플레이/오프라인 환경에서 사용하세요. 멀티플레이나 온라인 환경에서는 사용하지 않는 것을 권장합니다.

## 요구 사항

- Baldur's Gate: Enhanced Edition
- AutoHotkey v2
- Cheat Engine

## 설정

### 1. Cheat Engine Speedhack 설정

Cheat Engine을 열고 Speedhack 핫키를 설정합니다.

예시 설정:

```text
Hotkey: XButton1 또는 F9 같은 원하는 홀드 키
Speed: 2.0x
Stop on release: enabled
```

처음 한 번 Cheat Engine이 BGEE에 자동으로 붙지 못한다면, Cheat Engine에서 BGEE 프로세스를 직접 선택해야 할 수도 있습니다.

Cheat Engine에서 테이블에 Lua 코드가 포함되어 있으며 언제 실행할지 묻는 안내창이 뜨면 **Always**를 선택하고 **Yes**를 누르세요. 이렇게 하면 테이블의 자동 부착 스크립트가 자동으로 실행되며, 같은 테이블에서는 해당 안내창이 다시 뜨지 않을 가능성이 높습니다.

### 2. 파일을 같은 폴더에 두기

다음 파일들을 같은 폴더에 둡니다.

```text
BGEE-Hold2Turbo.ahk
BGEE-Hold2Turbo.ct
settings.ini.example
```

`settings.ini`는 첫 실행 시 자동으로 생성됩니다. 업데이트할 때 사용자 설정이 덮어씌워지지 않도록 릴리즈 파일에는 직접 포함하지 않습니다.

### 3. Cheat Engine 경로 확인

스크립트는 아래와 같은 일반적인 Cheat Engine 설치 경로를 자동으로 확인합니다.

```text
C:\Program Files\Cheat Engine 7.6\cheatengine-x86_64.exe
C:\Program Files\Cheat Engine 7.5\cheatengine-x86_64.exe
C:\Program Files\Cheat Engine 7.4\cheatengine-x86_64.exe
C:\Program Files\Cheat Engine\cheatengine-x86_64.exe
```

자동 탐지가 실패하면 `settings.ini`를 열고 `CheatEngineExe` 값을 직접 지정하세요.

예시:

```ini
[Paths]
CheatEngineExe=C:\Program Files\Cheat Engine 7.5\cheatengine-x86_64.exe
```

### 4. 선택 설정

설정은 `settings.ini`에 저장됩니다.

기본적으로 BGEE-Hold2Turbo는 BGEE 프로세스와 게임 창이 감지되면 바로 Cheat Engine 테이블을 엽니다.

자동 테이블 로드 중 오류가 발생한다면 시작 지연을 켜서 사용해보세요.

```ini
[General]
UseOpenTableDelay=true
OpenTableDelayMs=3000
```

Cheat Engine 테이블이 자동으로 열렸는지 쉽게 확인하고 싶다면 attach 알림을 켜세요.

```ini
[Notifications]
AttachNotify=true
```

기본적으로 일반 테이블 열림 알림과 Cheat Engine 종료 알림은 꺼져 있고, 시작 경고 알림은 켜져 있습니다.

### 5. 실행

다음 파일을 실행합니다.

```text
BGEE-Hold2Turbo.ahk
```

그다음 BGEE를 실행합니다. 스크립트는 BGEE 프로세스와 게임 창이 준비될 때까지 기다린 뒤 Cheat Engine 테이블을 엽니다.

예상 동작:

```text
AHK 실행
→ settings.ini가 없으면 자동 생성
→ BGEE 프로세스 감지
→ BGEE 창 감지
→ BGEE-Hold2Turbo.ct가 Cheat Engine으로 열림
→ Cheat Engine이 BGEE에 부착됨
→ Cheat Engine에서 설정한 Speedhack 홀드 키 사용
→ BGEE 종료 시 이 스크립트가 실행한 Cheat Engine 프로세스도 종료됨
```

## 로그

BGEE-Hold2Turbo는 기본적으로 간단한 실행 로그를 남깁니다.

```text
logs\BGEE-Hold2Turbo.log
```

로그에는 헬퍼 시작, BGEE 감지, Cheat Engine 테이블 열기, Cheat Engine 종료, 주요 경로 오류 등이 기록됩니다.

로그가 설정된 크기를 넘으면 기존 로그는 아래 파일로 이동됩니다.

```text
logs\BGEE-Hold2Turbo.log.old
```

로그 설정은 `settings.ini`에서 바꿀 수 있습니다.

```ini
[Logging]
EnableLog=true
LogPath=logs\BGEE-Hold2Turbo.log
MaxLogSizeKB=512
```

## Windows 시작 시 자동 실행

Windows 시작 시 스크립트를 자동으로 실행하려면:

1. `Win + R`을 누릅니다.
2. 아래 내용을 입력합니다.

```text
shell:startup
```

3. 열린 폴더에 `BGEE-Hold2Turbo.ahk` 바로가기를 넣습니다.

## 업데이트

최신 릴리즈 압축 파일을 다운로드한 뒤 기존 헬퍼 파일 위에 덮어씌우세요.

로컬 `settings.ini`와 `logs` 폴더는 릴리즈 압축 파일에 포함하지 않으므로, 업데이트해도 사용자 설정과 로그가 덮어씌워지지 않습니다.

## 참고

- BGEE 또는 Steam이 관리자 권한으로 실행 중이라면 AutoHotkey와 Cheat Engine도 권한을 맞춰야 할 수 있습니다.
- 너무 높은 Speedhack 배속은 입력 타이밍이나 스크립트 이벤트를 불안정하게 만들 수 있습니다.
- 시작 지연을 켜도 작동하지 않는다면 BGEE 실행 파일 이름, Cheat Engine 버전, AutoHotkey 버전, 관련 로그 파일을 포함해 issue를 열어주세요.
