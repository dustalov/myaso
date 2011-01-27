Changes in myaso
================

Changes in myaso morphological analyzer releases
are listed here.

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
