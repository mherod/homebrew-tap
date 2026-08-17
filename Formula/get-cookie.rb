class GetCookie < Formula
  desc "Query cookies from Chrome, Firefox, Safari, and other browsers"
  homepage "https://github.com/mherod/get-cookie"
  url "https://registry.npmjs.org/@mherod/get-cookie/-/get-cookie-4.4.3.tgz"
  sha256 "f2e822b4a3acbbfbe855e7aa2bb6cb3ca7f486527acf9513dd5e88b4b781d187"
  license "ISC"

  depends_on "python@3.14" => :build
  depends_on "node@24"

  def install
    system "npm", "install", *std_npm_args

    # Homebrew skips dependency install scripts, so build the native SQLite
    # binding explicitly against the Node version provided by this formula.
    better_sqlite3 = libexec/"lib/node_modules/@mherod/get-cookie/node_modules/better-sqlite3"
    cd(better_sqlite3) { system "npm", "run", "build-release" }

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/get-cookie --help")
    assert_match "Usage: get-cookie [name] [domain] [options]", output
    assert_match "--browser BROWSER", output
  end
end
