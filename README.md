# TAPS Transports Document

This is the source repository for draft-ietf-taps-transports, in fulfillment of item 1 of the IETF TAPS WG charter. *The current revision is -04*.

## Toolchain

This repository is set up with the assumption that editing is done in Markdown (using [kramdown-rfc2629}(https://github.com/cabo/kramdown-rfc2629) syntax), from which xml and txt are generated. To install the toolchain (assuming you have ruby and python installed):

```
# gem install kramdown-rfc2629
# pip install xml2rfc
```

To generate XML and text.

```
$ make
```


*To apply edits to the XML file*, please contact the editors ([Gorry Fairhurst](mailto:gorry@erg.abdn.ac.uk), [Brian Trammell](mailto:ietf@trammell.ch), or [Mirja Kühlewind](mailto:mirjak@tik.ee.ethz.ch)) with diffs.
