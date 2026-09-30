cask "session-board" do
  version "0.3.5"
  sha256 "e40b70c108380724b614e78d6db69b5c61328728e92d298f2888b93296489da9"

  url "https://github.com/jongjunpark/session-board/releases/download/v#{version}/SessionBoard.zip"
  name "SessionBoard"
  desc "Floating board of running, waiting and finished Claude Code sessions"
  homepage "https://github.com/jongjunpark/session-board"

  depends_on macos: :sequoia

  app "SessionBoard.app"

  # 자체 서명 앱이라 격리 표시를 떼어 첫 실행 때 보안 경고가 뜨지 않게 한다
  # (Homebrew 7 의 postflight_steps 는 인자에 appdir 를 못 넣어서, 작업 폴더를 /Applications 로 둔다)
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "SessionBoard.app"],
        chdir:          "/Applications",
        writable_base:  :appdir,
        writable_paths: ["SessionBoard.app"]
  end

  uninstall quit: "io.github.jongjunpark.SessionBoard"

  # 완전 제거 때만 Claude Code 설정에서 훅을 뺀다 (업데이트 때는 빼지 않도록 uninstall 이 아니라 zap 에 둔다)
  zap script: {
        executable:   "#{Dir.home}/.claude/session-board/bin/uninstall-hooks.sh",
        must_succeed: false,
      },
      trash:  [
        "~/.claude/session-board",
        "~/Library/Preferences/io.github.jongjunpark.SessionBoard.plist",
      ]
end
