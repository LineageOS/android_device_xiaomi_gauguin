#
# Copyright (C) 2021 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from gauguin device
$(call inherit-product, device/xiaomi/gauguin/device.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Device identifier. This must come after all inclusions.
PRODUCT_NAME := lineage_gauguin
PRODUCT_DEVICE := gauguin
PRODUCT_BRAND := Xiaomi
PRODUCT_MANUFACTURER := Xiaomi

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="gauguin-user 12 RKQ1.200826.002 V14.0.2.0.SJSMIXM release-keys"

# Set BUILD_FINGERPRINT variable to be picked up by both system and vendor build.prop
BUILD_FINGERPRINT := Xiaomi/gauguin_global/gauguin:12/RKQ1.200826.002/V14.0.2.0.SJSMIXM:user/release-keys
