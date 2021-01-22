class Resharkercli < Formula
  desc "A combined Git and Jira CLI written for Kotlin/Native and JVM 🦈"
  homepage ""
  version "0.0.2"
  url "https://github.com/mherod/resharkercli/archive/0.0.2.tar.gz"
  sha256 "5f75508af012a6bde56c5adb4ba1fe238a684d560404386c64649d9da142ffb0"
  license ""

  bottle do
    cellar :any_skip_relocation
  end

  depends_on :xcode => ["12.0", :build]

  def install
    system "./gradlew", "installBrewBinary"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test resharkercli`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end