# GitHub Codespaces 사용법

이 저장소는 GitHub Codespaces에서 `slide-master` + Codex CLI 조합으로 바로 사용할 수 있도록 구성되어 있습니다.

## 1. Codespace 생성

GitHub 저장소 페이지에서 **Code → Codespaces → Create codespace on main** 을 선택합니다.

처음 생성할 때 `.devcontainer/devcontainer.json`의 설정에 따라 다음 항목이 자동 설치됩니다.

- Python 3.12
- 저장소 `requirements.txt` 의존성
- Node.js 22
- Codex CLI (`@openai/codex`)
- OfficeCLI 1.0.135
- Pandoc
- LibreOffice
- Noto CJK fonts

## 2. Codex 로그인

Codespace 터미널에서 다음을 실행합니다.

```bash
codex login
```

로그인이 완료되면 저장소 루트에서 `codex`를 실행합니다.

```bash
codex
```

이 저장소의 `AGENTS.md`와 `.codex/skills/`가 Codex 실행 규칙과 slide-master 스킬을 제공합니다.

## 3. PPT 자료 넣기

예를 들어 프로젝트 이름을 `psm`으로 할 경우:

```bash
mkdir -p projects/psm/sources
```

VS Code 탐색기에서 PDF, DOCX, XLSX, PPTX 등의 원본 파일을 `projects/psm/sources/`에 업로드합니다.

## 4. PPT 생성 요청

Codex에 자연어로 요청합니다.

```text
projects/psm/sources/회사소개자료.pdf를 기반으로
고용노동부 PSM 이행상태 평가용 30페이지 PPT를 만들어줘.
핵심 내용은 페이지당 1~2개만 배치하고 가독성을 높여줘.
```

Codex는 `AGENTS.md`의 라우팅 규칙을 읽고 slide-master의 적절한 워크플로우를 선택합니다.

## 5. 생성 결과

일반적으로 결과물은 프로젝트 아래의 `exports/`에 생성됩니다.

```text
projects/<project>/exports/<title>_ver1.pptx
```

Codespaces 파일 탐색기에서 PPTX를 우클릭해 다운로드할 수 있습니다.

## 6. 이미지 생성 API를 사용할 경우

필요하면 GitHub Codespaces secrets에 다음 값을 등록할 수 있습니다.

- `OPENAI_API_KEY`
- `GEMINI_API_KEY`

Codex CLI 자체는 `codex login` 방식으로도 로그인할 수 있습니다.

## 7. 환경 확인

Codespace를 다시 시작할 때 `.devcontainer/post-start.sh`가 Python, Node, Codex, OfficeCLI 버전을 출력합니다.

필요하면 직접 아래 명령으로 확인할 수 있습니다.

```bash
python --version
node --version
codex --version
officecli --version
```

## 주의

GitHub Codespaces는 리눅스 환경이므로 Windows PowerPoint 자체를 사용한 렌더링 검증은 할 수 없습니다. 대신 OfficeCLI의 내장 렌더링 및 저장소의 검증 워크플로우를 사용합니다.
