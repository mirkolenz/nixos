{
  dockerTools,
  lib,
}:
args@{
  meta ? { },
  builder ? dockerTools.streamLayeredImage,
  ...
}:
lib.addMetaAttrs meta (
  builder (
    lib.removeAttrs args [
      "meta"
      "builder"
    ]
  )
)
