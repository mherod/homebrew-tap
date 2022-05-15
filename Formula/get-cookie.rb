class GetCookie < Formula
  VERSION = "0.0.2"
  desc "Node.js module for querying a local user's Chrome cookie"
  homepage "https://github.com/mherod/get-cookie.git"
  version VERSION
  url "https://github.com/mherod/get-cookie.git", tag: "v#{VERSION}"
  head "https://github.com/mherod/get-cookie.git"

  depends_on :xcode => ["12.0", :build]
  depends_on "node" => :build

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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
