class Resharkercli < Formula
  desc "Git and Jira CLI written for Kotlin/Native and JVM"
  homepage "https://github.com/mherod/resharkercli"
  url "https://github.com/mherod/resharkercli/archive/refs/tags/0.0.5.tar.gz"
  sha256 "53c5dd7209314d3d6c1156e88bc01fe1bbf7a4ab982a941392856ca006472e24"
  head "https://github.com/mherod/resharkercli.git"

  disable! date: "2026-08-17", because: "requires an obsolete Intel-only toolchain and has no upstream license"

  depends_on xcode: ["12.0", :build]

  def install
    system "./gradlew", "installBrewBinary", "--info"
  end
end
