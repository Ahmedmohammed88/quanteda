context("test docvars")

data(data_corpus_irishbudget2010, package = "quanteda.textmodels")

test_that("make_docvars() works", {
    
    docvar1 <- quanteda:::make_docvars(0L, docname = character())
    docvar2 <- quanteda:::make_docvars(3L, docname = c("A", "B", "C"))
    docvar3 <- quanteda:::make_docvars(3L, docname = 1:3)
    docvar4 <- quanteda:::make_docvars(10L)
    docvar5 <- quanteda:::make_docvars(3L, docname = c("A", "B", "B"))

    expect_equal(dim(docvar1), c(0, 3))
    expect_equal(dim(docvar2), c(3, 3))
    expect_equal(dim(docvar3), c(3, 3))
    expect_equal(colnames(docvar1), c("docname_", "docid_", "segid_"))
    expect_equal(colnames(docvar2), c("docname_", "docid_", "segid_"))
    expect_equal(colnames(docvar3), c("docname_", "docid_", "segid_"))

    # expect_equal(colnames(docvar4), c("docname_", "docid_", "segid_"))
    # expect_equal(docvar4[["docname_"]], paste0("text", 1:10))
    # expect_error(quanteda:::make_docvars(n = 2, docname = c("A", "B", "C")))
    # expect_equal(docvar5[["docname_"]], c("A", "B", "B.1"))
    expect_error(quanteda:::make_docvars(n = "3"))
    expect_error(quanteda:::make_docvars(n = 1.4))

    docvar4 <- quanteda:::make_docvars(5L, c("A", "A", "B", "B", "C"))
    expect_equal(docvar4[["docname_"]], c("A.1", "A.2", "B.1", "B.2", "C.1"))
    docvar5 <- quanteda:::make_docvars(5L, c("A", "B", "B", "A", "C"))
    expect_equal(docvar5[["docname_"]], c("A.1", "B.1", "B.2", "A.2", "C.1"))
    docvar6 <- quanteda:::make_docvars(5L, c("A", "A", "B", "B", "C"), unique = FALSE)
    expect_equal(docvar6[["docname_"]], c("A", "A", "B", "B", "C"))
    expect_equal(docvar6[["segid_"]], c(1, 1, 1, 1, 1))

})

test_that("upgrade_docvars() works", {
    
    docvar1 <- data.frame()
    docvar2 <- data.frame("var1" = c(100, 200, 300),
                          "var2" = c(TRUE, TRUE, FALSE))
    docvar2$lis <- list(1:3, -5, 3:4)
    docvar3 <- data.frame("var1" = c(100, 200, 300),
                          "var2" = c(TRUE, TRUE, FALSE),
                          row.names = c("A", "B", "C"))
    docvar3$lis <- list(1:3, -5, 3:4)
    docvar4 <- data.frame("docname_" = c("A", "B", "C"), 
                          "docid_" = factor(c("A", "B", "C")), 
                          "segid_" = rep(1L, 3), 
                          "var1" = c(100, 200, 300),
                          "var2" = c(TRUE, TRUE, FALSE),
                          stringsAsFactors = FALSE)
    docvar4$lis <- list(1:3, -5, 3:4)

    expect_identical(
        quanteda:::upgrade_docvars(docvar1, c("A", "B", "C")),
        docvar4[, 1:3]
    )
    expect_identical(
        quanteda:::upgrade_docvars(docvar3),
                     docvar4
    )
    expect_identical(
        quanteda:::upgrade_docvars(docvar2, c("A", "B", "C")),
        docvar4
    )
    expect_identical(
        quanteda:::upgrade_docvars(docvar2, c("A", "B", "C")),
        docvar4
    )
})

