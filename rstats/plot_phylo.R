plot_phylo = function(x, type = "unrooted", use.edge.length = TRUE,
                      node.pos = NULL, show.tip.label = TRUE,
                      show.node.label = FALSE, edge.color = "black",
                      edge.width = 1, edge.lty = 1, font = 3, cex = par("cex"),
                      adj = NULL, srt = 0, no.margin = FALSE, root.edge = FALSE,
                      label.offset = 0, underscore = FALSE, x.lim = NULL,
                      y.lim = NULL, direction = "rightwards", lab4ut = NULL,
                      tip.color = "black", plot = TRUE, rotate.tree = 0,
                      open.angle = 0, node.depth = 1, align.tip.label = FALSE, ...) {
  Ntip = length(x$tip.label)
  Nedge = dim(x$edge)[1]
  Nnode = x$Nnode
  ROOT = Ntip + 1
  type = match.arg(type, c("phylogram", "cladogram", "fan", "unrooted", "radial"))
  direction = match.arg(direction, c("rightwards", "leftwards", "upwards", "downwards"))
  if (is.null(x$edge.length)) {
    use.edge.length = FALSE
  }
  if (is.numeric(align.tip.label)) {
    align.tip.label.lty = align.tip.label
    align.tip.label = TRUE
  } else { # assumes is.logical(align.tip.labels) == TRUE
    if (align.tip.label) align.tip.label.lty = 3
  }
  if (align.tip.label) {
    if (type %in% c("unrooted", "radial") || !use.edge.length || is.ultrametric(x)) {
      align.tip.label = FALSE
    }
  }
  ## the order of the last two conditions is important:
  if (type %in% c("unrooted", "radial") || !use.edge.length ||
      is.null(x$root.edge) || !x$root.edge) {
    root.edge = FALSE
  }
  phyloORclado = type %in% c("phylogram", "cladogram")
  horizontal = direction %in% c("rightwards", "leftwards")
  xe = x$edge # to save
  if (phyloORclado) {
    stop("phyloORclado not supported")
  }
  ## 'z' is the tree in postorder order used in calls to .C
  z = reorder(x, order = "postorder")
  if (phyloORclado) {
    stop("phyloORclado not supported")
  } else {
    twopi = 2 * pi
    rotate.tree = twopi * rotate.tree / 360

    if (type != "unrooted") { # for "fan" and "radial" trees (open.angle)
      ## if the tips are not in the same order in tip.label
      ## and in edge[, 2], we must reorder the angles: we
      ## use `xx' to store temporarily the angles
      TIPS = x$edge[which(x$edge[, 2] <= Ntip), 2]
      xx = seq(
        0, twopi * (1 - 1 / Ntip) - twopi * open.angle / 360,
        length.out = Ntip
      )
      theta = double(Ntip)
      theta[TIPS] = xx
      theta = c(theta, numeric(Nnode))
    }

    switch(type, "fan" = {
      theta = C_nodeHeight(z$edge, Nedge, theta)
      if (use.edge.length) {
        r = C_nodeDepthEdgelength(Ntip, Nnode, z$edge, Nedge, z$edge.length)
      } else {
        r = C_nodeDepth(Ntip, Nnode, z$edge, Nedge, node.depth)
        r = 1 / r
      }
      theta = theta + rotate.tree
      if (root.edge) r = r + x$root.edge
      xx = r * cos(theta)
      yy = r * sin(theta)
    }, "unrooted" = {
      nb.sp = C_nodeDepth(Ntip, Nnode, z$edge, Nedge, node.depth)
      XY = if (use.edge.length) {
        unrooted_xy(Ntip, Nnode, z$edge, z$edge.length, nb.sp, rotate.tree)
      } else {
        unrooted_xy(Ntip, Nnode, z$edge, rep(1, Nedge), nb.sp, rotate.tree)
      }
      ## rescale so that we have only positive values
      xx = XY$M[, 1] - min(XY$M[, 1])
      yy = XY$M[, 2] - min(XY$M[, 2])
    }, "radial" = {
      r = C_nodeDepth(Ntip, Nnode, z$edge, Nedge, node.depth)
      r[r == 1] = 0
      r = 1 - r / Ntip
      theta = C_nodeHeight(z$edge, Nedge, theta) + rotate.tree
      xx = r * cos(theta)
      yy = r * sin(theta)
    })
  }
  if (phyloORclado) {
    stop("phyloORclado not supported")
  }
  if (no.margin) par(mai = rep(0, 4))
  if (show.tip.label) nchar.tip.label = nchar(x$tip.label)
  max.yy = max(yy)
  if (is.null(x.lim)) {
    if (phyloORclado) {
      stop("phyloORclado not supported")
    } else {
      switch(type, "fan" = {
        if (show.tip.label) {
          offset = max(nchar.tip.label * 0.018 * max.yy * cex)
          x.lim = range(xx) + c(-offset, offset)
        } else {
          x.lim = range(xx)
        }
      }, "unrooted" = {
        if (show.tip.label) {
          offset = max(nchar.tip.label * 0.018 * max.yy * cex)
          x.lim = c(0 - offset, max(xx) + offset)
        } else {
          x.lim = c(0, max(xx))
        }
      }, "radial" = {
        if (show.tip.label) {
          offset = max(nchar.tip.label * 0.03 * cex)
          x.lim = c(-1 - offset, 1 + offset)
        } else {
          x.lim = c(-1, 1)
        }
      })
    }
  } else if (length(x.lim) == 1) {
    x.lim = c(0, x.lim)
    if (phyloORclado && !horizontal) x.lim[1] = 1
    if (type %in% c("fan", "unrooted") && show.tip.label) {
      x.lim[1] = -max(nchar.tip.label * 0.018 * max.yy * cex)
    }
    if (type == "radial") {
      x.lim[1] =
        if (show.tip.label) {
          -1 - max(nchar.tip.label * 0.03 * cex)
        } else {
          -1
        }
    }
  }
  ## mirror the xx:
  if (phyloORclado && direction == "leftwards") xx = x.lim[2] - xx
  if (is.null(y.lim)) {
    if (phyloORclado) {
      stop("phyloORclado not supported")
    } else {
      switch(type, "fan" = {
        if (show.tip.label) {
          offset = max(nchar.tip.label * 0.018 * max.yy * cex)
          y.lim = c(min(yy) - offset, max.yy + offset)
        } else {
          y.lim = c(min(yy), max.yy)
        }
      }, "unrooted" = {
        if (show.tip.label) {
          offset = max(nchar.tip.label * 0.018 * max.yy * cex)
          y.lim = c(0 - offset, max.yy + offset)
        } else {
          y.lim = c(0, max.yy)
        }
      }, "radial" = {
        if (show.tip.label) {
          offset = max(nchar.tip.label * 0.03 * cex)
          y.lim = c(-1 - offset, 1 + offset)
        } else {
          y.lim = c(-1, 1)
        }
      })
    }
  } else if (length(y.lim) == 1) {
    y.lim = c(0, y.lim)
    if (phyloORclado && horizontal) y.lim[1] = 1
    if (type %in% c("fan", "unrooted") && show.tip.label) {
      y.lim[1] = -max(nchar.tip.label * 0.018 * max.yy * cex)
    }
    if (type == "radial") {
      y.lim[1] = if (show.tip.label) -1 - max(nchar.tip.label * 0.018 * max.yy * cex) else -1
    }
  }
  ## mirror the yy:
  if (phyloORclado && direction == "downwards") yy = y.lim[2] - yy # fix by Klaus
  if (phyloORclado && root.edge) {
    if (direction == "leftwards") x.lim[2] = x.lim[2] + x$root.edge
    if (direction == "downwards") y.lim[2] = y.lim[2] + x$root.edge
  }
  asp = if (type %in% c("fan", "radial", "unrooted")) 1 else NA # fixes by Klaus Schliep (2008-03-28 and 2010-08-12)
  plot.default(
    0, type = "n", xlim = x.lim, ylim = y.lim, xlab = "",
    ylab = "", axes = FALSE, asp = asp, ...
  )
  if (plot) {
    if (is.null(adj)) {
      adj = if (phyloORclado && direction == "leftwards") 1 else 0
    }
    if (type == "phylogram") {
      stop("phyloORclado not supported")
    } else {
      if (type == "fan") {
        ereorder = match(z$edge[, 2], x$edge[, 2])
        if (length(edge.color) > 1) {
          edge.color = rep(edge.color, length.out = Nedge)
          edge.color = edge.color[ereorder]
        }
        if (length(edge.width) > 1) {
          edge.width = rep(edge.width, length.out = Nedge)
          edge.width = edge.width[ereorder]
        }
        if (length(edge.lty) > 1) {
          edge.lty = rep(edge.lty, length.out = Nedge)
          edge.lty = edge.lty[ereorder]
        }
        circular.plot(
          z$edge, Ntip, Nnode, xx, yy, theta,
          r, edge.color, edge.width, edge.lty
        )
      } else {
        cladogram.plot(x$edge, xx, yy, edge.color, edge.width, edge.lty)
      }
    }
    if (root.edge) {
      rootcol = if (length(edge.color) == 1) edge.color else "black"
      rootw = if (length(edge.width) == 1) edge.width else 1
      rootlty = if (length(edge.lty) == 1) edge.lty else 1
      if (type == "fan") {
        tmp = polar2rect(x$root.edge, theta[ROOT])
        segments(0, 0, tmp$x, tmp$y, col = rootcol, lwd = rootw, lty = rootlty)
      } else {
        switch(direction,
          "rightwards" = segments(
            0, yy[ROOT], x$root.edge, yy[ROOT],
            col = rootcol, lwd = rootw, lty = rootlty
          ),
          "leftwards" = segments(
            xx[ROOT], yy[ROOT], xx[ROOT] + x$root.edge, yy[ROOT],
            col = rootcol, lwd = rootw, lty = rootlty
          ),
          "upwards" = segments(
            xx[ROOT], 0, xx[ROOT], x$root.edge,
            col = rootcol, lwd = rootw, lty = rootlty
          ),
          "downwards" = segments(
            xx[ROOT], yy[ROOT], xx[ROOT], yy[ROOT] + x$root.edge,
            col = rootcol, lwd = rootw, lty = rootlty
          )
        )
      }
    }
  }
  L = list(
    type = type, use.edge.length = use.edge.length,
    node.pos = node.pos, node.depth = node.depth,
    show.tip.label = show.tip.label,
    show.node.label = show.node.label, font = font,
    cex = cex, adj = adj, srt = srt, no.margin = no.margin,
    label.offset = label.offset, x.lim = x.lim, y.lim = y.lim,
    direction = direction, tip.color = tip.color,
    Ntip = Ntip, Nnode = Nnode, root.time = x$root.time,
    align.tip.label = align.tip.label
  )
  assign(
    "last_plot.phylo", c(L, list(edge = xe, xx = xx, yy = yy)),
    envir = .PlotPhyloEnv
  )
  invisible(L)
}

