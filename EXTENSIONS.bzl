load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")

filenames = {
    "unicode_data": "ucd/UnicodeData.txt",
    "east_asian_width": "ucd/EastAsianWidth.txt",
    "grapheme_break_property": "ucd/auxiliary/GraphemeBreakProperty.txt",
    "derived_core_properties": "ucd/DerivedCoreProperties.txt",
    "composition_exclusions": "ucd/CompositionExclusions.txt",
    "case_folding": "ucd/CaseFolding.txt",
    "normalization_test": "ucd/NormalizationTest.txt",
    "grapheme_break_test": "ucd/auxiliary/GraphemeBreakTest.txt",
    "emoji_data": "ucd/emoji/emoji-data.txt"
}

_files = tag_class(attrs = {"version": attr.string()})

def _icu_impl(ctx):

    version = ctx.modules[0].tags.files[0].version

    for k,v in filenames.items():
        print("k: %s" % k)
        http_file(name = k,
                  url  = "https://www.unicode.org/Public/{}/{}".format(
                  version, v))

icu = module_extension(
    implementation = _icu_impl,
    tag_classes = {"files": _files}
)
