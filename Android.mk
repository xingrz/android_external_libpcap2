LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := libpcap2
LOCAL_MODULE_CLASS := SHARED_LIBRARIES

LOCAL_CFLAGS := \
    -D_BSD_SOURCE \
    -DHAVE_CONFIG_H \
    -Dlint \
    -D_U_="__attribute__((__unused__))" \
    -Wall \
    -Werror \
    -Wno-macro-redefined \
    -Wno-pointer-arith \
    -Wno-sign-compare \
    -Wno-unused-parameter \
    -Wno-unused-result \
    -Wno-tautological-compare \

LOCAL_HEADER_LIBRARIES := generated_kernel_headers

PLATFORM_C_SRC :=    pcap-linux.c fad-getad.c
COMMON_C_SRC := pcap.c gencode.c optimize.c nametoaddr.c etherent.c \
                fmtutils.c \
                savefile.c sf-pcap.c sf-pcapng.c pcap-common.c \
                bpf_image.c bpf_filter.c bpf_dump.c
GENERATED_C_SRC = grammar.y

LOCAL_SRC_FILES := $(PLATFORM_C_SRC) \
                   $(COMMON_C_SRC) \
                   $(GENERATED_C_SRC)

LOCAL_YACCFLAGS := -p pcap_

intermediates := $(local-generated-sources-dir)

GEN := $(intermediates)/scanner.c
$(GEN): PRIVATE_CUSTOM_TOOL = $(LEX) -P pcap_ --header-file=$(@:%.c=%.h) --nounput -o $@ $<
$(GEN): $(LOCAL_PATH)/scanner.l
	$(transform-generated-source)
LOCAL_GENERATED_SOURCES += $(GEN)

include $(BUILD_SHARED_LIBRARY)
