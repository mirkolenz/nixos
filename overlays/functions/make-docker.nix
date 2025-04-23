{
  dockerTools,
  lib,
}:
args@{
  meta ? { },
  builder ? dockerTools.streamLayeredImage,
  ...
}:
lib.addMetaAttrs
  (
    {
      maintainers = with lib.maintainers; [ mirkolenz ];
      platforms = lib.platforms.linux;
    }
    // meta
  )
  (
    builder (
      lib.removeAttrs args [
        "meta"
        "builder"
      ]
    )
  )
