🗺🤖📈👍 they're all good sdms
===============================

This is the source for the `@goodsdmbot` which posts silly maps species distribution models of totally fictitious species.


## how things work

The bot is supposed to illustrate how "realistic" species distribution maps can be generated using total nonsense. *No species occurance data were ~harmed~ used in this bot*. All that it does is take a matrix of covariates (BioClim, all that jazz, from the [sdmpredictors](https://cran.r-project.org/web/packages/sdmpredictors/index.html) package, randomly generates some coefficients for a subset of the columns and then does the appropriate matrix-vector multiplication. Adfter that, we do a bit of faff to put things on a reasonable scale and then makes a plot. Species names are generated at random by taking a "first" and "last" part of species names.

### "wait, there's no occurance data in this at all??"

This is literally a bot that posts the results of a scaled matrix-vector multiplication -- just like most spatial models make predictions.

## what is what

There are a bunch of files here:

  - `thingo.R` actually generates the maps and posts them to twitter using the [`twurl`](https://github.com/twitter/twurl) command line tool (you might need something to [do the OAuth dance for you](http://v21.io/iwilldancetheoauthdanceforyou/). This can be called from a `cron` job, for example, to post every few hours.
  - `data_setup.R` downloads rasters and then puts them into a `list` of `data.frame`s, one list element for each region. It also records some meta data that will be useful later on. All of this gets saved in `saved.RData` to be called on by `thingo.R`.
  - `sp_names.R` generates fictitious species names, having harvested information from wikipedia. Data gets saved in `sp_names.RData` for use in `thingo.R`.
  - `species_names.txt` species names stolen from wikipedia


