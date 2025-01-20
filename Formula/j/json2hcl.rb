class Json2hcl < Formula
  desc "Convert JSON to HCL, and vice versa"
  homepage "https://github.com/kvz/json2hcl"
  url "https://github.com/kvz/json2hcl/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "ac10155d2d86a196a97e9cfb98e7a66f0b0505dee8904bbd3e32979370b81f34"
  license "MIT"
  head "https://github.com/kvz/json2hcl.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/json2hcl -version")

    (testpath/"input.json").write <<~JSON
      {
        "hello": "world"
      }
    JSON

    assert_equal "\"hello\" = \"world\"", shell_output("#{bin}/json2hcl < input.json")

    (testpath/"input.tf").write <<~HCL
      hello = "world"
    HCL

    assert_equal "{\n  \"hello\": \"world\"\n}", shell_output("#{bin}/json2hcl -reverse < input.tf").chomp
  end
end