test_that("get_docvars() works", {
    
    data <- data.frame("docname_" = c("A", "B", "C"), 
                       "docid_" = factor(c("A", "B", "C")), 
                       "segid_" = rep(1L, 3), 
                       "var1" = c(100, 200, 300),
                       "var2" = c(TRUE, TRUE, FALSE),
                       stringsAsFactors = FALSE)
    
    expect_identical(
        quanteda:::select_docvars(data, user = FALSE, system = TRUE),
        data.frame("docname_" = c("A", "B", "C"), 
                   "docid_" = factor(c("A", "B", "C")), 
                   "segid_" = rep(1L, 3), 
                   stringsAsFactors = FALSE)
    )
    expect_error(quanteda:::select_docvars(data, "docid_", user = FALSE, system = FALSE))
    expect_identical(
        quanteda:::select_docvars(data, "docid_", user = FALSE, system = TRUE),
        data.frame("docid_" = factor(c("A", "B", "C")), 
                   stringsAsFactors = FALSE)
    )
    expect_identical(
        quanteda:::select_docvars(data, "docid_", user = FALSE, system = TRUE, drop = TRUE),
        factor(c("A", "B", "C"))
    )
    expect_identical(
        quanteda:::select_docvars(data),
        data.frame("var1" = c(100, 200, 300),
                   "var2" = c(TRUE, TRUE, FALSE),
                   stringsAsFactors = FALSE)
    )
    expect_identical(
        quanteda:::select_docvars(data, "var1"),
        data.frame("var1" = c(100, 200, 300), stringsAsFactors = FALSE)
    )
    expect_identical(
        quanteda:::select_docvars(data, "var1", drop = TRUE),
        c(100, 200, 300)
    )
})

test_that("set_docvars() works", {
    
    data <- data.frame("docname_" = c("A", "B", "C"), 
                       "docid_" = c("A", "B", "C"), 
                       "docnum_" = 1L:3L, 
                       "segid_" = rep(1L, 3), 
                       "var1" = c(100, 200, 300),
                       "var2" = c(TRUE, TRUE, FALSE),
                       stringsAsFactors = FALSE)
    
    quanteda:::set_docvars(data, "var2") <- c(10, 20, 30)
    expect_identical(data[["var2"]], c(10, 20, 30))
    quanteda:::set_docvars(data, "var3") <- c(1000, 2000, 3000)
    expect_identical(data[["var3"]], c(1000, 2000, 3000))
    quanteda:::set_docvars(data) <- data.frame("var1" = c(100, 200, 300),
                                               "var2" = c(TRUE, TRUE, TRUE))
    expect_identical(data[["var1"]], c(100, 200, 300))
    expect_identical(data[["var2"]], c(TRUE, TRUE, TRUE))
    expect_identical(names(data), c("docname_", "docid_", "segid_", "var1", "var2"))
    quanteda:::set_docvars(data) <- NULL
    expect_identical(names(data), c("docname_", "docid_", "segid_"))
})

test_that("docvars of corpus is a data.frame", {
    expect_equal(
        class(docvars(data_corpus_inaugural)),
        "data.frame"
    )
})

test_that("docvars with non-existent field names generate correct error messages", {
    expect_error(
        docvars(data_corpus_inaugural, c("President", "nonexistent")),
        "field\\(s\\) nonexistent not found"
    )

    toks <- tokens(data_corpus_inaugural, include_docvars = TRUE)
    expect_error(
        docvars(toks, c("President", "nonexistent")),
        "field\\(s\\) nonexistent not found"
    )
})


test_that("docvars is working with tokens", {
    corp <- data_corpus_inaugural
    toks <- tokens(corp, include_docvars = TRUE)
    expect_equal(docvars(toks), docvars(corp))
    expect_equal(docvars(toks, 'President'), docvars(corp, 'President'))
    
    # Subset
    toks2 <- toks[docvars(toks, 'Year') > 2000]
    expect_equal(ndoc(toks2), nrow(docvars(toks2)))
    
    # # Add field to meta-data
    # expect_equal(
    #     docvars(quanteda:::"docvars<-"(toks2, 'Type', 'Speech'), "Type"), 
    #     rep('Speech', 5)
    # )
    # 
    # # Remove meta-data
    # expect_equal(
    #     docvars(quanteda:::"docvars<-"(toks, field = NULL, NULL)), 
    #     NULL
    # )
    # 
    # # Add fresh meta-data
    # expect_equal(
    #     docvars(quanteda:::"docvars<-"(toks, field = "ID", 1:58), "ID"), 
    #     1:58
    # )
}) 

test_that("metadoc for tokens works", {
    skip("Until we resolve metadoc issues")
    corp <- data_corpus_irishbudget2010
    metadoc(corp, "language") <- "english"
    toks <- tokens(corp, include_docvars = TRUE)
    
    expect_equal(docvars(toks), docvars(corp))
    expect_equal(metadoc(toks), metadoc(corp))
    
    expect_equal(docvars(toks, 'name'), docvars(corp, 'name'))
    
    # Subset
    toks2 <- toks[metadoc(toks, 'language') == "english"]
    expect_equal(ndoc(toks2), nrow(docvars(toks2)))
}) 

