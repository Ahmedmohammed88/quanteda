% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/character-methods.R
\name{summarize_texts}
\alias{summarize_texts}
\title{Summary statistics on a character vector}
\usage{
summarize_texts(object, tolower = FALSE, ...)
}
\arguments{
\item{object}{corpus to be summarized}

\item{tolower}{convert texts to lower case before counting types}

\item{...}{additional arguments passed through to \code{\link[=tokens]{tokens()}}}
}
\description{
Internal-only function to compute summary statistics on a character object.
}
\examples{
# summarize texts
quanteda:::summarize_texts(c("Testing this text. Second sentence.", "And this one."))
quanteda:::summarize_texts(data_char_ukimmig2010)
summary_ukimmig2010 <- quanteda:::summarize_texts(data_char_ukimmig2010)
head(summary_ukimmig2010)
}
\keyword{char}
\keyword{internal}
