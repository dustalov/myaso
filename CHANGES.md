Changes in Myaso
================

Version history of the Myaso morphological analyzer is presented in
this document.

v0.3.1
------
- Rewrited from scratch, again.
- POS tagging using the Viterbi algorithm on HMMs.
- TnT data files are used to feed the POS tagger.
- Morphosyntactic model has been separated into [Myasorubka].

v0.3.0
------
- Complete rewrite of Myaso.
- Analyzer works with Tokyo Cabinet Table Database.
- [MULTEXT-East] morphosyntactic model is used.
- Test suite is based on `MiniSpec`.
- Dropped the Ruby 1.8 support, but tested with Ruby 1.9 and
Rubinius.
- [Myasorubka] is used for dictionaries processing.
- [Myaso-Web] interface is opened for everybody.

[MULTEXT-East]: http://nl.ijs.si/ME/
[Myasorubka]: https://github.com/ustalov/myasorubka
[Myaso-Web]: https://github.com/ustalov/myaso-web

v0.2
----
- Actually, I can't remember these changes.

v0.1.2
------
- Stop using `mg` gem.
- Switch to RSpec.

v0.1.1
------
- Grammems splitting on prediction.
- Some 1.8.7 compability fixes, but more work still
required.
- Add `myaso` executable to gemspec.
- Temporarily remove `ruby-debug19` from development
dependencies.

v0.1.0
------
- Implement word morphology prediction by suffix.
- Do not store version information in the VERSION file.
- Runtime is no longer depend on Bundler.

v0.0.4
------
- Converter really works, I've tested.
- Using `shkuph` gem instead of moneta.

v0.0.3
------
- Converter is ready, but I'm not sure that he
works correctly.
- Depend on `ruby-debug` gem at development.
- Add Constants module with useful morphological
constants.

v0.0.2
------
- Jeweler gem helper was replaced by mg + bundler.
- Fast and comfortable persistence over
Moneta/TokyoCabinet.
- Plain Ruby model objects.
- IRB session at `myaso` executable.
- Introducing this `CHANGES.md`.

v0.0.1
------
- Initial release, nothing interesting.