test_that("metadoc works with selection", {
    skip("Until we resolve metadoc issues")
    mycorpus <- corpus(c(textone = "This is a sentence.  Another sentence.  Yet another.", 
                         texttwo = "Premiere phrase.  Deuxieme phrase."), 
                       docvars = data.frame(country=c("UK", "USA"), year=c(1990, 2000)),
                       metacorpus = list(notes = "Example showing how corpus_reshape() works."))
    mycorpus_reshaped <- corpus_reshape(mycorpus, to = "sentences")
    expect_equal(metadoc(mycorpus_reshaped, "document"),
                 c("textone", "textone", "textone", "texttwo", "texttwo"))
    expect_equal(
        metadoc(mycorpus_reshaped, c("document", "segid")),
        data.frame("_document" = c("textone", "textone", "textone", "texttwo", "texttwo"),
                   "_segid" = c(1, 2, 3, 1, 2),
                   check.names = FALSE, stringsAsFactors = FALSE,
                   row.names = c(paste0("textone.", 1:3), paste0("texttwo.", 1:2)))
    )
}) 

test_that("docvars is working with dfm", {
    corp <- data_corpus_irishbudget2010
    toks <- tokens(corp, include_docvars = TRUE)
    thedfm <- dfm(toks)
    
    expect_equal(docvars(toks), docvars(thedfm))
    expect_equal(docvars(toks, 'party'), docvars(corp, 'party'))
    
    thedfm2 <- dfm(corp)
    expect_equal(docvars(corp), docvars(thedfm2))
    expect_equal(docvars(corp, 'party'), docvars(thedfm2, 'party'))

    corp2 <- corpus_subset(corp, party == "LAB")
    thedfm3 <- dfm(corp2)    
    expect_equal(docvars(corp2), docvars(thedfm3))
}) 

# test_that("$ returns docvars", {
#     corp <- data_corpus_irishbudget2010
#     toks <- tokens(corp, include_docvars = TRUE)
#     dfmat <- dfm(toks)
#     
#     expect_equal(docvars(corp, "party"), corp$party)
#     expect_equal(docvars(toks, "party"), toks$party)
#     expect_equal(docvars(dfmat, "party"), dfmat$party)
# }) 


test_that("creating tokens and dfms with empty docvars", {
    expect_true(
        length(docvars(tokens(data_corpus_irishbudget2010, include_docvars = FALSE))) == 0
    )
    expect_true(
        length(docvars(dfm(data_corpus_irishbudget2010, include_docvars = FALSE))) == 0
    )
    
})

test_that("tokens works works with one docvar", {
    docv1 <- data.frame(dvar1 = c("A", "B"))
    mycorpus1 <- corpus(c(d1 = "This is sample document one.",
                          d2 = "Here is the second sample document."), 
                        docvars = docv1)
    toks1 <- tokens(mycorpus1, include_docvars = TRUE)
    expect_equivalent(docvars(toks1), docv1)
})


test_that("tokens works works with two docvars", {
    docv2 <- data.frame(dvar1 = c("A", "B"),
                        dvar2 = c(1, 2))
    mycorpus2 <- corpus(c(d1 = "This is sample document one.",
                          d2 = "Here is the second sample document."), 
                        docvars = docv2)
    toks2 <- tokens(mycorpus2, include_docvars = TRUE)
    expect_equivalent(docvars(toks2), docv2)
})

test_that("dfm works works with one docvar", {
    docv1 <- data.frame(dvar1 = c("A", "B"))
    mycorpus1 <- corpus(c(d1 = "This is sample document one.",
                          d2 = "Here is the second sample document."), 
                        docvars = docv1)
    dfm1 <- dfm(mycorpus1, include_docvars = TRUE)
    expect_equivalent(docvars(dfm1), docv1)
})


