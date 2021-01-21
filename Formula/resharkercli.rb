class Resharkercli < Formula
  desc "A combined Git and Jira CLI written for Kotlin/Native and JVM 🦈"
  homepage ""
  version "0.0.1"
  url "https://github.com/mherod/resharkercli/archive/7fd201b.tar.gz"
  sha256 "b91a3000c8ea33233753b5252d02731e005ddf833126fe9f93b727010e926ddf"
  license ""
  
  bottle do
    root_url "https://github.com/mherod/resharkercli/releases/download/0.0.1"
    cellar :any_skip_relocation
    sha256 "de574f393d93ec30a0031316c17bfa062ccfda7a6ab9af62bc1abd5affddba06" => :big_sur
    sha256 "594a7e6579978acfab8c862f060d90bade5905eab1e088250f3e90352dae061d" => :catalina
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