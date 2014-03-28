# Historical Demographics of U.S. Religion

This repository contains demographic data about American religion drawn
from historical sources.

Lincoln A. Mullen | <lincoln@lincolnmullen.com> |
http://lincolnmullen.com

## Use of the data

The idea behind putting all this data into a single repository is that
it could be included in a submodule in other repositories that actually
do the analysis. Also, GitHub provides pretty good viewers for `csv` and
GeoJSON/TopoJSON files, so it convenient for browsing the data.

## Citation

If you use data or analysis from this project, please provide a proper
citation. The following format is suggested:

> Mullen, Lincoln A. The Historical Demographics of American Religion.
> 2013--. <http://lincolnmullen.com>

You should probably also cite the sources from which this data is drawn.

## Description of Directories

-   The `data` directory contains all the data organized by source. For
    example, the `data/sarna-2005` directory contains transcriptions of
    the data in the appendix of Jonathan Sarna's *American Judaism*.
    Each such directory contains at least one `csv` file with raw data.
    Each directory also contains a `txt` file with citations and
    explanations for the data. These directories may also contain
    scripts that transform the data (e.g., to make it tidy, or to
    geocode it), as well as the transformed data. In each case you'll
    probably want to look at the `txt` file to see what everything does.
-   The `functions` directory contains generic code that might be reused
    to transform data from multiple sources.

## Contributions

Contributions of data are more than welcome. Just send me a pull request
or [e-mail me][] the data.

## License

The scripts in this repository are all available for use under the MIT
license. Each script should indicate this license.

The data may or not have been gathered by me. In many cases it is my
transcription of historical documents or other sources. I only include
it in this repository if I think it's within fair use or I have
permission. Please see the citations in each directory.

  [e-mail me]: mailto:lincoln@lincolnmullen.com
