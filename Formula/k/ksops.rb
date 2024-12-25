class Ksops < Formula
  desc "Flexible Kustomize Plugin for SOPS Encrypted Resources"
  homepage "https://github.com/viaduct-ai/kustomize-sops"
  url "https://github.com/viaduct-ai/kustomize-sops/archive/refs/tags/v4.3.3.tar.gz"
  sha256 "a843b5bbb036027c72bc37fce29135362b8a13e58e6d53a760ed0b7dbe8fe66b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f604e40fd467bb4d15cc7276fefe05377c058a834f65207f517eebd6eae63617"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "750543395b6a58066887ebc207765a51608d6afa405e2cef7a25b5521d701d37"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46bfb57914bba8ebd9d5626b3e81a07a38a31332ac3663b5dba3fe75ee1c241b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "917914ce6ae88b4d6faca79f4029e686116f4d2e1dee6ef6eff7df431ab0cde1"
    sha256 cellar: :any_skip_relocation, sonoma:         "d9526c8e45e55c2f1df491da6084f9647217cb0a55fdc2e5f16cc060f21ea967"
    sha256 cellar: :any_skip_relocation, ventura:        "c6c2bc9323c138b7b62b9d0f6c6e1c27c46257865911bbaa0c07bcef6b04f34a"
    sha256 cellar: :any_skip_relocation, monterey:       "565566b015d4db7bf8999e23e2cb8d20e32ef9544b2dfa03972b4526e41cdb00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b893fe3b568ba5cc18d82b317fae1b710aa9ea418749d47fd5918ab1e6e44f22"
  end

  depends_on "go" => :build

  # update go.mod, upstream pr ref, https://github.com/viaduct-ai/kustomize-sops/pull/269
  patch do
    url "https://github.com/viaduct-ai/kustomize-sops/commit/feb0eae92c10c1e248928be55f6577f28b6468a8.patch?full_index=1"
    sha256 "a9dbae051b35f209bb64bf783f3d2c36f6b26cd395abe3d92dbbd996793a965d"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"secret-generator.yaml").write <<~YAML
      apiVersion: viaduct.ai/v1
      kind: ksops
      metadata:
        name: secret-generator
        annotations:
          config.kubernetes.io/function: |
            exec:
              path: ksops
      files: []
    YAML

    system bin/"ksops", testpath/"secret-generator.yaml"
  end
end