circular.plot = function(edge, Ntip, Nnode, xx, yy, theta,
                         r, edge.color, edge.width, edge.lty) {
                        ### 'edge' must be in postorder order
  r0 = r[edge[, 1]]
  r1 = r[edge[, 2]]
  theta0 = theta[edge[, 2]]
  costheta0 = cos(theta0)
  sintheta0 = sin(theta0)

  x0 = r0 * costheta0
  y0 = r0 * sintheta0
  x1 = r1 * costheta0
  y1 = r1 * sintheta0

  segments(x0, y0, x1, y1, col = edge.color, lwd = edge.width, lty = edge.lty)

  tmp = which(diff(edge[, 1]) != 0)
  start = c(1, tmp + 1)
  Nedge = dim(edge)[1]
  end = c(tmp, Nedge)

  ## function dispatching the features to the arcs
  foo = function(edge.feat, default) {
    if (length(edge.feat) == 1) return(as.list(rep(edge.feat, Nnode)))
    edge.feat = rep(edge.feat, length.out = Nedge)
    feat.arc = as.list(rep(default, Nnode))
    for (k in 1:Nnode) {
      tmp = edge.feat[start[k]]
      if (tmp == edge.feat[end[k]]) { # fix by Francois Michonneau (2015-07-24)
        feat.arc[[k]] = tmp
      } else {
        if (nodedegree[k] == 2) {
          feat.arc[[k]] = rep(c(tmp, edge.feat[end[k]]), each = 50)
        }
      }
    }
    feat.arc
  }
  nodedegree = tabulate(edge[, 1L])[-seq_len(Ntip)]
  co = foo(edge.color, "black")
  lw = foo(edge.width, 1)
  ly = foo(edge.lty, 1)

  for (k in 1:Nnode) {
    i = start[k]
    j = end[k]
    X = rep(r[edge[i, 1]], 100)
    Y = seq(theta[edge[i, 2]], theta[edge[j, 2]], length.out = 100)
    x = X * cos(Y)
    y = X * sin(Y)
    x0 = x[-100]
    y0 = y[-100]
    x1 = x[-1]
    y1 = y[-1]
    segments(x0, y0, x1, y1, col = co[[k]], lwd = lw[[k]], lty = ly[[k]])
  }
}

