{ config, ... }:
{
  virtualisation.containers.cdi.dynamic.nvidia.enable = config.custom.cuda.enable;
}
