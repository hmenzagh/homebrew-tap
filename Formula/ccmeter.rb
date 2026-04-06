class Ccmeter < Formula
  desc "A meter for Claude Code usage"
  homepage "https://github.com/hmenzagh/CCMeter"
  version "1.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hmenzagh/CCMeter/releases/download/v1.3.0/ccmeter-aarch64-apple-darwin.tar.xz"
      sha256 "dbdca6f84d571c05209604ba426670eb7f1edce9558c663149448ade697a9d4d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hmenzagh/CCMeter/releases/download/v1.3.0/ccmeter-x86_64-apple-darwin.tar.xz"
      sha256 "caed373c195b0cb72dfadbda7e774b232044f98a94c39207cff1a37f76b48247"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hmenzagh/CCMeter/releases/download/v1.3.0/ccmeter-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "498426c6ccc1decbeaee72fdc8f0de1326b27deb5d88e4c650c9c9bf0c06ebdf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hmenzagh/CCMeter/releases/download/v1.3.0/ccmeter-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4fd5efba40b56eff78e082b7b940e24f78f5a835cc417920ab50008b38d749ad"
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
