
TRS = 0.5
range(x)
x_bin = x >= TRS

scales_one <- function(x, na.rm = TRUE) {
    (x - min(x, na.rm = na.rm)) / (max(x, na.rm = na.rm) - min(x, na.rm = na.rm))
}

