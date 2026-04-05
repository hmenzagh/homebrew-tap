class Ccmeter < Formula
  desc "A meter for Claude Code usage"
  homepage "https://github.com/hmenzagh/CCMeter"
  version "1.2.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/hmenzagh/CCMeter/releases/download/v1.2.0/ccmeter-aarch64-apple-darwin.tar.xz"
    sha256 "039904ce8b5207400b20a66bb6af1b5da962dc3514e2113cf38906d69d538894"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hmenzagh/CCMeter/releases/download/v1.2.0/ccmeter-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "eb079d2b4c09189af753c8df7a0a75f4b271ded968af7a9cd3af33166267b77b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hmenzagh/CCMeter/releases/download/v1.2.0/ccmeter-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "46d323ec47605853582cb576c46d010b4a98b675d3e5d21726b53dfdb6c1c885"
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
