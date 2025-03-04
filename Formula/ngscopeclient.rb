class Ngscopeclient < Formula
  desc "Advanced test and measurement instrument remote control and analysis suite"
  homepage "https://www.ngscopeclient.org/"
  license "BSD-3-Clause"
  head "https://github.com/ngscopeclient/scopehal-apps.git"

  depends_on "cmake" => :build
  depends_on "shaderc" => :build
  depends_on "vulkan-headers" => :build

  depends_on "catch2"
  depends_on "glfw"
  depends_on "glslang"
  depends_on "libomp"
  depends_on "pkg-config"
  depends_on "spirv-tools"
  depends_on "vulkan-loader"
  depends_on "yaml-cpp"
  depends_on "libsigc++"
  depends_on "hidapi"

  on_macos do
    depends_on "molten-vk"
  end

  def install
    # Find the path to the Vulkan loader library, which we need in our RPATH
    # for Vulkan to be able to load correctly. #688
    vulkan_loader_lib = "#{Formula["vulkan-loader"].opt_prefix}/lib"

    # Patch plugin enumeration code to fix #393, #623
    inreplace "lib/scopehal/scopehal.cpp",
      'if(binDir.find("/usr") != 0)',
      "if(binDir.find(\"#{HOMEBREW_PREFIX}\") != 0)"

    # Patch search paths for Homebrew prefix #624
    inreplace "lib/scopehal/scopehal.cpp",
      'g_searchPaths.push_back(binRootDir + "/share/ngscopeclient");',
      'g_searchPaths.push_back(binRootDir + "/../share/ngscopeclient");'

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_DOCS=NO",
      "-DCMAKE_INSTALL_RPATH=#{rpath};#{vulkan_loader_lib}",
      *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      extern const char* ScopehalGetVersion();
      int main() {
        const char* version = ScopehalGetVersion();
        return version == nullptr || version[0] == '\\0';
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{lib}", "-lscopehal"
    system "./a.out"
  end
end
