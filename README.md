# BGEE-Hold2Turbo

**BGEE-Hold2Turbo**는 *Baldur's Gate: Enhanced Edition*에서 마우스 측면 버튼을 누르고 있는 동안만 Cheat Engine Speedhack 배속을 켜고, 버튼을 떼면 정상 속도로 되돌리는 개인용 자동화 유틸입니다.

> 버전: `v1.0`  
> 버전 ID: `1`

## 구성

```text
BGEE-Hold2Turbo/
├─ BGEE-Hold2Turbo.ahk
├─ BGEE-Hold2Turbo.ct
├─ README.md
├─ handover-note.md
└─ .gitignore
```

## 필요한 것

- AutoHotkey v2
- Cheat Engine
- Baldur's Gate: Enhanced Edition

## 1회 세팅

### 1. Cheat Engine Speedhack 핫키 설정

Cheat Engine에서 Speedhack 핫키를 다음처럼 설정합니다.

```text
Ctrl + Alt + Shift + 1 → Speedhack 2.0x
Ctrl + Alt + Shift + 2 → Speedhack 1.0x
```

이 프로젝트의 AHK 스크립트는 마우스 측면 버튼을 누를 때 위 핫키를 대신 보내는 방식입니다.

### 2. 파일 배치

`BGEE-Hold2Turbo.ahk`와 `BGEE-Hold2Turbo.ct`를 같은 폴더에 둡니다.

### 3. Cheat Engine 경로 확인

AHK 스크립트는 아래 경로들을 자동으로 찾습니다.

```text
C:\Program Files\Cheat Engine 7.6\cheatengine-x86_64.exe
C:\Program Files\Cheat Engine 7.5\cheatengine-x86_64.exe
C:\Program Files\Cheat Engine 7.4\cheatengine-x86_64.exe
C:\Program Files\Cheat Engine\cheatengine-x86_64.exe
```

자동 탐지가 실패하면 `BGEE-Hold2Turbo.ahk` 안의 `ceExe` 값을 직접 수정하세요.

예시:

```ahk
ceExe := "C:\Program Files\Cheat Engine 7.5\cheatengine-x86_64.exe"
```

### 4. 실행

`BGEE-Hold2Turbo.ahk`를 실행합니다.

이후 흐름은 다음과 같습니다.

```text
AHK 실행
→ BGEE 프로세스 감지
→ BGEE-Hold2Turbo.ct 자동 실행
→ CT 내부 Lua가 Baldur.exe / Baldur64.exe 자동 부착 등록
→ BGEE 창 활성화 중 XButton1 hold 시 2.0x
→ XButton1 release 시 1.0x
```

## 시작프로그램 등록

`BGEE-Hold2Turbo.ahk`의 바로가기를 Windows 시작프로그램 폴더에 넣으면 됩니다.

실행 창에서 아래를 입력하면 시작프로그램 폴더가 열립니다.

```text
shell:startup
```

그 폴더에 `BGEE-Hold2Turbo.ahk` 바로가기를 넣으세요.

## 버튼 바꾸기

기본 버튼은 `XButton1`입니다.

`XButton2`로 바꾸려면 `BGEE-Hold2Turbo.ahk` 맨 아래의 두 줄을 바꾸면 됩니다.

```ahk
XButton1::
XButton1 Up::
```

이렇게 변경:

```ahk
XButton2::
XButton2 Up::
```

## 배속 바꾸기

기본 구조는 다음입니다.

```text
Ctrl + Alt + Shift + 1 → 터보 속도
Ctrl + Alt + Shift + 2 → 정상 속도
```

2.0x 대신 1.5x를 쓰고 싶으면 Cheat Engine 쪽 Speedhack 핫키 설정에서 `Ctrl + Alt + Shift + 1`에 연결된 배속만 1.5x로 바꾸면 됩니다.

## 주의

- 이건 BGEE 모드 파일을 직접 패치하는 WeiDU 모드가 아니라, AHK + Cheat Engine 기반 외부 자동화입니다.
- Cheat Engine의 Lua 실행 확인창이 처음 뜰 수 있습니다.
- BGEE나 Steam을 관리자 권한으로 실행한다면 AHK와 Cheat Engine도 권한을 맞춰야 할 수 있습니다.
- 멀티플레이나 온라인 환경에서는 사용하지 않는 것을 권장합니다.
