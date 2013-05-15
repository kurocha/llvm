
#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

teapot_version "0.8.0"

define_target "llvm" do |target|
	target.build do |environment|
		build_external(package.path, "llvm-3.3", environment) do |config, fresh|
			python_path = `which python2.7`.chomp
			
			Commands.run("./configure",
				"--prefix=#{config.install_prefix}",
				"--disable-dependency-tracking",
				"--enable-shared=no",
				"--enable-static=yes",
				"--with-python=#{python_path}",
				*config.configure
			) if fresh
			
			Commands.make
			Commands.make_install
		end
	end
	
	target.depends :platform
	target.depends "Language/C++11"
	
	target.provides "Library/llvm" do
		append linkflags ["-lllvm"]
	end
end

define_configuration "llvm" do |configuration|
	configuration[:source] = "https://github.com/dream-framework/"
	
	configuration.import! "platforms"
end