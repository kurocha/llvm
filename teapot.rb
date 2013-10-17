
#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

teapot_version "0.8.0"

define_target "llvm" do |target|
	target.build do |environment|
		build_external(package.path, "llvm-3.3", environment) do |config, fresh|
			python_path = `which python2.7`.chomp
			
			FileUtils.mkdir("build")
			
			FileUtils.chdir("build") do
				Commands.run("cmake", "-G", "Unix Makefiles",
					"-DCMAKE_INSTALL_PREFIX:PATH=#{config.install_prefix}",
					"-DCMAKE_PREFIX_PATH=#{config.install_prefix}",
					"-DCMAKE_CXX_COMPILER_WORKS=TRUE",
					"-DCMAKE_C_COMPILER_WORKS=TRUE",
					"-DBUILD_SHARED_LIBS=OFF",
					"-DPYTHON_EXECUTABLE=#{python_path}",
					"../"
				) if fresh
			
				Commands.make
				Commands.make_install
			end
		end
	end
	
	target.depends :platform
	target.depends "Language/C++11"
	
	target.provides "Library/llvm-engine" do
		# llvm-config --libs engine
		append linkflags %W{-lLLVMX86Disassembler -lLLVMX86AsmParser -lLLVMX86CodeGen -lLLVMSelectionDAG -lLLVMAsmPrinter -lLLVMMCParser -lLLVMX86Desc -lLLVMX86Info -lLLVMX86AsmPrinter -lLLVMX86Utils -lLLVMJIT -lLLVMRuntimeDyld -lLLVMExecutionEngine -lLLVMCodeGen -lLLVMObjCARCOpts -lLLVMScalarOpts -lLLVMInstCombine -lLLVMTransformUtils -lLLVMipa -lLLVMAnalysis -lLLVMTarget -lLLVMMC -lLLVMObject -lLLVMCore -lLLVMSupport}
	end
end

define_configuration "local" do |configuration|
	configuration[:source] = "https://github.com/dream-framework/"
	
	configuration.import "llvm"
end

define_configuration "llvm" do |configuration|
	configuration.public!
	
	configuration.require "platforms"
end
