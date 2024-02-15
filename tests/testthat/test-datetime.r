# print(paste('current directory is', getwd(), 'and contains files' , paste(list.files( getwd()), collapse=',')))

context("Date and times")

test_that("Date and Time objects are marshalled correctly", {

  ##########
  # .NET to R
  ##########

  # First, test around the origin of the POSIXct structure, '1970-01-01 00:00', 'UTC' is zero
  testSameInteger(posixct_orig_str)
  testSameInteger('1970-01-01 01:00:00')
  testSameInteger('1969-12-31 23:00:00')

  # test around two daylight savings dates for the test time zone eastern Australia
  # DST skip one hour
  testDotNetToR('2013-10-06 01:59')
  expect_error(testDotNetToR('2013-10-06 02:30')) # TimeZoneInfo complains, rightly so.
  # Note for information that in R:
  # > pctToUtc(as.POSIXct('2013-10-06 02:30', tz=tzIdR_AUest))
  # [1] "2013-10-05 14:00:00 UTC"
  testDotNetToR('2013-10-06 03:01')

  # DST go back one hour; 02:00 to 03:00 happens twice for same date
  testDotNetToR('2013-04-07 01:59')
  # from 02:00 to around 02:32, the CLR base class library and R behave differently when converting to UTC. So be it.

  # FIXME:
  #  Oddly, the following  expect_error() is behaving as expected if run from R, however inside a
  # test_that function, this fails twice (test, and then that the expected error is nevertheless not 'detected'
  # expect_error(testDotNetToR('2013-04-07 02:32'))

  testDotNetToR('2013-04-07 02:33') #from then on same UTC date is returned.
  testDotNetToR('2013-04-07 03:00')

  # we can only test local date times post sometime in 1971 - DST rules for AU EST differ prior to that.
  # Further illustration: consider the output of the following 5 lines, it looks like there is no DST
  # for summer 1971 (meaning January, down under); only kicks in in 1972.
  # pctToUtc(AUest('1970-01-01 11:00'))
  # pctToUtc(AUest('1971-01-01 11:00'))
  # pctToUtc(AUest('1971-07-01 11:00'))
  # pctToUtc(AUest('1972-01-01 11:00'))
  # pctToUtc(AUest('1972-07-01 11:00'))

  pDate <- function(dateStr) {
    if(exists('debug_test') && debug_test) { print(paste('testing', dateStr)) }
  }

  for ( dateStr in post1971_DateStr ) {
    testDotNetToR(dateStr)
    pDate(dateStr)
  }

  # This however must work for all test dates
  for ( dateStr in testDatesStr ) {
    testDotNetToRUTC(dateStr)
    pDate(dateStr)
  }

  # Test that DateTime[] becomes POSIXt vectors of expected length
  secPerDay <- 86400
  testDateStr='2001-01-01'

  testDateSeq <- function(startDateStr, numSeq) {
    dateSeq <- AUest(startDateStr)+numSeq
    d <- createUtcDate(as.character(dateSeq), tzId_AUest)
    dr <- pctToUtc(dateSeq)
    expect_posixct_equal(d, dr, mAct='From CLR', mExp='Expected')
  }
  numDays = 5;
  testDateSeq(testDateStr, (0:(numDays-1))*secPerDay);
  numSecs = 42;
  testDateSeq(testDateStr,(0:(numSecs-1)))

  # Time spans: .NET to R
  # TimeSpan were not handled gracefully. Following tests also check that https://r2clr.codeplex.com/workitem/52 is dealt with
  # TODO broader, relating to that: default unknown value types are handled gracefully
  threePfive_sec <- as.difftime(3.5, units='secs')
  expect_equal( clrCallStatic('System.TimeSpan','FromSeconds', 3.5), expected = threePfive_sec)
  threePfive_min <- as.difftime(3.5, units='mins')
  expect_equal( clrCallStatic('System.TimeSpan','FromMinutes', 3.5), expected = as.difftime(180+30, units='secs'))
  # arrays of timespan
  expect_equal( clrCallStatic(cTypename, "CreateTimeSpanArray", 3.5, as.integer(5)), expected = threePfive_sec + 5*(0:4))

  ##########
  # R to .NET conversions
  ##########

  testRtoClrNoTz('1980-01-01')
  testRtoClrNoTz('1972-01-01')

  # FIXME: expect-error lines pass if run interactively but not if inside a test_that() function call
  # However, there is this DST discrepancy of one hour creeping in sometime in 1971, and before that as well
  # expect_error(testRtoClrNoTz('1971-01-01'))
  # expect_error(testRtoClrNoTz(posixct_orig_str))

  # we can only test local date times post sometime in 1971 - DST rules for AU EST differ prior to that.
  for ( dateStr in post1971_DateStr ) {
    testRtoClrNoTz(dateStr)
    pDate(dateStr)
  }

  # This however must work for all test dates
  for ( dateStr in testDatesStr ) {
    testRtoClrUtc(dateStr)
    pDate(dateStr)
  }

  # The following lines may look puzzling but really do have a purpose.
  # Check  that http://r2clr.codeplex.com/workitem/37 has been fixed The following will crash if not.
  x <- as.Date(testDateStr)
  clrType = clrCallStatic('ClrFacade.ClrFacade', 'GetObjectTypeName', x)
  expect_that( x, equals(as.Date(testDateStr)) );
  x <- as.Date(testDateStr) + 0:3
  clrType = clrCallStatic('ClrFacade.ClrFacade', 'GetObjectTypeName', x)
  expect_that( x[1], equals(as.Date(testDateStr)) );
  expect_that( x[2], equals(as.Date(testDateStr)+1) );
  # End check http://r2clr.codeplex.com/workitem/37

  #### daily sequences
  # Dates
  testDateStr='2001-01-01'; numDays = 5;
  # Note that there no point looking below daily period wuth Date objects. consider:
  # z <- ISOdate(2010, 04, 13, c(0,12))
  # str(unclass(as.Date(z)))
  expect_true( clrCallStatic(cTypename, "CheckIsDailySequence", as.Date(testDateStr) + 0:(numDays-1), testDateStr, as.integer(numDays)))
})
