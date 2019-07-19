library(data.table)
a <- data.table(id = c(1, 2, 3),
                a = c(3, 4, 5))
b <- data.table(id = c(1, 2),
                b = c(1, 2))
a;b
merge(a, b, by="id", all.x=T)

setkey(a, id)
setkey(b, id)
a[b,]
b[a,]

?merge.data.table