test_that("dfm works works with two docvars", {
    docv2 <- data.frame(dvar1 = c("A", "B"),
                        dvar2 = c(1, 2))
    mycorpus2 <- corpus(c(d1 = "This is sample document one.",
                          d2 = "Here is the second sample document."), 
                        docvars = docv2)
    dfm2 <- dfm(mycorpus2, include_docvars = TRUE)
    expect_equivalent(docvars(dfm2), docv2)
})

test_that("object always have docvars in the same rows as documents", {
    
    txt <- data_char_ukimmig2010
    corp1 <- corpus(txt)
    expect_true(nrow(docvars(corp1)) == ndoc(corp1))
    expect_true(all(row.names(docvars(corp1)) == seq_len(ndoc(corp1))))
    
    corp2 <- corpus_segment(corp1, "\\p{P}", valuetype = "regex")
    expect_true(nrow(docvars(corp2)) == ndoc(corp2))
    expect_true(all(row.names(docvars(corp2)) == seq_len(ndoc(corp2))))
    
    corp3 <- corpus_reshape(corp1, to = "sentences")
    expect_true(nrow(docvars(corp3)) == ndoc(corp3))
    expect_true(all(row.names(docvars(corp3)) == seq_len(ndoc(corp3))))
    
    corp4 <- corpus_sample(corp1, size = 5)
    expect_true(nrow(docvars(corp4)) == ndoc(corp4))
    expect_true(all(row.names(docvars(corp4)) == seq_len(ndoc(corp4))))
    
    toks1 <- tokens(txt)
    expect_true(nrow(docvars(toks1)) == ndoc(toks1))
    expect_true(all(row.names(docvars(toks1)) == seq_len(ndoc(toks1))))
    
    toks2 <- tokens(corpus(txt))
    expect_true(nrow(docvars(toks2)) == ndoc(toks2))
    expect_true(all(row.names(docvars(toks2)) == seq_len(ndoc(toks2))))
    
    toks3 <- quanteda:::tokens_group(toks1, rep(c(1, 2, 3), 3))
    expect_true(nrow(docvars(toks3)) == ndoc(toks3))
    expect_true(all(row.names(docvars(toks3)) == seq_len(ndoc(toks3))))
    
    toks4 <- tokens_select(toks1, stopwords())
    expect_true(nrow(docvars(toks4)) == ndoc(toks4))
    expect_true(all(row.names(docvars(toks4)) == seq_len(ndoc(toks4))))
    
    dfm1 <- dfm(txt)
    expect_true(nrow(docvars(dfm1)) == ndoc(dfm1))
    expect_true(all(row.names(docvars(dfm1)) == seq_len(ndoc(dfm1))))
    
    dfm2 <- dfm(tokens(txt))
    expect_true(nrow(docvars(dfm2)) == ndoc(dfm2))
    expect_true(all(row.names(docvars(dfm2)) == seq_len(ndoc(dfm2))))
    
    dfm3 <- dfm(corpus(txt))
    expect_true(nrow(docvars(dfm3)) == ndoc(dfm3))
    expect_true(all(row.names(docvars(dfm3)) == seq_len(ndoc(dfm3))))
    
    dfm4 <- dfm_group(dfm1, rep(c(1, 2, 3), 3))
    expect_true(nrow(docvars(dfm4)) == ndoc(dfm4))
    expect_true(all(row.names(docvars(dfm4)) == seq_len(ndoc(dfm4))))
    
    dfm5 <- dfm(dfm1, group = rep(c(1, 2, 3), 3))
    expect_true(nrow(docvars(dfm5)) == ndoc(dfm5))
    expect_true(all(row.names(docvars(dfm5)) == seq_len(ndoc(dfm5))))
    
    dfm6 <- dfm_subset(dfm1, rep(c(TRUE, TRUE, FALSE), 3))
    expect_true(nrow(docvars(dfm6)) == ndoc(dfm6))
    expect_true(all(row.names(docvars(dfm6)) == seq_len(ndoc(dfm6))))
    
    dfm7 <- rbind(dfm1, dfm1)
    expect_true(nrow(docvars(dfm7)) == ndoc(dfm7))
    expect_true(all(row.names(docvars(dfm7)) == seq_len(ndoc(dfm7))))
    
    dfm8 <- suppressWarnings(cbind(dfm1, dfm1))
    expect_true(nrow(docvars(dfm8)) == ndoc(dfm8))
    expect_true(all(row.names(docvars(dfm8)) == seq_len(ndoc(dfm8))))
    
})

