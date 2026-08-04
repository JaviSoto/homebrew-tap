class AppleNotesCli < Formula
  desc "A fast, scriptable CLI for Apple Notes (read/write + backups)"
  homepage "https://github.com/JaviSoto/apple-notes-cli"
  version "0.1.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/JaviSoto/apple-notes-cli/releases/download/v0.1.2/apple-notes-v0.1.2-aarch64-apple-darwin.tar.gz"
      sha256 "5e4c7f7a335a5b39f6c858f87544a7c5918861a9f653650061d8dd73f191d2b6"
    end

    on_intel do
      url "https://github.com/JaviSoto/apple-notes-cli/releases/download/v0.1.2/apple-notes-v0.1.2-x86_64-apple-darwin.tar.gz"
      sha256 "371d1bb810354b63b0b3f56890a8413f147f28591c78e8e22645c9b8c8a10493"
    end
  end

  def install
    bin.install "apple-notes"
  end

  test do
    assert_match "apple-notes", shell_output("#{bin}/apple-notes --version")
  end
end
