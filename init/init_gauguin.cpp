/*
 * Copyright (c) 2021, The LineageOS Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <android-base/properties.h>
#define _REALLY_INCLUDE_SYS__SYSTEM_PROPERTIES_H_
#include <sys/_system_properties.h>

#include "vendor_init.h"
#include "property_service.h"

void property_override(char const prop[], char const value[]) {
    prop_info *pi;

    pi = (prop_info*) __system_property_find(prop);

    if (pi)
        __system_property_update(pi, value, strlen(value));
    else
        __system_property_add(prop, strlen(prop), value, strlen(value));
}

void load_gauguin() {
    property_override("ro.build.fingerprint", "Xiaomi/gauguin_global/gauguin:11/RKQ1.200826.002/V12.5.2.0.RJSMIXM:user/release-keys");
    property_override("ro.product.brand", "Xiaomi");
    property_override("ro.product.device", "gauguin");
    property_override("ro.product.model", "M2007J17G");
    property_override("ro.boot.product.hardware.sku", "nfc");
}

void load_gauguinpro() {
    property_override("ro.build.fingerprint", "Redmi/gauguinpro/gauguinpro:11/RKQ1.200826.002/V12.5.3.0.RJSCNXM:user/release-keys");
    property_override("ro.product.brand", "Redmi");
    property_override("ro.product.device", "gauguinpro");
    property_override("ro.product.model", "M2007J17C");
    property_override("ro.boot.product.hardware.sku", "nfc");
}

void load_gauguininpro() {
    property_override("ro.build.fingerprint", "Xiaomi/gauguininpro/gauguininpro:11/RKQ1.200826.002/V12.0.1.0.RJSINXM:user/release-keys");
    property_override("ro.product.brand", "Xiaomi");
    property_override("ro.product.device", "gauguininpro");
    property_override("ro.product.model", "M2007J17I");
}

void vendor_load_properties() {
    std::string region = android::base::GetProperty("ro.boot.hwc", "");

    if (region.find("CN") != std::string::npos)
        load_gauguinpro();
    else if (region.find("INDIA") != std::string::npos)
        load_gauguininpro();
    else if (region.find("GLOBAL") != std::string::npos)
        load_gauguin();
}
