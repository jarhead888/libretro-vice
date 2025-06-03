################################################################################
#
# LIBRETRO_VICE
#
################################################################################
LIBRETRO_VICE_DEPENDENCIES = retroarch
LIBRETRO_VICE_DIR=$(BUILD_DIR)/libretro-vice

$(LIBRETRO_VICE_DIR)/.source:
	mkdir -pv $(LIBRETRO_VICE_DIR)
	cp -raf package/libretro-vice/src/* $(LIBRETRO_VICE_DIR)
	touch $@

$(LIBRETRO_VICE_DIR)/.configured : $(LIBRETRO_VICE_DIR)/.source
	touch $@

libretro-vice-binary: $(LIBRETRO_VICE_DIR)/.configured $(LIBRETRO_VICE_DEPENDENCIES)
	BASE_DIR="$(BASE_DIR)" CFLAGS="$(TARGET_CFLAGS) -I${STAGING_DIR}/usr/include/ -I$(LIBRETRO_VICE_DIR)/" CXXFLAGS="$(TARGET_CXXFLAGS)" LDFLAGS="$(TARGET_LDFLAGS)" CC="$(TARGET_CC)" CXX="$(TARGET_CXX)" $(MAKE) -C $(LIBRETRO_VICE_DIR)/ -f Makefile platform="unix_allwinner_h6"

libretro-vice: libretro-vice-binary
	mkdir -p $(TARGET_DIR)/usr/lib/libretro
	cp -raf $(LIBRETRO_VICE_DIR)/vice_x64_libretro.so $(TARGET_DIR)/usr/lib/libretro/
	$(TARGET_STRIP) $(TARGET_DIR)/usr/lib/libretro/vice_x64_libretro.so

ifeq ($(BR2_PACKAGE_LIBRETRO_VICE), y)
TARGETS += libretro-vice
endif
