
#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

teapot_version "1.0.0"

define_target "llvm" do |target|
	target.build do
		source_files = Files::Directory.join(target.package.path, 'llvm')
		cache_prefix = Files::Directory.join(environment[:build_prefix], "llvm-#{environment.checksum}")
		package_files = Path.join(environment[:install_prefix], "share/llvm/cmake/LLVMConfig.cmake")
		
		python_path = `which python2.7`.chomp
		
		cmake source: source_files, build_prefix: cache_prefix, arguments: [
			"-DCMAKE_CXX_COMPILER_WORKS=TRUE",
			"-DCMAKE_C_COMPILER_WORKS=TRUE",
			"-DBUILD_SHARED_LIBS=OFF",
			"-DPYTHON_EXECUTABLE=#{python_path}",
		]
		
		make prefix: cache_prefix, package_files: package_files
	end
	
	target.depends :platform
	target.depends "Language/C++11"
	
	target.depends "Build/Make"
	target.depends "Build/CMake"
	
	target.provides "Library/llvm-engine" do
		# llvm-config --libs engine
		append linkflags %W{-lLLVMX86Disassembler -lLLVMX86AsmParser -lLLVMX86CodeGen -lLLVMSelectionDAG -lLLVMAsmPrinter -lLLVMMCParser -lLLVMX86Desc -lLLVMX86Info -lLLVMX86AsmPrinter -lLLVMX86Utils -lLLVMJIT -lLLVMRuntimeDyld -lLLVMExecutionEngine -lLLVMCodeGen -lLLVMObjCARCOpts -lLLVMScalarOpts -lLLVMInstCombine -lLLVMTransformUtils -lLLVMipa -lLLVMAnalysis -lLLVMTarget -lLLVMMC -lLLVMObject -lLLVMCore -lLLVMSupport}
	end
end

define_configuration "local" do |configuration|
	configuration[:source] = "https://github.com/kurocha/"
	
	configuration.import "llvm"
end

define_configuration "llvm" do |configuration|
	configuration.public!
	
	configuration.require "platforms"
	
	configuration.require "build-make"
	configuration.require "build-cmake"
end
