/*
 * Copyright (C) 2013-2018 Tildeslash Ltd. All rights reserved.
 */


if ((typeof MMONIT === "undefined") || (!MMONIT)) { var MMONIT = {}; }


/**
 * Declare the MMONIT namespace with common methods, variables and
 * define a few useful prototype functions.
 *
 * @file
 */


/** 
 *  Math related functions
 */
MMONIT.math = function() {
    return {
        /**
         * Round the value to given number of decimals
         * @param Number | value: Value to round
         * @param Number | decimals : (optional) Number of decimal places to round to
         * @return Number: Value rounded to given number of decimal places
         */
        round: function (value, decimals) {
            if (typeof decimals === "undefined") {
                return Math.round(value)
            }
            return +(Math.round(value + "e+" + decimals)  + "e-" + decimals);
        }
    };
}();

