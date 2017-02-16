class Pymol3 < Formula
  desc "OpenGL based molecular visualization system"
  homepage "http://pymol.org"
  url "https://downloads.sourceforge.net/project/pymol/pymol/1.8/pymol-v1.8.4.0.tar.bz2"
  sha256 "b6147befe74844dd23550461b831b2fa6d170d4456f0059cf93fb1e8cb43d279"
  head "https://svn.code.sf.net/p/pymol/code/trunk/pymol"

  bottle do
    cellar :any
    sha256 "0fa0705a99781f94a1178110e8398caa2c5f47a1c3618c966cd558fe5c0e53bb" => :el_capitan
    sha256 "8fc26c4981fb1b503c22d2513d926a15ef7c33abe4a8b1d53cf546c5b7e9c3b6" => :yosemite
    sha256 "417e7c64a6a55057c3e2aa396be60e6c8b305f7ec83d2fa2ad845a4590ca4f14" => :mavericks
  end

  depends_on "glew"
  depends_on "python3" => "with-tcl-tk"
  depends_on "homebrew/dupes/tcl-tk" => ["with-threads", "with-x11"]
  depends_on :x11
  patch :DATA

  resource "Pmw" do
    url "https://files.pythonhosted.org/packages/e7/20/8d0c4ba96a5fe62e1bcf2b8a212ccfecd67ad951e8f3e89cf147d63952aa/Pmw-2.0.1.tar.gz"
    sha256 "0b9d28f52755a7a081b44591c3dd912054f896e56c9a627db4dd228306ad1120"
  end

  def install
    ENV.append_to_cflags "-Qunused-arguments" if MacOS.version < :mavericks
    ENV.prepend_create_path "PYTHONPATH", "#{libexec}/python3.6/site-packages"
    resource("Pmw").stage { system "python3", "setup.py", "install", "--prefix=#{libexec}" }
    system "python3", "-s", "setup.py", "install",
                     "--install-scripts=#{libexec}/bin",
                     "--install-lib=#{libexec}/lib/python3.6/site-packages"

    bin.install libexec/"bin/pymol3"
  end

  def caveats; <<-EOS.undent
    On some Macs, the graphics drivers do not properly support stereo
    graphics. This will cause visual glitches and shaking that stay
    visible until X11 is completely closed. This may even require
    restarting your computer. Launch explicitly in Mono mode using:
      pymol -M
    EOS
  end

  test do
    system bin/"pymol3", libexec/"lib/python3.6/site-packages/pymol3/pymol_path/data/demo/pept.pdb"
  end
end
__END__
diff --git a/setup.py b/setup.py
index 0b6161f..61fb030 100644
--- a/setup.py
+++ b/setup.py
@@ -62,7 +62,7 @@ class install_pymol(install):
     def finalize_options(self):
         install.finalize_options(self)
         if self.pymol_path is None:
-            self.pymol_path = os.path.join(self.install_libbase, 'pymol', 'pymol_path')
+            self.pymol_path = os.path.join(self.install_libbase, 'pymol3', 'pymol_path')
         elif self.root is not None:
             self.pymol_path = change_root(self.root, self.pymol_path)
 
@@ -107,7 +107,7 @@ class install_pymol(install):
         if sys.platform.startswith('win'):
            launch_script = 'pymol.bat'
         else:
-           launch_script = 'pymol'
+           launch_script = 'pymol3'
 
         self.mkpath(self.install_scripts)
         launch_script = os.path.join(self.install_scripts, launch_script)

