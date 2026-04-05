class Ccmeter < Formula
  desc "A meter for Claude Code usage"
  homepage "https://github.com/hmenzagh/CCMeter"
  version "1.1.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/hmenzagh/CCMeter/releases/download/v1.1.0/ccmeter-aarch64-apple-darwin.tar.xz"
    sha256 "710873b59728c6e321535a2be8b5dff913372ac242f91e6cb443c7e25fd140ff"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hmenzagh/CCMeter/releases/download/v1.1.0/ccmeter-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3386f81daf1f13594570ae8714c55160504d781daac6a572b33b6d829103af25"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hmenzagh/CCMeter/releases/download/v1.1.0/ccmeter-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4d9647066f93b04ab141bf2979ee8f3b27c9c26b6650a9707ccd2ae53abd80f0"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "ccmeter" if OS.mac? && Hardware::CPU.arm?
    bin.install "ccmeter" if OS.linux? && Hardware::CPU.arm?
    bin.install "ccmeter" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
