class Resharkercli < Formula
  VERSION = "0.0.3"
  desc "A combined Git and Jira CLI written for Kotlin/Native and JVM 🦈"
  homepage ""
  version VERSION
  url "https://github.com/mherod/resharkercli/archive/#{VERSION}.tar.gz"
  sha256 "5cb86d682a8f5b5aea58bad31e434b5f993a683cc640774db6447b18ec0f9653"
  license ""
  head "https://github.com/mherod/resharkercli.git"

  bottle do
    root_url "https://github.com/mherod/resharkercli/releases/download/0.0.3"
    cellar :any_skip_relocation
    sha256 "e55a696354d8b4dd1eb9806327d3fefb9f07221b275bbbc44cc063838e08441c" => :big_sur
    sha256 "2323513ac1c8f97564e80e45afb285e8310ef6d929d0f15d9bc33c01c6f6ded7" => :catalina
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
