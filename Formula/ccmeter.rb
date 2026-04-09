class Ccmeter < Formula
  desc "A meter for Claude Code usage"
  homepage "https://github.com/hmenzagh/CCMeter"
  version "1.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hmenzagh/CCMeter/releases/download/v1.4.1/ccmeter-aarch64-apple-darwin.tar.xz"
      sha256 "5830cdeb29af1ee5651b155d1f5eba6738a04357925acab4b21691c581d7de7b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hmenzagh/CCMeter/releases/download/v1.4.1/ccmeter-x86_64-apple-darwin.tar.xz"
      sha256 "69cb34fe8ced3d9b2ff4d8f9cde360e5645cedb6701b4397d8056420f498580e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hmenzagh/CCMeter/releases/download/v1.4.1/ccmeter-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5656a963e66f564d8bf4a04baf0608ece35bea11dd3cb8f9e783224d5874cd66"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hmenzagh/CCMeter/releases/download/v1.4.1/ccmeter-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2f7e3de4113ca3c502bb97e405e8ebd9d15bdf73e04e3ad550f054220a696d82"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
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
    bin.install "ccmeter" if OS.mac? && Hardware::CPU.intel?
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
