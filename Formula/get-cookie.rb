class GetCookie < Formula
  VERSION = "0.0.1"
  desc "Node.js module for querying a local user's Chrome cookie"
  homepage ""
  version VERSION
  url "https://github.com/mherod/get-cookie/archive/#{VERSION}.tar.gz"
  license ""
  head "https://github.com/mherod/get-cookie.git"

  depends_on :xcode => ["12.0", :build]

  def install
    system "npm", "install""
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
