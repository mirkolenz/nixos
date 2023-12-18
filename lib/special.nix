lib: {
  mkPodmanExec = attrs:
    lib.concatLines
    (
      lib.mapAttrsToList
      (container: commands: ''podman exec ${container} /bin/sh -c "${lib.concatStringsSep " && " commands}"'')
      attrs
    );
}
