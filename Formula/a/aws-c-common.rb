class AwsCCommon < Formula
  desc "Core c99 package for AWS SDK for C"
  homepage "https://github.com/awslabs/aws-c-common"
  url "https://github.com/awslabs/aws-c-common/archive/refs/tags/v0.10.4.tar.gz"
  sha256 "72ebf3cfe105d74af8f43ccd07d33a0ecf881dba1caa2ddeaaf1fa1c5f9794f8"
  license "Apache-2.0"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <aws/common/uuid.h>
      #include <aws/common/byte_buf.h>
      #include <aws/common/error.h>
      #include <assert.h>

      int main(void) {
        struct aws_uuid uuid;
        assert(AWS_OP_SUCCESS == aws_uuid_init(&uuid));

        uint8_t uuid_array[AWS_UUID_STR_LEN] = {0};
        struct aws_byte_buf uuid_buf = aws_byte_buf_from_array(uuid_array, sizeof(uuid_array));
        uuid_buf.len = 0;

        assert(AWS_OP_SUCCESS == aws_uuid_to_str(&uuid, &uuid_buf));
        uint8_t zerod_buf[AWS_UUID_STR_LEN] = {0};
        assert(AWS_UUID_STR_LEN - 1 == uuid_buf.len);
        assert(0 != memcmp(zerod_buf, uuid_array, sizeof(uuid_array)));

        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-laws-c-common"
    system "./test"
  end
end
