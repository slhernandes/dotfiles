-- NVIDIA ENVS (NO LONGER USED)
-- hl.env("LIBVA_DRIVER_NAME", "nvidia")
-- hl.env("GBM_BACKEND", "nvidia-drm")
-- hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
-- hl.env("NVD_BACKEND", "direct")
-- hl.env("AQ_DRM_DEVICES", "/dev/dri/card0:/dev/dri/card1")
-- hl.env("AQ_DRM_DEVICES", "/dev/dri/nvidia-gpu:/dev/dri/amd-igpu")

-- AMD Driver
hl.env("__EGL_VENDOR_LIBRARY_FILENAMES", "/usr/share/glvnd/egl_vendor.d/50_mesa.json")
hl.env("AQ_DRM_DEVICES", "/dev/dri/amd-igpu:/dev/dri/nvidia-gpu")

-- Wayland envs
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "gtk3")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("MOZ_ENABLE_WAYLAND", "1")

-- cursor
-- hl.env("HYPRCURSOR_THEME", "McMojave")
-- hl.env("XCURSOR_THEME", "McMojave")
hl.env("HYPRCURSOR_THEME", "AC-Future")
hl.env("XCURSOR_THEME", "AC-Future")
hl.env("HYPRCURSOR_SIZE", "48")
hl.env("XCURSOR_SIZE", "36")
