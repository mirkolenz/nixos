final: prev: let
  useChannel = channel: names: prev.lib.genAttrs names (name: final.${channel}.${name});
in
  (
    useChannel "stable" [
      "poetry"
    ]
  )
  // (
    useChannel "unstable" [
    ]
  )
