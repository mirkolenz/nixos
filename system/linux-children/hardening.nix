{
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [
    "${modulesPath}/profiles/hardened.nix"
  ];

  # Keep default kernel for NVIDIA driver compatibility
  boot.kernelPackages = pkgs.linuxPackages;

  # Re-enable SMT for usable desktop performance
  security.allowSimultaneousMultithreading = true;

  # Allow runtime module loading (NVIDIA, WiFi, etc.)
  security.lockKernelModules = false;

  # Use default allocator for application compatibility
  environment.memoryAllocator.provider = "libc";
}