test_that("error when nrow and ndoc mismatch", {
    
    toks <- tokens(c("a b c", "b c d", "c d e"))
    expect_error(docvars(toks) <- data.frame(var = c(1, 5)))
    expect_silent(docvars(toks) <- data.frame(var = c(1, 5, 6)))
    expect_error(docvars(toks) <- data.frame(var = c(1, 5, 6, 3)))
    
    mt <- dfm(toks)
    expect_error(docvars(mt) <- data.frame(var = c(1, 5)))
    expect_silent(docvars(mt) <- data.frame(var = c(1, 5, 6)))
    expect_error(docvars(mt) <- data.frame(var = c(1, 5, 6, 3)))
    
})

test_that("assignment of NULL only drop columns", {
    
    toks <- tokens(data_corpus_irishbudget2010)
    docvars(toks) <- NULL
    expect_identical(dim(docvars(toks)), c(14L, 0L))
    
    mt <- dfm(data_corpus_irishbudget2010)
    docvars(mt) <- NULL
    expect_identical(dim(docvars(mt)), c(14L, 0L))
    
})

test_that("can assign docvars when value is a dfm (#1417)", {
    mycorp <- corpus(data_char_ukimmig2010)

    thedfm <- dfm(mycorp)[, "the"]
    docvars(mycorp) <- thedfm
    expect_identical(
        docvars(mycorp),
        data.frame(the = as.vector(thedfm))
    )
    
    anddfm <- dfm(mycorp)[, "and"]
    docvars(anddfm) <- anddfm
    expect_identical(
        docvars(anddfm),
        data.frame(and = as.vector(anddfm))
    )

    toks <- tokens(mycorp)
    docvars(toks) <- anddfm
    expect_identical(
        docvars(toks),
        data.frame(and = as.vector(anddfm))
    )
})

test_that("docvar can be renamed (#1603)", {

    corp <- data_corpus_irishbudget2010
    names(docvars(corp))[c(1, 3)] <- c("time", "order")
    expect_identical(names(docvars(corp)),
                     c("time", "debate", "order", "foren", "name", "party"))
    
    toks <- tokens(data_corpus_irishbudget2010)
    names(docvars(toks))[c(1, 3)] <- c("time", "order")
    expect_identical(names(docvars(toks)),
                     c("time", "debate", "order", "foren", "name", "party"))
    
    dfmt <- dfm(data_corpus_irishbudget2010)
    names(docvars(dfmt))[c(1, 3)] <- c("time", "order")
    expect_identical(names(docvars(dfmt)),
                     c("time", "debate", "order", "foren", "name", "party"))
   
})

test_that("docvar assignment is fully robust including to renaming (#1603)", {
    # assigning a data.frame to blank docars
    corp <- corpus(c("A b c d.", "A a b. B c."))
    docvars(corp) <- data.frame(testdv = 10:11)
    expect_identical(
        docvars(corp),
        data.frame(testdv = 10:11)
    )
    
    # assigning a vector to blank docars
    corp <- corpus(c("A b c d.", "A a b. B c."))
    expect_error(
        docvars(corp) <- c("x", "y"),
        "you must supply field name(s)", fixed = TRUE
    )
    
    # assigning an unnamed matrix as docvars
    docvars(corp) <- matrix(c("x", "y"), ncol = 1)
    expect_identical(
        docvars(corp),
        data.frame(V1 = c("x", "y"), stringsAsFactors = FALSE)
    )
    
    # block assigning a data.frame with missing names
    df <- data.frame(c("x", "y"), c("a", "b"), 11:12, stringsAsFactors = FALSE)
    names(df) <- NULL
    names(df)[2] <- "name2"
    expect_error(docvars(corp) <- df, 
                 "data.frame must have column names")
    
})
 
test_that("docvars<-.corpus and name uniqueness", {
    
    # preexisting docvars keep unique names
    corp <- corpus(c("A b c d.", "A a b. B c."))
    docvars(corp) <- data.frame(docvar1 = 1:2)
    docvars(corp)[2] <- 11:12
    docvars(corp)[3] <- c("a", "b")
    expect_identical(
        docvars(corp),
        data.frame(docvar1 = 1:2, V2 = 11:12, V3 = c("a", "b"), stringsAsFactors = FALSE)
    )
})

