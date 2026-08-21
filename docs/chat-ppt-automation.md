# ChatGPT 대화 → slide-master 자동 실행

이 저장소는 ChatGPT 대화에서 PPT 요청을 받아 GitHub Issues + GitHub Actions + OpenAI Codex Action을 통해 `slide-master`를 실행하는 2단계 자동화 구조를 지원합니다.

## 왜 2단계인가

`ppt-master`의 메인 SVG 워크플로우에는 전략/디자인 확인 단계가 BLOCKING gate로 정의되어 있습니다. 따라서 완전 무인 실행으로 건너뛰지 않고 다음처럼 진행합니다.

1. ChatGPT가 `[PPT-PLAN]` 이슈 생성
2. `PPT Plan` workflow가 slide-master 규칙에 따라 전략안을 작성하고 이슈 댓글로 반환
3. ChatGPT가 사용자에게 전략안을 보여주고 명시적 승인을 받음
4. ChatGPT가 원 요청 + 승인 내용을 포함한 `[PPT-RUN]` 이슈 생성
5. `PPT Generate` workflow가 slide-master를 끝까지 실행
6. 최종 PPTX와 검증 렌더를 GitHub Actions artifact로 업로드
7. ChatGPT가 workflow artifact를 내려받아 사용자에게 전달

## 필수 1회 설정

Repository Settings → Secrets and variables → Actions → New repository secret

- Name: `OPENAI_API_KEY`
- Value: OpenAI API key

`openai/codex-action@v1`은 현재 GitHub Actions에서 별도의 OpenAI API key secret을 필요로 합니다. ChatGPT Plus 구독 또는 Codespaces의 대화형 `codex login` 인증은 GitHub-hosted Actions의 무인 실행 인증을 대신하지 않습니다.

## 보안

- 두 workflow 모두 `github.actor == 'tactics83'` 조건을 사용합니다.
- Codex Action도 기본적으로 저장소 write 권한이 있는 사용자만 실행할 수 있습니다.
- Codex는 `permission-profile: ':workspace'`로 저장소 작업공간 안에서만 파일 쓰기가 허용되며 일반 네트워크 접근은 허용하지 않습니다.
- OpenAI API key는 workflow shell 환경변수로 직접 노출하지 않고 `openai/codex-action`의 전용 secret 입력을 사용합니다.

## 파일 입력

ChatGPT 대화에 첨부된 PDF/DOCX/PPTX/XLSX 등의 파일이 PPT 생성에 필요하면, ChatGPT가 해당 파일을 이 저장소의 작업용 경로에 먼저 커밋한 뒤 이슈 본문에 정확한 repository path를 기록하는 방식으로 전달할 수 있습니다.

## 출력

Generation workflow의 결과는 Actions artifact로 저장됩니다.

Artifact name:

`slide-master-ppt-<issue number>`

주요 포함 경로:

- `projects/**/exports/*.pptx`
- `projects/**/_pptx_render/**`

기본 보관기간은 30일입니다.
