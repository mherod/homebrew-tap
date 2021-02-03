class Resharkercli < Formula
  VERSION = "0.0.4"
  desc "A combined Git and Jira CLI written for Kotlin/Native and JVM 🦈"
  homepage ""
  version VERSION
  url "https://github.com/mherod/resharkercli/archive/#{VERSION}.tar.gz"
  license ""
  head "https://github.com/mherod/resharkercli.git"

  bottle do
    root_url "https://github.com/mherod/resharkercli/releases/download/0.0.4"
    cellar :any_skip_relocation
    sha256 "00a9c3d4fce642247ffdb5bd49cbb9f588e9475a3973ab0da887023c2dd552a1" => :catalina
    sha256 "1683bc6a62f2633cfed1c38c1969a05276f0bed5705c9f0f23036345aadcc64f" => :big_sur

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
