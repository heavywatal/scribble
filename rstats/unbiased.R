hexp = function(p1, p2 = p1) p1 * (1 - p2)

na = 1000
nb = 2000
pa = 0.2
pb = 0.3
a = rbinom(100000, na, pa)
b = rbinom(100000, nb, pb)
pa_sam = a / na
pb_sam = b / nb

within_sam = mean(hexp(pa_sam) + hexp(pb_sam))
between_sam = mean(hexp(pa_sam, pb_sam) + hexp(pb_sam, pa_sam))

all.equal(between_sam - within_sam, mean((pa_sam - pb_sam) ** 2))

bias = mean(hexp(pa_sam) / (na - 1) + hexp(pb_sam) / (nb - 1))
mean((pa_sam - pb_sam) ** 2) - bias

(pa - pb) ** 2
