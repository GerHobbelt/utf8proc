load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")

# datafiles; sha256 for version 15.0.0 only
datafiles = {
    "unicode_data": struct(file = "ucd/UnicodeData.txt",
                           sha256 = "806e9aed65037197f1ec85e12be6e8cd870fc5608b4de0fffd990f689f376a73"),
    "east_asian_width": struct(file = "ucd/EastAsianWidth.txt",
                               sha256 = "743e7bc435c04ab1a8459710b1c3cad56eedced5b806b4659b6e69b85d0adf2a"),
    "grapheme_break_property": struct(file = "ucd/auxiliary/GraphemeBreakProperty.txt",
                                      sha256 = "5a0f8748575432f8ff95e1dd5bfaa27bda1a844809e17d6939ee912bba6568a1"),
    "derived_core_properties": struct(file = "ucd/DerivedCoreProperties.txt",
                                      sha256 = "d367290bc0867e6b484c68370530bdd1a08b6b32404601b8c7accaf83e05628d"),
    "composition_exclusions": struct(file = "ucd/CompositionExclusions.txt",
                                     sha256 = "3b019c0a33c3140cbc920c078f4f9af2680ba4f71869c8d4de5190667c70b6a3"),
    "case_folding": struct(file = "ucd/CaseFolding.txt",
                           sha256 = "cdd49e55eae3bbf1f0a3f6580c974a0263cb86a6a08daa10fbf705b4808a56f7"),
    "normalization_test": struct(file = "ucd/NormalizationTest.txt",
                                 sha256 = "fb9ac8cc154a80cad6caac9897af55a4e75176af6f4e2bb6edc2bf8b1d57f326"),
    "grapheme_break_test": struct(file = "ucd/auxiliary/GraphemeBreakTest.txt",
                                  sha256 = "0d2080d0def294a4b7660801cc03ddfe5866ff300c789c2cc1b50fd7802b2d97"),
    "emoji_data": struct(file = "ucd/emoji/emoji-data.txt",
                         sha256 = "29071dba22c72c27783a73016afb8ffaeb025866740791f9c2d0b55cc45a3470")
}

_files = tag_class(attrs = {"version": attr.string()})

def _icu_impl(ctx):

    version = ctx.modules[0].tags.files[0].version

    # print("VERSION: %s" % version)
    for k,v in datafiles.items():
        # print("K: %s" % k)
        http_file(name = k,
                  url  = "https://www.unicode.org/Public/{}/{}".format(version, v.file),
                  sha256 = v.sha256
                  )

icu = module_extension(
    implementation = _icu_impl,
    tag_classes = {"files": _files}
)