unrooted_xy = function(Ntip, Nnode, edge, edge.length, nb.sp, rotate.tree=0) {
  unrooted_impl = function(parent) {
    edge_indices = which(edge[, 1] == parent$id)
    START = parent$axis - parent$angle / 2
    this_df = NULL
    for (edge_i in edge_indices) {
      h = edge.length[edge_i]
      child_df = tibble::tibble(
        id = edge[edge_i, 2L],
        depth = nb.sp[.data$id],
        angle = parent$angle * .data$depth / parent$depth,
        axis = START + .data$angle / 2,
        x = h * cos(.data$axis) + parent$x,
        y = h * sin(.data$axis) + parent$y,
      )
      START = START + child_df$angle
      this_df = dplyr::bind_rows(this_df, child_df)
      if (child_df$id > Ntip) {
        this_df = dplyr::bind_rows(this_df, unrooted_impl(child_df))
      }
    }
    this_df
  }
  ## `angle': the angle allocated to each node wrt their nb of tips
  ## `axis': the axis of each branch
  root = tibble::tibble(id = Ntip + 1L, x = 0, y = 0, angle = 2 * pi, axis = 0 + rotate.tree, depth = nb.sp[id])
  df = unrooted_impl(root) %>%
    dplyr::bind_rows(root) %>%
    dplyr::arrange(id)
  axe = head(df$axis, Ntip) # the axis of the terminal branches (for export)
  ## make sure that the returned angles are in [-PI, +PI]:
  axe = ifelse(axe > pi, axe - 2 * pi, axe)
  list(M = cbind(df$x, df$y), axe = axe)
}

