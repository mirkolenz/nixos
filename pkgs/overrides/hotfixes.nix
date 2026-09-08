final: prev:
{ }
// (prev.lib.optionalAttrs prev.stdenv.hostPlatform.isLinux {

  # tests/chip.c's setup_bad_chip() hands setup_chip() a pointer to a copy of chip_bad living in
  # its own frame, so flashctx->chip dangles as soon as the helper returns; every other test in
  # the file keeps that copy in the test function instead. On aarch64 the frame is reused before
  # flashrom_image_write() reads chip->total_size, so the size check rejects the buffer and
  # returns 4 instead of the expected ERROR_FLASHROM_PREPARE_FLASH_ACCESS. Give the copy static
  # storage; the assignment stays separate because chip_bad is not a constant initializer.
  # https://github.com/NixOS/nixpkgs/issues/558302
  flashrom = prev.flashrom.overrideAttrs (prevAttrs: {
    postPatch = (prevAttrs.postPatch or "") + ''
      substituteInPlace tests/chip.c \
        --replace-fail 'struct flashchip mock_chip = chip_bad;' \
                       'static struct flashchip mock_chip; mock_chip = chip_bad;'
    '';
  });

})
// (prev.lib.optionalAttrs prev.stdenv.hostPlatform.isDarwin {
})
