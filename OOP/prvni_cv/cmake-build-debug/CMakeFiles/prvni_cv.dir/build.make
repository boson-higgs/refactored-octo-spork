# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.17

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Disable VCS-based implicit rules.
% : %,v


# Disable VCS-based implicit rules.
% : RCS/%


# Disable VCS-based implicit rules.
% : RCS/%,v


# Disable VCS-based implicit rules.
% : SCCS/s.%


# Disable VCS-based implicit rules.
% : s.%


.SUFFIXES: .hpux_make_needs_suffix_list


# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /Applications/CLion.app/Contents/bin/cmake/mac/bin/cmake

# The command to remove a file.
RM = /Applications/CLion.app/Contents/bin/cmake/mac/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/koyaanisqatsi/CLionProjects/prvni_cv

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/koyaanisqatsi/CLionProjects/prvni_cv/cmake-build-debug

# Include any dependencies generated for this target.
include CMakeFiles/prvni_cv.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/prvni_cv.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/prvni_cv.dir/flags.make

CMakeFiles/prvni_cv.dir/main.cpp.o: CMakeFiles/prvni_cv.dir/flags.make
CMakeFiles/prvni_cv.dir/main.cpp.o: ../main.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/koyaanisqatsi/CLionProjects/prvni_cv/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/prvni_cv.dir/main.cpp.o"
	/Library/Developer/CommandLineTools/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/prvni_cv.dir/main.cpp.o -c /Users/koyaanisqatsi/CLionProjects/prvni_cv/main.cpp

CMakeFiles/prvni_cv.dir/main.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/prvni_cv.dir/main.cpp.i"
	/Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/koyaanisqatsi/CLionProjects/prvni_cv/main.cpp > CMakeFiles/prvni_cv.dir/main.cpp.i

CMakeFiles/prvni_cv.dir/main.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/prvni_cv.dir/main.cpp.s"
	/Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/koyaanisqatsi/CLionProjects/prvni_cv/main.cpp -o CMakeFiles/prvni_cv.dir/main.cpp.s

# Object files for target prvni_cv
prvni_cv_OBJECTS = \
"CMakeFiles/prvni_cv.dir/main.cpp.o"

# External object files for target prvni_cv
prvni_cv_EXTERNAL_OBJECTS =

prvni_cv: CMakeFiles/prvni_cv.dir/main.cpp.o
prvni_cv: CMakeFiles/prvni_cv.dir/build.make
prvni_cv: CMakeFiles/prvni_cv.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/koyaanisqatsi/CLionProjects/prvni_cv/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable prvni_cv"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/prvni_cv.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/prvni_cv.dir/build: prvni_cv

.PHONY : CMakeFiles/prvni_cv.dir/build

CMakeFiles/prvni_cv.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/prvni_cv.dir/cmake_clean.cmake
.PHONY : CMakeFiles/prvni_cv.dir/clean

CMakeFiles/prvni_cv.dir/depend:
	cd /Users/koyaanisqatsi/CLionProjects/prvni_cv/cmake-build-debug && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/koyaanisqatsi/CLionProjects/prvni_cv /Users/koyaanisqatsi/CLionProjects/prvni_cv /Users/koyaanisqatsi/CLionProjects/prvni_cv/cmake-build-debug /Users/koyaanisqatsi/CLionProjects/prvni_cv/cmake-build-debug /Users/koyaanisqatsi/CLionProjects/prvni_cv/cmake-build-debug/CMakeFiles/prvni_cv.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/prvni_cv.dir/depend

