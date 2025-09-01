# Directories
SHTOOLS_SRC = /home/rasmitdevkota/projects/SHTOOLS/src
SHTOOLS_LIB = /home/rasmitdevkota/projects/SHTOOLS
MOD_DIR = /usr/local/include/
LIB_DIR = /usr/local/lib
FFTW_LIB = -lfftw3
MATH_LIB = -lm

# Compiler and flags
FC = gfortran
CFLAGS = -O2 -Wall -fPIC

# Source and object files
WRAPPER_SRC = shtools_wrapper.f90
WRAPPER_OBJ = shtools_wrapper.o
LIBRARY_NAME = libwrapper.so

# Install targets
INSTALL_LIB = $(LIB_DIR)/$(LIBRARY_NAME)
INSTALL_MOD = $(MOD_DIR)/shtools.mod

# Targets
all: $(INSTALL_LIB)

# Compile shtools_wrapper.f90 into an object file
$(WRAPPER_OBJ): $(WRAPPER_SRC)
	$(FC) $(CFLAGS) -I$(SHTOOLS_SRC) -c $(WRAPPER_SRC) -o $(WRAPPER_OBJ)

# Link the object file into a shared library
$(INSTALL_LIB): $(WRAPPER_OBJ)
	$(FC) -shared -fPIC -o $(INSTALL_LIB) $(WRAPPER_OBJ) -L$(SHTOOLS_LIB) -lSHTOOLS $(FFTW_LIB) $(MATH_LIB)

# Install module files to the appropriate directory
install-mod:
	@echo "Installing modules..."
	sudo cp $(SHTOOLS_SRC)/*.mod $(MOD_DIR)

# Install the shared library to the system
install-lib: $(INSTALL_LIB)
	@echo "Installing shared library..."
	sudo cp $(INSTALL_LIB) $(LIB_DIR)

# Clean up build files
clean:
	rm -f $(WRAPPER_OBJ) $(INSTALL_LIB)

# Install both the library and the module files
install: install-mod install-lib

.PHONY: all install clean install-lib install-mod
