class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  # Bump to php 8.4 on the next release, if possible.
  url "https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/download/v3.65.0/php-cs-fixer.phar"
  sha256 "e7f00398e696cf49dbb7e67ec219ad920b313084f7143919aba7b1c3afff0c8d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a9de27a9df1fdfb1b3555a6fe04b98a025a1bfb97fe893b39c6067f3a37b18ad"
  end

  depends_on "php@8.3"

  def install
    libexec.install "php-cs-fixer.phar"

    (bin/"php-cs-fixer").write <<~EOS
      #!#{Formula["php@8.3"].opt_bin}/php
      <?php require '#{libexec}/php-cs-fixer.phar';
    EOS
  end

  test do
    (testpath/"test.php").write <<~PHP
      <?php $this->foo(   'homebrew rox'   );
    PHP
    (testpath/"correct_test.php").write <<~PHP
      <?php

      $this->foo('homebrew rox');
    PHP

    system bin/"php-cs-fixer", "fix", "test.php"
    assert compare_file("test.php", "correct_test.php")
  end
end
