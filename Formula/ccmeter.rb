class Ccmeter < Formula
  desc "A meter for Claude Code usage"
  homepage "https://github.com/hmenzagh/CCMeter"
  version "1.0.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/hmenzagh/CCMeter/releases/download/v1.0.0/ccmeter-aarch64-apple-darwin.tar.xz"
    sha256 "5073e9bbf88a60edde042925a4ba1ef3f495b46adda4e97927ba6d4f71bc0a8b"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hmenzagh/CCMeter/releases/download/v1.0.0/ccmeter-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "de8ffc3fac6d6e3c131eef7827be756cd4416087b10a0fb4b96e4f9291b47b34"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hmenzagh/CCMeter/releases/download/v1.0.0/ccmeter-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d52cb82be0e1a6b18aea2d8481547fd766349bc10c67de91e48d2df639a7e235"
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