node.depth = function(phy, method = 1) {
  n = length(phy$tip.label)
  m = phy$Nnode
  N = dim(phy$edge)[1]
  phy = reorder(phy, order = "postorder")
  .C(
    node_depth, as.integer(n),
    as.integer(phy$edge[, 1]), as.integer(phy$edge[, 2]),
    as.integer(N), double(n + m), as.integer(method)
  )[[5]]
}

node.depth.edgelength = function(phy) {
  n = length(phy$tip.label)
  m = phy$Nnode
  N = dim(phy$edge)[1]
  phy = reorder(phy, order = "postorder")
  .C(
    node_depth_edgelength, as.integer(phy$edge[, 1]),
    as.integer(phy$edge[, 2]), as.integer(N),
    as.double(phy$edge.length), double(n + m)
  )[[5]]
}

node.height = function(phy, clado.style = FALSE) {
  n = length(phy$tip.label)
  m = phy$Nnode
  N = dim(phy$edge)[1]

  phy = reorder(phy)
  yy = numeric(n + m)
  e2 = phy$edge[, 2]
  yy[e2[e2 <= n]] = 1:n

  phy = reorder(phy, order = "postorder")
  e1 = phy$edge[, 1]
  e2 = phy$edge[, 2]

  if (clado.style) {
    .C(
      node_height_clado, as.integer(n), as.integer(e1),
      as.integer(e2), as.integer(N), double(n + m), as.double(yy)
    )[[5]]
  } else {
    .C(
      node_height, as.integer(e1), as.integer(e2), as.integer(N),
      as.double(yy)
    )[[4]]
  }
}

C_nodeHeight = function(edge, Nedge, yy) {
  .C(
    node_height, as.integer(edge[, 1]), as.integer(edge[, 2]),
    as.integer(Nedge), as.double(yy)
  )[[4]]
}

C_nodeDepth = function(Ntip, Nnode, edge, Nedge, node.depth) {
  .C(
    node_depth, as.integer(Ntip),
    as.integer(edge[, 1]), as.integer(edge[, 2]),
    as.integer(Nedge), double(Ntip + Nnode), as.integer(node.depth)
  )[[5]]
}

C_nodeDepthEdgelength = function(Ntip, Nnode, edge, Nedge, edge.length) {
  .C(
    node_depth_edgelength, as.integer(edge[, 1]),
    as.integer(edge[, 2]), as.integer(Nedge),
    as.double(edge.length), double(Ntip + Nnode)
  )[[5]]
}

## Function to compute the axis limit
## x: vector of coordinates, must be positive (or at least the largest value)
## lab: vector of labels, length(x) == length(lab)
## sin: size of the device in inches
getLimit = function(x, lab, sin, cex) {
  s = strwidth(lab, "inches", cex = cex) # width of the tip labels
  ## if at least one string is larger than the device,
  ## give 1/3 of the plot for the tip labels:
  if (any(s > sin)) return(1.5 * max(x))
  Limit = 0
  while (any(x > Limit)) {
    i = which.max(x)
    ## 'alp' is the conversion coeff from inches to user coordinates:
    alp = x[i] / (sin - s[i])
    Limit = x[i] + alp * s[i]
    x = x + alp * s
  }
  Limit
}