test_that("docvars<- NULL removes docvars", {
    
    corp1 <- data_corpus_irishbudget2010
    docvars(corp1)[c(1, 3)] <- NULL
    expect_identical(names(docvars(corp1)),
                     c("debate", "foren", "name", "party"))
    
    corp2 <- data_corpus_irishbudget2010
    docvars(corp2)[c("year", "number")] <- NULL
    expect_identical(names(docvars(corp2)),
                     c("debate", "foren", "name", "party"))
    
    corp3 <- data_corpus_irishbudget2010
    docvars(corp3, c("year", "number")) <- NULL
    expect_identical(names(docvars(corp3)),
                     c("debate", "foren", "name", "party"))
    
    toks <- tokens(data_corpus_irishbudget2010)
    toks1 <- toks
    docvars(toks1)[c(1, 3)] <- NULL
    expect_identical(names(docvars(toks1)),
                     c("debate", "foren", "name", "party"))
    
    toks2 <- toks
    docvars(toks2)[c("year", "number")] <- NULL
    expect_identical(names(docvars(toks2)),
                     c("debate", "foren", "name", "party"))
    
    toks3 <- toks
    docvars(toks3, c("year", "number")) <- NULL
    expect_identical(names(docvars(toks3)),
                     c("debate", "foren", "name", "party"))
    
    dfmt <- dfm(toks)
    dfmt1 <- dfmt
    docvars(dfmt1)[c(1, 3)] <- NULL
    expect_identical(names(docvars(dfmt1)),
                     c("debate", "foren", "name", "party"))
    
    dfmt2 <- dfmt
    docvars(dfmt2)[c("year", "number")] <- NULL
    expect_identical(names(docvars(dfmt2)),
                     c("debate", "foren", "name", "party"))
    
    dfmt3 <- dfmt
    docvars(dfmt3, c("year", "number")) <- NULL
    expect_identical(names(docvars(dfmt3)),
                     c("debate", "foren", "name", "party"))
    
})

test_that("works correctly in edge cases", {
    corp <- corpus(c("A b c d.", "A a b. B c.", "D f. e g.", "H i j."))
    expect_error({docvars(corp) <- 1:4},
                 quanteda:::message_error("docvar_noname"))
    expect_silent({docvars(corp, "var1") <- 1})
    expect_equal(docvars(corp, "var1"), rep(1, 4))
    expect_silent(docvars(corp, "var2") <- 1:4)
    expect_equal(docvars(corp, "var2"), 1:4)
    expect_silent(docvars(corp, "var3") <- 1:2)
    expect_equal(docvars(corp, "var3"), c(1, 2, 1, 2))
    expect_error(docvars(corp, "var4") <- 1:3)
})


test_that("metadoc works but raise deprecation warning", {
    corp <- corpus(c("aa bb cc", "ccc dd"))
    suppressWarnings(expect_equal(colnames(metadoc(corp)), character()))
    suppressWarnings(metadoc(corp, "var1") <- c(1, 5))
    suppressWarnings(metadoc(corp, "var2") <- c("T", "F"))
    suppressWarnings(expect_equal(colnames(metadoc(corp)), c("_var1", "_var2")))
    expect_warning(metadoc(corp), "metadoc is deprecated")
    
    corp <- corpus(c("aa bb cc", "ccc dd"))
    toks <- tokens(corp)
    suppressWarnings(expect_equal(colnames(metadoc(toks)), character()))
    suppressWarnings(metadoc(toks, "var1") <- c(1, 5))
    suppressWarnings(metadoc(toks, "var2") <- c("T", "F"))
    suppressWarnings(expect_equal(colnames(metadoc(toks)), c("_var1", "_var2")))
    expect_warning(metadoc(toks), "metadoc is deprecated")
    
    corp <- corpus(c("aa bb cc", "ccc dd"))
    dfmat <- dfm(corp)
    suppressWarnings(expect_equal(colnames(metadoc(dfmat)), character()))
    suppressWarnings(metadoc(dfmat, "var1") <- c(1, 5))
    suppressWarnings(metadoc(dfmat, "var2") <- c("T", "F"))
    suppressWarnings(expect_equal(colnames(metadoc(dfmat)), c("_var1", "_var2")))
    expect_warning(metadoc(dfmat), "metadoc is deprecated")
})
